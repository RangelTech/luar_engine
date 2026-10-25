#!/bin/sh
set -eu

# The quantized model is baked into the signed release artifact, then cached on
# the persistent /models volume. Runtime makes no external request and uses no GPU.
model=/models/ggml-small-q5_1.bin
if [ ! -s "$model" ]; then
  cp /opt/rt-whisper/models/ggml-small-q5_1.bin "$model.part"
  mv "$model.part" "$model"
fi

# Static health response; inference itself remains internal-only in the stack.
mkdir -p /srv/public/v1
printf '{"object":"list","data":[]}' > /srv/public/v1/models
# whisper-server writes its transient ffmpeg conversion beside its working
# directory. The image root is read-only in production, so run it from the
# writable mounted public directory rather than failing every upload.
cd /srv/public
exec whisper-server --host 0.0.0.0 --port 8080 --threads 3 --language pt \
  --convert --public /srv/public --model "$model"
