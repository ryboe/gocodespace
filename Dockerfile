# syntax=docker/dockerfile:1
ARG GO_VERSION
FROM golang:${GO_VERSION}-alpine AS goimage

FROM ghcr.io/ryboe/alpinecodespace:latest

COPY --from=goimage /usr/local/go/ /usr/local/go/

ENV PATH="${HOME}/go/bin:/usr/local/go/bin:${PATH}"

# These are all the tools installed by the "Go: Install/Update Tools"
# command, plus gofumpt. gofumpt is a stricter gofmt that enforces additional
# formatting rules for better consistency and readabilty.
RUN <<-EOT
  go install github.com/cweill/gotests/gotests@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/josharian/impl@latest
  go install github.com/haya14busa/goplay/cmd/goplay@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  go install golang.org/x/tools/gopls@latest
  go install mvdan.cc/gofumpt@latest
  sudo rm -rf $HOME/go/pkg/*
EOT

# Install the latest release of goreleaser.
RUN <<-EOT
  wget --quiet --timeout=30 --output-document=- 'https://api.github.com/repos/goreleaser/goreleaser/releases/latest' |
  jq -r ".assets[] | select(.name | test(\"goreleaser_.*?_x86_64.apk\")).browser_download_url" |
  wget --quiet --timeout=180 --input-file=- --output-document=/tmp/goreleaser.apk
  sudo apk add --no-cache --allow-untrusted /tmp/goreleaser.apk
  rm /tmp/goreleaser.apk
EOT
