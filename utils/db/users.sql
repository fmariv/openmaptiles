ALTER USER name openmaptiles TO ctxmaps_admin;
ALTER USER ctxmaps_admin WITH PASSWORD 'User123$';
ALTER USER ctxmaps_admin VALID UNTIL 'infinity';

CREATE USER ctxmaps_view WITH PASSWORD 'User123$';
ALTER USER ctxmaps_view VALID UNTIL 'infinity';
GRANT CONNECT ON DATABASE openmaptiles TO ctxmaps_view;
GRANT USAGE ON SCHEMA icgc_data TO ctxmaps_view;

CREATE USER ctxmaps_edit WITH PASSWORD 'User123$';
ALTER USER ctxmaps_edit VALID UNTIL 'infinity';
GRANT CONNECT ON DATABASE openmaptiles TO ctxmaps_edit;
GRANT USAGE ON SCHEMA icgc_data TO ctxmaps_edit;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA icgc_data TO ctxmaps_edit;