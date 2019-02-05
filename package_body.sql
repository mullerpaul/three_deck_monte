CREATE OR REPLACE PACKAGE BODY war_deck_simulation
IS
    lc_ace   card_type;
    lc_king  card_type;
    lc_queen card_type;
    lc_jack  card_type;
    lc_ten   card_type;
    lc_nine  card_type;
    lc_eight card_type;
    lc_seven card_type;
    lc_six   card_type;

    lc_red_deck   deck_type;
    lc_blue_deck  deck_type;
    lc_black_deck deck_type;    

    ------------------------------------------------
    PROCEDURE print_ordered_deck (pi_deck IN deck_type)
    IS
        lv_index NUMBER := 0;
    BEGIN
        /* This procedure for test/debug purposes. */
        FOR i IN pi_deck.FIRST .. pi_deck.LAST LOOP
            lv_index := lv_index + 1;
            dbms_output.put_line ('Card ' || to_char(lv_index) || ' is a ' || pi_deck(i).display_name);
        END LOOP;

    END print_ordered_deck;

    ------------------------------------------------
    FUNCTION shuffle_deck (pi_deck IN deck_type) 
    RETURN deck_type
    IS
        lv_result    deck_type := pi_deck; -- set the result deck equal to the source desk as an initialization (NULL gave runtime error)
        lv_deck_size NUMBER;
    BEGIN
        /* This is the key part of this demo.  How are we going to randomly reorder elements of a collection? 
           I've read that using the SQL engine (with multiselect select from TABLE (x) )for ordering is a good 
           idea when the collection is large; but I doubt sorting 12 elements is a large enough task to justify 
           the context switch from PL/SQL to SQL, so I'll do it in PL/SQL loop over a 12 row set generated in SQL.
           Perhaps later I'll add a second SQL based sort function and see how it compares.  
           I've started with nested table collection type.  I wonder though if it might work better with a 
           varray.  I avoided varrays as they are recommended for always sequential access and this will 
           be accessing the source non-sequentially.  However, that recommendation may be because varrays are 
           always dense and nested tables can become sparse, which will not be a factor in this case because 
           our reference decks are unchanging and will always be dense.  */
        lv_deck_size := pi_deck.COUNT;  -- do we need this, or can I put the COUNT method in the LOOP sql? 
        FOR i IN (WITH ordinal_numbers 
                    AS ( SELECT level as source_deck_index
                           FROM dual 
                        CONNECT BY  level <= lv_deck_size
                          ORDER BY dbms_random.value )
                SELECT ROWNUM AS new_deck_index,
                       source_deck_index
                  FROM ordinal_numbers) LOOP
            lv_result(i.new_deck_index) := pi_deck(i.source_deck_index);
        END LOOP;
        RETURN lv_result;

    END shuffle_deck;  

    ------------------------------------------------
    PROCEDURE battle (
        pi_deck1 IN deck_type, 
        pi_deck2 IN deck_type, 
        po_winning_deck OUT NUMBER, 
        po_rounds       OUT NUMBER
    ) IS
        lc_wins_required_for_victory CONSTANT NUMBER := 5;
        lv_winner NUMBER;
        lv_round  NUMBER := 0;
        lv_deck1_wins NUMBER := 0;
        lv_deck2_wins NUMBER := 0;
        
    BEGIN
        WHILE ( lv_deck1_wins < lc_wins_required_for_victory AND 
                lv_deck2_wins < lc_wins_required_for_victory )
        LOOP
            lv_round := lv_round + 1;
            IF pi_deck1(lv_round).card_rank < pi_deck2(lv_round).card_rank
                THEN
                    /* deck1 win */
                    lv_deck1_wins := lv_deck1_wins + 1;
                ELSE
                    /* deck2 win */
                    lv_deck2_wins := lv_deck2_wins + 1;
            END IF;        
                
        END LOOP;    
        
        /* We have a winner.  Figure out which deck it was and set out variables */
        IF lv_deck1_wins >= lc_wins_required_for_victory
        THEN
            /* Deck 1 won */
            lv_winner := 1;
        ELSE 
            /* Deck 2 won */
            lv_winner := 2;
        END IF;
        
        po_winning_deck := lv_winner;
        po_rounds := lv_round;
        
    END battle;

    ------------------------------------------------
    PROCEDURE simulation (
        pi_deck1_color IN VARCHAR2,
        pi_deck2_color IN VARCHAR2
    ) IS
        lc_iteration_limit CONSTANT NUMBER := 500;
        lv_deck1 deck_type;
        lv_deck2 deck_type;
        lv_winner NUMBER;
        lv_rounds NUMBER;
        lv_total_deck1_wins NUMBER := 0;
        lv_total_deck2_wins NUMBER := 0;
        lv_total_rounds     NUMBER := 0;
        
    BEGIN
        /* validate input */
        IF ( pi_deck1_color IS NULL OR
             UPPER(pi_deck1_color) NOT IN ('RED','BLUE','BLACK') OR
             pi_deck2_color IS NULL OR
             UPPER(pi_deck2_color) NOT IN ('RED','BLUE','BLACK') )
        THEN
            raise_application_error(-20001, 'Invalid input');
        END IF;

        /* init decks */
        lv_deck1 := CASE UPPER(pi_deck1_color)
                        WHEN 'RED' THEN lc_red_deck
                        WHEN 'BLUE' THEN lc_blue_deck
                        WHEN 'BLACK' THEN lc_black_deck
                    END;
        lv_deck2 := CASE UPPER(pi_deck2_color)
                        WHEN 'RED' THEN lc_red_deck
                        WHEN 'BLUE' THEN lc_blue_deck
                        WHEN 'BLACK' THEN lc_black_deck
                    END;
        
        /* run the battle many times */
        FOR i IN 1 .. lc_iteration_limit LOOP
                        
            /* run battle */
            battle (
                pi_deck1 => shuffle_deck(lv_deck1),
                pi_deck2 => shuffle_deck(lv_deck2), 
                po_winning_deck => lv_winner,
                po_rounds => lv_rounds
            );

            /* record results */
            CASE lv_winner
                WHEN 1 THEN lv_total_deck1_wins := lv_total_deck1_wins + 1;
                WHEN 2 THEN lv_total_deck2_wins := lv_total_deck2_wins + 1;
            END CASE;
            lv_total_rounds := lv_total_rounds + lv_rounds;
            
        END LOOP;
        
        /* Print results */
        dbms_output.put_line ('****************');
        dbms_output.put_line (pi_deck1_color || ' vs ' || pi_deck2_color);
        dbms_output.put_line (pi_deck1_color || ' won ' 
                                || to_char(lv_total_deck1_wins) 
                                || ' of ' || to_char(lc_iteration_limit)
                                || ' hands for a ' 
                                || to_char(ROUND(100 * lv_total_deck1_wins / lc_iteration_limit, 1)) 
                                || '% win percentage.');
        dbms_output.put_line (pi_deck2_color || ' won ' 
                                || to_char(lv_total_deck2_wins) 
                                || ' of ' || to_char(lc_iteration_limit)
                                || ' hands for a ' 
                                || to_char(ROUND(100 * lv_total_deck2_wins / lc_iteration_limit, 1)) 
                                || '% win percentage.');
        dbms_output.put_line ('The average number of rounds to win a hand was ' 
                                || to_char(ROUND(lv_total_rounds / lc_iteration_limit, 2)));

    END simulation;

    ------------------------------------------------
    PROCEDURE test_it
    IS
    BEGIN
        /* Only need half of these; but I've left them in for testing and legibility */
        simulation('red','blue');
        simulation('red','black');
        simulation('black','blue');
        simulation('black','red');
        simulation('blue','red');
        simulation('blue','black');
        
        /* lets see what this does! */
        simulation('red','red');
    
    END test_it;

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

    lc_red_deck             := deck_type(
        lc_ace,
        lc_ace,
        lc_ace,
        lc_ace,
        lc_nine,
        lc_nine,
        lc_nine,
        lc_nine,
        lc_seven,
        lc_seven,
        lc_seven,
        lc_seven
    );

    lc_blue_deck            := deck_type(
        lc_king,
        lc_king,
        lc_king,
        lc_king,
        lc_jack,
        lc_jack,
        lc_jack,
        lc_jack,
        lc_six,
        lc_six,
        lc_six,
        lc_six
    );

    lc_black_deck           := deck_type(
        lc_queen,
        lc_queen,
        lc_queen,
        lc_queen,
        lc_ten,
        lc_ten,
        lc_ten,
        lc_ten,
        lc_eight,
        lc_eight,
        lc_eight,
        lc_eight
    );

END war_deck_simulation;
/

