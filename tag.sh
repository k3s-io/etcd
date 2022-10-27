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

git tag $1
TAGS="refs/tags/$1"

git tag client/${1/v3./v2.30}
TAGS="$TAGS client/${1/v3./v2.30}"

for i in */; do
  if [ -f $i/go.mod ]; then
	  git tag -d $i$1 2>/dev/null || true
    git tag $i$1
    TAGS="$TAGS refs/tags/$i$1"
  fi
done

echo git push '$REMOTE' "$TAGS"
