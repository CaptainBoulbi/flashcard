#!/bin/bash

carddir=/home/cptbb/dev/flashcard/card

first_interval="1"
step="2"

bold="\033[1m"
underline="\033[4m"
nocolor="\033[0m"

case $1 in
  "")
    tree -d $carddir
    ;;

  "list")
    ls $carddir/$2 | sed -r "s/\.(int|recto|verso)$//g" | uniq
    ;;

  "get")
    case $2 in
      "recto" | "verso" | "int")
        cat $carddir/$3.$2
        ;;
      *)
        echo -e $bold$underline"interval:"$nocolor
        cat $carddir/$2.int

        echo -e $bold$underline"recto:"$nocolor
        cat $carddir/$2.recto

        echo -e $bold$underline"verso:"$nocolor
        cat $carddir/$2.verso
        ;;
    esac
    ;;

  "edit")
    case $2 in
      "recto")
        if [[ $4 == "from" ]]; then
          cp $5 $carddir/$3.recto
        else
          echo $4 > $carddir/$3.recto
        fi

        [ -f $carddir/$3.int ] || {
          echo $first_interval > $carddir/$3.int
        }
        ;;

      "verso")
        if [[ $4 == "from" ]]; then
          cp $5 $carddir/$3.verso
        else
          echo $4 > $carddir/$3.verso
        fi

        [ -f $carddir/$3.int ] || {
          echo $first_interval > $carddir/$3.int
        }
        ;;

      *)
        if [[ "$3" == "from" && "$5" == "from" ]]; then
          cp $4 $carddir/$2.recto
          cp $6 $carddir/$2.verso
        elif [[ "$3" == "from" ]]; then
          cp $4 $carddir/$2.recto
          echo $5 > $carddir/$2.verso
        elif [[ "$4" == "from" ]]; then
          echo $3 > $carddir/$2.recto
          cp $5 $carddir/$2.verso
        else
          echo $3 > $carddir/$2.recto
          echo $4 > $carddir/$2.verso
        fi

        [ -f $carddir/$2.int ] || {
          echo $first_interval > $carddir/$2.int
        }
        ;;
      esac
    ;;

  *)
    echo "learned"
    ;;
esac
