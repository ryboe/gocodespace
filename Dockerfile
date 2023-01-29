# syntax=docker/dockerfile:1
ARG GO_VERSION
FROM golang:${GO_VERSION}-alpine AS goimage

FROM ghcr.io/ryboe/alpinecodespace:latest

COPY --from=goimage /usr/local/go/ /usr/local/go/

ENV PATH="${HOME}/go/bin:/usr/local/go/bin:${PATH}"

# These are all the tools installed by the "Go: Install/Update Tools"
# command.
RUN go install github.com/cweill/gotests/gotests@latest
RUN go install github.com/fatih/gomodifytags@latest
RUN go install github.com/josharian/impl@latest
RUN go install github.com/haya14busa/goplay/cmd/goplay@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
RUN go install golang.org/x/tools/gopls@latest

# This is a stricter gofmt that enforces additional formatting rules for better
# consistency and readabilty.
RUN go install mvdan.cc/gofumpt@latest
