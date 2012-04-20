#!/bin/sh

# tests for no-more-gitkeep.sh

# MIT License Copyright (c) 2012 Mark Rushakoff
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e

fail()
{
    echo "$1" 1>&2
    false
}

should_exist()
{
    test -e "$1" || fail "Expected file $1 to exist, but it didn't"
}

should_not_exist()
{
    test ! -e "$1" || fail "Expected file $1 not to exist, but it did"
}

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

should_exist emptydir/.gitkeep
should_exist fulldir/hello.txt
should_exist nested/empty/.gitkeep
should_exist nested/full/hello.txt

should_not_exist fulldir/.gitkeep
should_not_exist nested/full/.gitkeep

echo 'Tests passed'
