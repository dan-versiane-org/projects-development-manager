#! /bin/bash

BUMP_LEVEL=$1

if [ -z $BUMP_LEVEL ]; then
  BUMP_LEVEL="patch"
fi

echo "Bump ${BUMP_LEVEL} version"

CUR_VERSION="$(cat version.md)"
if [ ! $CUR_VERSION ]; then
  CUR_VERSION="v0.0.0"
fi
RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'

MAJOR=`echo $CUR_VERSION | sed -e "s#$RE#\1#"`
MINOR=`echo $CUR_VERSION | sed -e "s#$RE#\2#"`
PATCH=`echo $CUR_VERSION | sed -e "s#$RE#\3#"`

case "$BUMP_LEVEL" in
  major)
    let MAJOR+=1
    let MINOR=0
    let PATCH=0
    ;;
  minor)
    let MINOR+=1
    let PATCH=0
    ;;
  patch)
    let PATCH+=1
    ;;
esac

NEXT_VERSION="v$MAJOR.$MINOR.$PATCH"
echo "Next version: ${NEXT_VERSION}"

echo $NEXT_VERSION > "version.md"

git add version.md
git commit -m "Bump version to ${NEXT_VERSION}"
