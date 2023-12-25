#!/bin/bash
# install the program at /usr/local/bin/flashcard

# should be /usr/local/flashcard
carddir=/home/cptbb/dev/flashcard/card

first_interval="1"
step="2"

bold="\033[1m"
underline="\033[4m"
nocolor="\033[0m"
clear="\033[2J\033[0;0H"
altscreen="\033[?1049h\033[H"
exit_altscreen="\033[?1049l"

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
        mkdir -p $carddir/${3%/*}
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
        mkdir -p $carddir/${3%/*}
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
        mkdir -p $carddir/${2%/*}
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
    cd $carddir/$1
    cards=$(ls | sed -r "s/\.(int|recto|verso)$//g" | uniq | shuf)

    echo -e $altscreen

    nocard="true"
    for card in $cards; do
      date=$(sed -n '2 p' $card.int)
      [[ $2 != "force" && $(date "+%F") < $date ]] && continue

      nocard="false"
      interval=$(sed -n '1 p' $card.int)
      [ $interval -eq 0 ] && interval=1

      echo "card $card:"
      cat $card.recto
      echo -e "\npress enter to get the verso or enter quit to quit."

      read quit
      [[ $quit == "quit" ]] && exit

      echo "verso:"
      cat $card.verso

      while [[ $valid != "true" ]]; do
        echo -e "\n(r)Reset - (h)Hard - (e)Easy - (s)Super Easy - (q)Quit"
        read reponse

        case $reponse in
          "q" | "quit")
            exit
            ;;
          "r" | "reset")
            echo $first_interval > $card.int
            date "+%F" -d "+$first_interval day" >> $card.int
            valid="true"
            ;;
          "h" | "hard")
            interval=$(expr $interval \/ $step)
            echo $interval > $card.int
            date "+%F" -d "+$interval day" >> $card.int
            valid="true"
            ;;
          "e" | "easy")
            interval=$(expr $interval \* $step)
            echo $interval > $card.int
            date "+%F" -d "+$interval day" >> $card.int
            valid="true"
            ;;
          "s" | "super easy")
            interval=$(expr $interval \* $step \* 2)
            echo $interval > $card.int
            date "+%F" -d "+$interval day" >> $card.int
            valid="true"
            ;;
          *)
            echo "value not valid"
            ;;
        esac
      done
      valid="false"

      echo -e $clear
    done

    echo -e $exit_altscreen
    ;;
esac

[[ "$nocard" == "true" ]] && echo "no card to learn for today"
