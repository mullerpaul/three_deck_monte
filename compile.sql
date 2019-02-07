SET lines 100 pages 50 trimspool ON

ALTER SESSION SET plsql_warnings = 'ENABLE:ALL';
ALTER SESSION SET plscope_settings = 'IDENTIFIERS:ALL';  -- requires oracle DB v12 or later

@package_spec.sql
show errors

@package_body.sql
show errors

exit

