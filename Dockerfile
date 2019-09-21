FROM registry.gitlab.com/jitesoft/dockerfiles/keybase:latest
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/keybase-sshca" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/keybase/issues-sshca" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/keybase-sshca"

ARG VERSION

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

COPY ./entrypoint /usr/bin/
USER root

RUN cd ~ \
 && apt-get update \
 && apt-get install -y openssh-client \
 && curl -OsSL https://github.com/keybase/bot-sshca/releases/download/${VERSION}/keybaseca-linux \
 && mv keybaseca-linux /usr/bin/keybaseca \
 && chmod +x /usr/bin/keybaseca /usr/bin/entrypoint \
 && chown -R keybase:keybase /keybase \
 && rm -rf /var/lib/apt/lists/*

USER keybase
ENTRYPOINT ["entrypoint"]
CMD ["keybaseca", "service"]
