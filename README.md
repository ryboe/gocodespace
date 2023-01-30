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

## Usage

```jsonc
// .devcontainer/devcontainer.json
{
    "name": "My Go Codespace",
    "image": "ghcr.io/ryboe/gocodespace:1.19",
    // dlv needs these capabilities. It needs to run the ptrace (process trace)
    // syscall, and we need to disable the default seccomp profile applied to
    // docker containers.
    //   https://github.com/go-delve/delve/blob/master/Documentation/faq.md#how-do-i-use-delve-with-docker
    "runArgs": [
        "--cap-add=SYS_PTRACE",
        "--security-opt",
        "seccomp=unconfined"
    ],
    "settings": {
        // full list of Go extension settings: https://github.com/golang/vscode-go/wiki/settings
        "editor.formatOnSave": true,
        "files.insertFinalNewline": true,
        "files.trimFinalNewlines": true,
        "files.trimTrailingWhitespace": true
    },
    "extensions": [
        "golang.go"
    ]
}
```
