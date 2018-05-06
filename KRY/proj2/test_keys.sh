#!/bin/bash

export MESSAGE="0xabcdef0123456789"
export DIFF_TOOL="diff"
export LOGDIR="$(cd $(dirname $0) && pwd)/logs"
export LIMIT="1024"
export LOGFILE="$LOGDIR/out.log"

function clean_files {
    rm -f P Q N E D C M M.ORIG
}

function gen_message {
    LEN=$1
    BYTES=$(echo "$LEN / 8" |bc)
    if [ $BYTES -le 1 ]
    then
        MESSAGE="1"
    else
        MESSAGE=""
        for i in $(seq 1 $(expr $BYTES - 1))
        do
            CHAR="$(hexdump -n 1 -e '1 "%02x"' /dev/urandom)"
            MESSAGE="${MESSAGE}${CHAR}"
        done
    fi
    MESSAGE=$(echo $MESSAGE |sed 's/^0*//')
    export MESSAGE="0x$MESSAGE"
}

function gen_keys {
    BITS=1024
    if [ -n "$1" ]
    then
        BITS="$1"
    fi
    KEYS="$(mktemp /tmp/keys.txt.XXXXXX)"
    ./kry -g $BITS > $KEYS
    RET="$?"
    echo "Ret: $RET"
    cat $KEYS |cut -d' ' -f1 >P
    cat $KEYS |cut -d' ' -f2 >Q
    cat $KEYS |cut -d' ' -f3 >N
    cat $KEYS |cut -d' ' -f4 >E
    cat $KEYS |cut -d' ' -f5 >D
    rm "$KEYS"
}

function encipher {
    ./kry -e "$(cat E)" "$(cat N)" "$MESSAGE" >C
    RET="$?"
    echo "Ret: $RET"
}

function decipher {
    ./kry -d "$(cat D)" "$(cat N)" "$(cat C)" >M
    RET="$?"
    echo "Ret: $RET"
}

function compare {
    LOGNAME="$LOGDIR/$1"
    echo $MESSAGE >M.ORIG
    $DIFF_TOOL M.ORIG M
    DIFFRET=$?
    echo "Diff ret: $DIFFRET"
    if [ "$DIFFRET" != "0" ]
    then
        mkdir -p "$LOGNAME"
        mv P "$LOGNAME/"
        mv Q "$LOGNAME/"
        mv N "$LOGNAME/"
        mv E "$LOGNAME/"
        mv D "$LOGNAME/"
        mv M "$LOGNAME/"
        mv C "$LOGNAME/"
        mv M.ORIG "$LOGNAME/"
    fi
}

function test_size {
    SIZE="$1"
    echo "===================================="
    echo "Modulus size:   $SIZE"
    echo "------------------------------------"
    clean_files
    gen_message $SIZE
    gen_keys $SIZE
    encipher
    decipher
    compare $SIZE
}

if [ -n "$1" ]
then
    export LIMIT="$1"
fi

rm -rf $LOGDIR
mkdir -p $LOGDIR
echo -n "" >$LOGFILE
for i in $(seq 6 $LIMIT)
do
    { time test_size $i ; } 2>&1 |tee -a "$LOGFILE"
    echo "====================================" |tee -a "$LOGFILE"
done

echo "====================================" |tee -a "$LOGFILE"
echo "Errors: $(ls -l $LOGDIR | grep "^d" | wc -l)" |tee -a "$LOGFILE"
ls $LOGDIR |tee -a "$LOGFILE"
echo "====================================" |tee -a "$LOGFILE"
