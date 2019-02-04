CREATE OR REPLACE PACKAGE BODY war_deck_simulation
IS

  lc_ace  card_type;
  lc_king  card_type;
  lc_queen  card_type;
  lc_jack  card_type;
  lc_ten  card_type;
  lc_nine  card_type;
  lc_eight  card_type;
  lc_seven  card_type;
  lc_six  card_type;
  
  lc_red_deck deck_type;
  lc_blue_deck deck_type;
  lc_green_deck deck_type;
    
  PROCEDURE print_ordered_deck (pi_deck IN deck_type)
  IS
  BEGIN
    NULL;
  END print_ordered_deck;

  FUNCTION shuffle_deck (pi_deck IN deck_type) RETURN deck_type
  IS
    lv_result deck_type := NULL;
  BEGIN
    RETURN lv_result;
  END shuffle_deck;  

BEGIN
    lc_ace.display_name     := 'Ace';
    lc_ace.card_rank        := 1;
    lc_king.display_name    := 'King';
    lc_king.card_rank       := 2;
    lc_queen.display_name   := 'Queen';
    lc_queen.card_rank      := 3;
    lc_jack.display_name    := 'Jack';
    lc_jack.card_rank       := 4;
    lc_ten.display_name     := 'Ten';
    lc_ten.card_rank        := 5;
    lc_nine.display_name    := 'Nine';
    lc_nine.card_rank       := 6;
    lc_eight.display_name   := 'Eight';
    lc_eight.card_rank      := 7;
    lc_seven.display_name   := 'Seven';
    lc_seven.card_rank      := 8;
    lc_six.display_name     := 'Six';
    lc_six.card_rank        := 9;
END war_deck_simulation;
/

