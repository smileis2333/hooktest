#!/bin/bash

refname="$1"
oldrev="$2"
newrev="$3"

if [ -z "$GIT_DIR" ]; then
    echo "Don't run this script from the command line." >&2
    echo " (if you want, you could supply GIT_DIR then run" >&2
    echo "  $0 <ref> <oldrev> <newrev>)" >&2
    exit 1
fi

if [ -z "$refname" -o -z "$oldrev" -o -z "$newrev" ]; then
    echo "usage: $0 <ref> <oldrev> <newrev>" >&2
    exit 1
fi

#echo DEBUG "$refname" "$oldrev" "$newrev"

for rev in `git rev-list "$oldrev".."$newrev"`; do
    message=`git cat-file commit "$rev" | sed '1,/^$/d'`
    if echo "$message" | grep -q "^Merge branch .* of .*"; then
        echo COMMIT: "$rev"
        echo MESSAGE: "$message"
        echo "POLICY: You may use git pull, use git pull --rebase instead."
        exit 1
    fi
    if echo "$message" | grep -q "^Merge remote-tracking branch"; then
        echo COMMIT: "$rev"
        echo MESSAGE: "$message"
        echo "POLICY: You may merge upstream branch, use rebase instead."
        exit 1
    fi
done
