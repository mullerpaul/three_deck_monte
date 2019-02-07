Three Deck Monte
================

From fivethirtyeight.com's weekly [Riddler column][https://fivethirtyeight.com/features/can-you-escape-a-maze-without-walls/ ]

## Riddler Classic
From Jordan Miller and William Rucklidge, three-deck monte:

You meet someone on a street corner who’s standing at a table on which there are three decks of playing cards. He tells you his name is “Three Deck Monte.” Knowing this will surely end well, you inspect the decks. Each deck contains 12 cards …

Red Deck: four aces, four 9s, four 7s
Blue Deck: four kings, four jacks, four 6s
Black Deck: four queens, four 10s, four 8s
The man offers you a bet: You pick one of the decks, he then picks a different one. You both shuffle your decks, and you compete in a short game similar to War. You each turn over cards one at a time, the one with a higher card wins that turn (aces are high), and the first to win five turns wins the bet. (There can’t be ties, as no deck contains any of the same cards as any other deck.)

Should you take the bet? After all, you can pick any of the decks, which seems like it should give you an advantage against the dealer. If you take the bet, and the dealer picks the best possible counter deck each time, how often will you win?


## Results
It turns out, suprise!, that you shouldn't take the bet.  Much like rock-paper-scisors, every deck (usually) defeats another deck and is (usually) beaten by the remaining deck.  It looks like you can expect to lose approximately 70% of the time.  I guess this shouldn't be too suprising once you realize that if you match up the highest, middle, and lowest cards in each deck; there is a deck where two of the three are higher than yours.

## How to run
1. As a DBA privileged user, run make_schema.sql. That will create a new schema in your database called war_deck with a password test.
2. Then, as that new user, run compile.sql to create the code in the database.
3. Also as that user, run test.sql.  That executes the code and prints out the results.

## Whats next?

* Performance profile a run and see where the slow parts are.  I suspect its the shuffle - verify.
* Investigate if using oracle VARRAY collection type instead of NESTED TABLES would have been a better choice.
* Is there a better way to implement the shuffle?
* Move the type definitions out of the package spec and put it in the body.
* What if you can win a game with four wins instead of five?  Does the deck advantage get smaller?  What about three, or two?

