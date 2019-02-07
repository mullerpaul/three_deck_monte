CREATE USER war_deck
IDENTIFIED BY test
DEFAULT TABLESPACE users
QUOTA 20m ON users
/
GRANT create session, create type, create synonym, create procedure, 
      create table, create view, create sequence
   TO war_deck
/

------ get correct pw and parameters here -----
--connect utplsql/utplsql@orcl
--@/u01/userhome/oracle/utplsql/utPLSQL/source/create_user_grants.sql war_deck
--@/u01/userhome/oracle/utplsql/utPLSQL/source/create_user_synonyms.sql war_deck

