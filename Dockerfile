# hadolint ignore=DL3007
FROM debian:bookworm-slim

LABEL \
  title="Open-Stage-Control" \
  authors="Olivier Tremblay-Noel" \
  url="https://hub.docker.com/repository/docker/oliviertremblaynoel/open-stage-control-docker" \
  source="https://github.com/oliviertremblaynoel/open-stage-control-docker"

  # hadolint ignore=DL3008,DL3015,DL4006,DL3047
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ca-certificates gosu xvfb procps xauth \
 && wget "$(wget -qO- https://api.github.com/repos/jean-emmanuel/open-stage-control/releases/latest \
        | grep 'browser_download_url.*amd64.deb' \
        | cut -d '"' -f 4)" \
 && dpkg -i open-stage-control_*.deb || apt-get install -f -y \
 && rm open-stage-control_*.deb \
 && rm -rf /var/lib/apt/lists/*

# Create user/group 1000:1000
RUN groupadd -g 1000 osc && useradd -u 1000 -g 1000 -m osc
ENV HOME=/home/osc

EXPOSE 7777
EXPOSE 8080
VOLUME /session
WORKDIR /session

COPY session /session-default

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=300s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT ["/entrypoint.sh"]
