#! /usr/bin/env bash

set -eo pipefail

[[ $(echo "$1" | grep '^git@' -q) ]] && \
    echo "not a valid git url (git@host:user/repo.git)" && \
    exit 1

[[ -z $GITGET_HOME ]] && GITGET_HOME=$HOME/Code
[[ ! -e $GITGET_HOME ]] && mkdir -p $GITGET_HOME

url=$1; shift
parts=( $(echo $url | sed -E 's/^git@(.*)\:(.+)\/(.+).git.*$/\1 \2 \3/g') )

[[ ${#parts[@]} -ne 3 ]] && \
    echo "error parsing url: \'${url}\'" && \
    exit 1

basedir=$GITGET_HOME/${parts[0]}/${parts[1]}
mkdir -pv $basedir && git clone $@ $url $basedir/${parts[2]}
echo $basedir/${parts[2]} | pbcopy
