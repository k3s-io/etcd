#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo usage: $0 TAG
    exit 1
fi

if [ -n "$(git tag -l $1)" ]; then
    echo $1 tag exists run
    echo "    " git tag -d $1
    exit 1
fi

for i in */; do
    if [ -f $i/go.mod ]; then
	git tag -d $i$1 2>/dev/null || true
        git tag $i$1
    	echo git push '$REMOTE' $i$1
    fi
done
echo git push '$REMOTE' $1
