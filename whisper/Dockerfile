# CPU-only fallback for Spec 12 dictation. The browser remains the primary
# Whisper runtime; this image runs only when that local path is unavailable.
#
# The VPS has no public DNS/egress by design. Bake the model into the official
# release image so startup copies it to the persistent volume without making a
# runtime download or calling an external transcription service.
FROM ghcr.io/ggml-org/whisper.cpp:main

USER root
COPY whisper/start.sh /usr/local/bin/rt-whisper-start
RUN mkdir -p /opt/rt-whisper/models /models /srv/public/v1 \
 && curl -fsSL --retry 3 --connect-timeout 20 \
      -o /opt/rt-whisper/models/ggml-small-q5_1.bin \
      https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small-q5_1.bin \
 && test -s /opt/rt-whisper/models/ggml-small-q5_1.bin \
 && chmod 0444 /opt/rt-whisper/models/ggml-small-q5_1.bin \
 && chmod 0555 /usr/local/bin/rt-whisper-start
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/rt-whisper-start"]
