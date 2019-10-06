# syntax = docker/dockerfile:experimental
FROM --platform=$BUILDPLATFORM registry.gitlab.com/jitesoft/dockerfiles/go:latest as stage0
ARG TARGETARCH
ARG VERSION
ENV GOARCH="${TARGETARCH}" \
    GO111MODULE="on"

RUN apk add --no-cache tar curl \
 && mkdir -p ${GOPATH}/github.com/keybase/bot-sshca \
 && curl -L https://github.com/keybase/bot-sshca/archive/${VERSION}.tar.gz -o /tmp/kssh-bot.tar.gz \
 && tar -xzf /tmp/kssh-bot.tar.gz -C ${GOPATH}/github.com/keybase/bot-sshca --strip-components=1 \
 && go build -ldflags "-w -s -X main.VersionNumber=$VERSION" ${GOPATH}/github.com/keybase/bot-sshca/src/cmd/keybaseca/keybaseca.go \
 && mv ./keybaseca /usr/bin/keybaseca

FROM registry.gitlab.com/jitesoft/dockerfiles/keybase/alpine:latest
ARG VERSION="1.1.0-de27ce6"
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/keybase-sshca" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/keybase/issues-sshca" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/keybase-sshca" \
      com.jitesoft.app.keybase.ssh-ca="${VERSION}"

USER root
COPY --from=stage0 /usr/bin/keybaseca /usr/local/bin/keybaseca
COPY ./entrypoint /usr/local/bin/entrypoint

RUN apk add --no-cache openssh-client ca-certificates \
 && chmod +x /usr/local/bin/keybaseca \
 && chmod +x /usr/local/bin/entrypoint

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
CMD ["keybaseca", "--help"]
