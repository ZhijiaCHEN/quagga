DROP TABLE if EXISTS rib_in;
create TABLE rib_in(
    rid SERIAL PRIMARY KEY,
    prefix VARCHAR NOT NULL,
    local_preference INTEGER default 100,
    metric INTEGER,
    next_hop VARCHAR NOT NULL,
    as_path VARCHAR,
    router VARCHAR
);

DROP TABLE IF EXISTS rib_out;
CREATE TABLE rib_out(
    rid INTEGER,
    prefix VARCHAR NOT NULL,
    local_preference INTEGER default 100,
    metric INTEGER,
    next_hop VARCHAR NOT NULL,
    as_path VARCHAR,
    router VARCHAR
);

DROP TABLE IF EXISTS routers;
CREATE TABLE routers(
	id VARCHAR
);
INSERT INTO routers VALUES('10.0.0.1'), ('10.0.0.2');

CREATE OR REPLACE FUNCTION miro_fun() RETURNS TRIGGER AS
$$
#variable_conflict use_variable
DECLARE
    rec RECORD;
BEGIN
    IF (array_position(new.as_path::int[], 2) > 0) THEN
        FOR rec IN SELECT id FROM routers LOOP
            INSERT INTO rib_out VALUES (NEW.rid, NEW.prefix, 1, NEW.metric, NEW.next_hop, NEW.as_path, rec.id);
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS miro ON rib_in;
CREATE TRIGGER miro AFTER INSERT ON rib_in
    FOR EACH ROW
    EXECUTE PROCEDURE miro_fun();