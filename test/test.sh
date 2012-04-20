#!/bin/sh

set -e

BIN=$(cd $(dirname $0)/.. > /dev/null; find $PWD | grep '/no-more-gitkeep.sh$' | head -1)

# mktemp isn't posix specified?!
# http://stackoverflow.com/questions/2792675/how-portable-is-mktemp1
cd $(mktemp -d)

git init repo
cd repo
mkdir emptydir
touch emptydir/.gitkeep
mkdir fulldir
touch fulldir/.gitkeep
echo hello > fulldir/hello.txt

mkdir nested
mkdir nested/empty
touch nested/empty/.gitkeep
mkdir nested/full
touch nested/full/.gitkeep
echo hello > nested/full/hello.txt

git add .
git commit -m 'Initial commit (no-more-gitkeep test)'

$BIN .

# files that should still be there
test -e emptydir/.gitkeep
test -e fulldir/hello.txt
test -e nested/empty/.gitkeep
test -e nested/full/hello.txt

# files that should no longer exist
test ! -e fulldir/.gitkeep
test ! -e nested/full/.gitkeep
