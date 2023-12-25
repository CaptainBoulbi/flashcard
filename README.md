# NAME

flashcard - cli flashcard based on the leitner system

# DESCRIPTION

flashcard  is  a  flashcard  system based on the leitner system and inspired by the
anki app.

When you study a card, it will choose when to show you the card again based on your
performance.

It  calculate  when  to  show you the card by * 2, * 4 or / 2 the amount of day you
waited to get this card and add it to the current day.

You can modifie of create new deck/card manualy in /usr/local/flashcard by  default
unless config changed by user.

you can find the same information in the flashcard man page, after install do ```man flashcard```

# CONFIGURATION

You can choose where the flashcard directory is in flashcard.sh

default:
```sh
carddir=/usr/local/flashcard
```

# INSTALL

To install the script and the man page do:
```sh
chmod +x ./install.sh
sudo ./install.sh
```

# SYNOPSIS

- **flashcard**
- **flashcard** **list** _deck-name_
- **flashcard** **get** [**int|recto|verso**] _card-name_
- **flashcard** **edit recto|verso** _card-name value_ | (**from** _file_)
- **flashcard** **edit** _card-name recto-value_ | (**from** _file_) _verso-value_ | (**from** _file)
- **flashcard** _deck-name_ [**force**]

# USAGE
- **flashcard**

With  no  arguments  passed,  flashcard  will by default show a tree of your
decks and categories

- **flashcard list dico**

List all the card in the dico deck

- **flashcard get recto dico/grass**

Return the recto of grass card in dico deck.
Will do the same with verso and int, int means interval, it contain the num‐
ber of day to wait and the date the card is unlocked

- **flashcard edit verso dico/grass 'litle green thing that we need to touch more'**
- **flashcard edit recto dico/grass from ./grass-definition.txt**

Change  or  create  the  recto or verso face of grass card of dico deck with
specified value or from a file

- **flashcard edit dico/grass 'grass noun /ɡrɑːs/' grass definition**
- **flashcard edit dico/grass 'grass noun /ɡrɑːs/' from ./grass-definition.txt**
- **flashcard edit dico/grass from ./grass-info.txt grass definition**
- **flashcard edit dico/grass from ./grass-info.txt from ./grass-definition.txt**

Change or create first the recto and then the verso with specified value  or
from file.  Source can be different for recto and verso

- **flashcard dico [force]**

Will  play  the  cards  in  dico that are unlocked for today and will update
there new date.
force is optional, it will force playing all the card even if locked.
