CREATE OR REPLACE PACKAGE war_deck_simulation
AUTHID DEFINER
AS
    TYPE card_type IS RECORD ( 
        display_name VARCHAR2(5),
        card_rank    NUMBER(2) 
    );
    TYPE deck_type IS
        TABLE OF card_type;
    
    PROCEDURE print_ordered_deck (
        pi_deck IN deck_type
    );

    FUNCTION shuffle_deck (
        pi_deck IN deck_type
    ) RETURN deck_type;

END war_deck_simulation;
/


