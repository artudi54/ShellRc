#!/bin/bash
if [[ $# -ne 0 ]]; then
    echo "Error - Invalid number of arguments provided" 1>&2
    exit 1
fi

branch=$(git branch 2>/dev/null)
if [[ $? -ne 0 ]]; then
    echo "Error - not in a git repository" 1>2&
    exit 2
fi
branch=$(echo "$branch" | grep '*' | awk '{ print $2 }')

if [[ -z "$branch" ]]; then
    echo "Error - repository has no branches yet" 1>&2
    exit 3
elif [[ "$branch" = "master" ]]; then
    echo "Error - already on master branch" 1>&2
    exit 4
fi

git checkout master 2>/dev/null

if [[ $? -ne 0 ]]; then
    echo "Error - could not change branch to master" 1>&2
    exit 5
fi

git merge "$branch"
result=$?
git checkout "$branch"

if [[ $? -ne 0 ]]; then
    exit 6
fi

