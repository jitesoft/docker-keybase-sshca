# syntax = docker/dockerfile:experimental
FROM registry.gitlab.com/jitesoft/dockerfiles/keybase:latest
ARG VERSION
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/keybase-sshca" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/keybase/issues-sshca" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/keybase-sshca" \
      com.jitesoft.app.keybase.ssh-ca="${VERSION}"

USER root
RUN --mount=type=bind,source=./binaries,target=/tmp/bin \
    cp /tmp/bin/entrypoint /tmp/bin/keybaseca /usr/local/bin \
 && apt-get update \
 && mkdir /var/log/keybase \
 && chown keybase:keybase /var/log/keybase \
 && apt-get install -y openssh-client ca-certificates \
 && chmod -R +x /usr/local/bin \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

USER keybase
ENV TEAMS="" \
    KEYBASE_USERNAME="" \
    KEYBASE_PAPERKEY="" \
    KEYBASE_USERNAME_PATH="" \
    KEYBASE_PAPERKEY_PATH="" \
    STRICT_LOGGING="false" \
    CHAT_CHANNEL="" \
    ANNOUNCEMENT="Hello! I'm {USERNAME} and I'm an SSH bot! See github.com/keybase/bot-sshca for information on using Keybase for SSH." \
    CA_KEY_LOCATION="/home/keybase/ca-cert" \
    KEY_EXPIRATION="+12h" \
    KEYBASE_SSHCA_LOG_DIR="/home/keybase/.cache/keybase"

ENTRYPOINT ["entrypoint"]
CMD ["keybaseca", "service"]
