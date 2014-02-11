#!/bin/sh
set -ue

test $# -le 3 && { echo "Usage: $0 <in-queue> <out-queue> <err-queue> <command>"; exit 1; }

inq=$1;
outq=$2;
errq=$3;
command=$4

while true; do
    job=$(redis-cli --raw BRPOPLPUSH $inq $inq.process 0);
    echo "GOT JOB: $job";

    command=$(echo "$command" | sed -e "s/{}/$job/g")
    echo "# command is: '$command'"
    ( sh -c "$command $job" ) && {
        echo "OK: $job";
        redis-cli --raw LREM "$inq.process" -1 "$job";
        redis-cli --raw LPUSH $outq "$job";
        continue;
    };

    echo "FAILED: $? $job";
    redis-cli --raw LPUSH $errq "$job";
    sleep 2;
done

