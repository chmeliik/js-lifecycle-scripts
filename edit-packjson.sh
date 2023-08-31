#!/bin/bash
set -o errexit -o nounset -o pipefail

if [[ -n "${1:-}" ]]; then
    identifier=$1
else
    git_branch=$(git rev-parse --abbrev-ref HEAD)
    identifier=$git_branch
fi

pwn_me_in_dir=/tmp/js-lifecycle/$identifier

jq < package.json --arg mydir "$pwn_me_in_dir" '
    .scripts = .scripts + {
        "preinstall": "mkdir -p \($mydir); touch \($mydir)/preinstall.txt",
        "install": "mkdir -p \($mydir); touch \($mydir)/install.txt",
        "postinstall": "mkdir -p \($mydir); touch \($mydir)/postinstall.txt",
        "prepublish": "mkdir -p \($mydir); touch \($mydir)/prepublish.txt",
        "preprepare": "mkdir -p \($mydir); touch \($mydir)/preprepare.txt",
        "prepare": "mkdir -p \($mydir); touch \($mydir)/prepare.txt",
        "postprepare": "mkdir -p \($mydir); touch \($mydir)/postprepare.txt",
        "prepack": "mkdir -p \($mydir); touch \($mydir)/prepack.txt",
        "postpack": "mkdir -p \($mydir); touch \($mydir)/postpack.txt",
        "dependencies": "mkdir -p \($mydir); touch \($mydir)/dependencies.txt"
    } |
    .dependencies = .dependencies + {
        "fecha": "4.2.3"
    }
' > package.json.tmp

mv package.json.tmp package.json
