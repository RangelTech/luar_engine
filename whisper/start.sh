#!/bin/sh
set -eu

# The quantized model is cached on the persistent /models volume. It is never
# downloaded per request and this container never uses a GPU.
model=/models/ggml-small-q5_1.bin
if [ ! -s "$model" ]; then
  curl -fL --retry 3 --connect-timeout 20 \
    -o "$model.part" \
    https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small-q5_1.bin
  mv "$model.part" "$model"
fi

# Static health response; inference itself remains internal-only in the stack.
printf '{"object":"list","data":[]}' > /srv/public/v1/models
exec whisper-server --host 0.0.0.0 --port 8080 --threads 3 --language pt \
  --convert --public /srv/public --model "$model"
