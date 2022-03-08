

-- etldoc: ne_110m_rivers_lake_centerlines_gen_z3 ->  waterway_z3
CREATE OR REPLACE VIEW waterway_z3 AS
(
SELECT NULL::bigint AS icgc_id,
       geometry,
       class,
       name,
       NULL::text AS entorn
FROM ne_110m_rivers_lake_centerlines_gen_z3
    );

-- etldoc: ne_50m_rivers_lake_centerlines_gen_z4 ->  waterway_z4
CREATE OR REPLACE VIEW waterway_z4 AS
(
SELECT NULL::bigint AS icgc_id,
       geometry,
       class,
       name,
       NULL::text AS entorn
FROM ne_50m_rivers_lake_centerlines_gen_z4
    );

-- etldoc: ne_50m_rivers_lake_centerlines_gen_z5 ->  waterway_z5
CREATE OR REPLACE VIEW waterway_z5 AS
(
SELECT NULL::bigint AS icgc_id,
       geometry,
       class,
       name,
       NULL::text AS entorn
FROM ne_50m_rivers_lake_centerlines_gen_z5
    );

-- etldoc: waterway_relation_gen_z6 ->  waterway_z6
DROP MATERIALIZED VIEW IF EXISTS waterway_z6;
CREATE MATERIALIZED VIEW waterway_z6 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z6 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z6_idx ON waterway_z6 USING gist (geometry);

-- etldoc: waterway_relation_gen_z7 ->  waterway_z7
DROP MATERIALIZED VIEW IF EXISTS waterway_z7;
CREATE MATERIALIZED VIEW waterway_z7 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z7 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z7_idx ON waterway_z7 USING gist (geometry);

-- etldoc: waterway_relation_gen_z8 ->  waterway_z8
DROP MATERIALIZED VIEW IF EXISTS waterway_z8;
CREATE MATERIALIZED VIEW waterway_z8 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z8 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z8_idx ON waterway_z8 USING gist (geometry);

-- etldoc: osm_important_waterway_linestring_gen_z9 ->  waterway_z9
DROP MATERIALIZED VIEW IF EXISTS waterway_z9;
CREATE MATERIALIZED VIEW waterway_z9 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z9 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z9_idx ON waterway_z9 USING gist (geometry);

-- etldoc: osm_important_waterway_linestring_gen_z10 ->  waterway_z10
DROP MATERIALIZED VIEW IF EXISTS waterway_z10;
CREATE MATERIALIZED VIEW waterway_z10 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z10 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z10_idx ON waterway_z10 USING gist (geometry);

-- etldoc:osm_important_waterway_linestring_gen_z11 ->  waterway_z11
DROP MATERIALIZED VIEW IF EXISTS waterway_z11;
CREATE MATERIALIZED VIEW waterway_z11 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z11 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z11_idx ON waterway_z11 USING gist (geometry);

-- etldoc: osm_waterway_linestring ->  waterway_z12
DROP MATERIALIZED VIEW IF EXISTS waterway_z12;
CREATE MATERIALIZED VIEW waterway_z12 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, icgc_data.catalunya
WHERE w.waterway IN ('river', 'canal') 
AND ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z12_idx ON waterway_z12 USING gist (geometry);

-- etldoc: osm_waterway_linestring ->  waterway_z13
DROP MATERIALIZED VIEW IF EXISTS waterway_z13;
CREATE MATERIALIZED VIEW waterway_z13 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, icgc_data.catalunya
WHERE w.waterway IN ('river', 'canal', 'stream', 'drain', 'ditch')
AND ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z13_idx ON waterway_z13 USING gist (geometry);

-- etldoc: osm_waterway_linestring ->  waterway_z14
DROP MATERIALIZED VIEW IF EXISTS waterway_z14;
CREATE MATERIALIZED VIEW waterway_z14 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z14_idx ON waterway_z14 USING gist (geometry);