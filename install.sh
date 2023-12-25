#!/bin/bash

bindir="/usr/local/bin"
mandir="/usr/local/man/man1"

chmod +x ./flashcard.sh
cp ./flashcard.sh $bindir/flashcard

cp ./flashcard.1 $mandir/flashcard.1
gzip $mandir/flashcard.1

echo "installed flashcard in $bindir"
echo "installed man page in $mandir"
