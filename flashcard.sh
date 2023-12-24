#!/bin/bash

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
    #date '+%F' -d "+1day"
    #
    #sixty_days_ago=$(date +%F -d '60 days ago')
    #if [[ $date < $sixty_days_ago ]]
    #then echo "Date is older than 60 days"
    #fi

    cd $carddir/$1
    cards=$(ls | sed -r "s/\.(int|recto|verso)$//g" | uniq)

    echo -e $altscreen

    for card in $cards; do
      # check if card need learning, if not continue

      echo "card: $card"
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
            # reset step to $first_interval
            valid="true"
            # update date
            ;;
          "h" | "hard")
            # divide step by $step
            valid="true"
            # update date
            ;;
          "e" | "easy")
            # multiply step by $step
            valid="true"
            # update date
            ;;
          "s" | "super easy")
            # multiply step by $step * 2
            valid="true"
            # update date
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
