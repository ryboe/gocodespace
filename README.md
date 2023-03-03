# gocodespace

An Alpine-based codespace for Go development

## Features

These development tools are preinstalled:

* [`gotests`](github.com/cweill/gotests)
* [`gomodifytags`](github.com/fatih/gomodifytags)
* [`impl`](github.com/josharian/impl)
* [`goplay`](github.com/haya14busa/goplay)
* [`delve`](github.com/go-delve/delve/)
* [`golangci-lint`](github.com/golangci/golangci-lint)
* [`gopls`](https://github.com/golang/tools/blob/master/gopls)
* [`gofumpt`](https://github.com/mvdan/gofumpt)
* [`goreleaser`](https://github.com/goreleaser/goreleaser)

## Usage

```jsonc
// .devcontainer/devcontainer.json
{
    "name": "My Go Codespace",
    "image": "ghcr.io/ryboe/gocodespace:1.20",
    // dlv needs these capabilities. It needs to run the ptrace (process trace)
    // syscall, and we need to disable the default seccomp profile applied to
    // docker containers.
    //   https://github.com/go-delve/delve/blob/master/Documentation/faq.md#how-do-i-use-delve-with-docker
    "runArgs": [
        "--cap-add=SYS_PTRACE",
        "--security-opt",
        "seccomp=unconfined"
    ],
    "customizations": {
        "vscode": {
            "settings": {
                // full list of Go extension settings:
                // https://github.com/golang/vscode-go/wiki/settings
                "editor.formatOnSave": true,
                "files.insertFinalNewline": true,
                "files.trimFinalNewlines": true,
                "files.trimTrailingWhitespace": true
            },
            "extensions": [
                "golang.go"
            ]
        }
    }
}
```

## How To Build Locally

```sh
# Build with BuildKit by default. After running this command to install the
# buildx plugin, you can type `docker build` instead of `docker buildx build`.
docker buildx install

# --driver docker-container    run BuildKit engine as a container (moby/buildkit:buildx-stable-1)
# --use                        switch to this new container-based docker engine that you're creating
# --bootstrap                  start moby/buildkit container after it's "created" (pulled, really)
docker builder create --driver docker-container --name mybuilder --use --bootstrap

# --load                       save the image to the local filesystem
# --platform linux/amd64       Codespaces only run on AMD64 processors
# - < Dockerfile               '-' means "don't tar up the current directory and pass it to BuildKit
#                              as a build context". We don't need a build context because we don't
#                              need to copy any files from this repo into the container. The only
#                              thing we need is the Dockerfile, which we're passing by redirecting
#                              it to stdin.
docker image build --load --build-arg GO_VERSION=1.20 --platform linux/amd64 --tag mygocodespace - < Dockerfile
```
