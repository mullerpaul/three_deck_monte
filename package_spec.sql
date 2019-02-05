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

    PROCEDURE battle (
        pi_deck1        IN  deck_type,
        pi_deck2        IN  deck_type,
        po_winning_deck OUT NUMBER,
        po_rounds       OUT NUMBER
    );
    
    PROCEDURE simulation (
        pi_deck1_color IN VARCHAR2,
        pi_deck2_color IN VARCHAR2
    );

    PROCEDURE test_it; 

END war_deck_simulation;
/


