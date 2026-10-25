# CPU-only fallback for Spec 12 dictation.  The browser remains the primary
# Whisper runtime; this image runs only when that local path is unavailable.
FROM ghcr.io/ggml-org/whisper.cpp:main

USER root
COPY whisper/start.sh /usr/local/bin/rt-whisper-start
RUN chmod 0555 /usr/local/bin/rt-whisper-start && mkdir -p /models /srv/public/v1
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/rt-whisper-start"]
