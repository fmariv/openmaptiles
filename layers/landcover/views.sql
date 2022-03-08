-- ne_50m_antarctic_ice_shelves_polys
-- etldoc: ne_50m_antarctic_ice_shelves_polys ->  ne_50m_antarctic_ice_shelves_polys_gen_z4
DROP MATERIALIZED VIEW IF EXISTS ne_50m_antarctic_ice_shelves_polys_gen_z4 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_antarctic_ice_shelves_polys_gen_z4 AS
(
SELECT
    ST_Simplify(geometry, ZRes(6)) as geometry,
    'ice_shelf'::text AS subclass
FROM ne_50m_antarctic_ice_shelves_polys
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_antarctic_ice_shelves_polys_gen_z4_idx ON ne_50m_antarctic_ice_shelves_polys_gen_z4 USING gist (geometry);

-- ne_110m_glaciated_areas
-- etldoc: ne_110m_glaciated_areas ->  ne_110m_glaciated_areas_gen_z1
DROP MATERIALIZED VIEW IF EXISTS ne_110m_glaciated_areas_gen_z1 CASCADE;
CREATE MATERIALIZED VIEW ne_110m_glaciated_areas_gen_z1 AS
(
SELECT
    ST_Simplify(geometry, ZRes(3)) as geometry,
    'glacier'::text AS subclass
FROM ne_110m_glaciated_areas
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_110m_glaciated_areas_gen_z1_idx ON ne_110m_glaciated_areas_gen_z1 USING gist (geometry);

-- etldoc: ne_110m_glaciated_areas_gen_z1 ->  ne_110m_glaciated_areas_gen_z0
DROP MATERIALIZED VIEW IF EXISTS ne_110m_glaciated_areas_gen_z0 CASCADE;
CREATE MATERIALIZED VIEW ne_110m_glaciated_areas_gen_z0 AS
(
SELECT
    ST_Simplify(geometry, ZRes(2)) as geometry,
    subclass
FROM ne_110m_glaciated_areas_gen_z1
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_110m_glaciated_areas_gen_z0_idx ON ne_110m_glaciated_areas_gen_z0 USING gist (geometry);

-- etldoc: ne_50m_antarctic_ice_shelves_polys_gen_z4 ->  ne_50m_antarctic_ice_shelves_polys_gen_z3
DROP MATERIALIZED VIEW IF EXISTS ne_50m_antarctic_ice_shelves_polys_gen_z3 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_antarctic_ice_shelves_polys_gen_z3 AS
(
SELECT
    ST_Simplify(geometry, ZRes(5)) as geometry,
    subclass
FROM ne_50m_antarctic_ice_shelves_polys_gen_z4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_antarctic_ice_shelves_polys_gen_z3_idx ON ne_50m_antarctic_ice_shelves_polys_gen_z3 USING gist (geometry);

-- etldoc: ne_50m_antarctic_ice_shelves_polys_gen_z3 ->  ne_50m_antarctic_ice_shelves_polys_gen_z2
DROP MATERIALIZED VIEW IF EXISTS ne_50m_antarctic_ice_shelves_polys_gen_z2 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_antarctic_ice_shelves_polys_gen_z2 AS
(
SELECT
    ST_Simplify(geometry, ZRes(4)) as geometry,
    subclass
FROM ne_50m_antarctic_ice_shelves_polys_gen_z3
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_antarctic_ice_shelves_polys_gen_z2_idx ON ne_50m_antarctic_ice_shelves_polys_gen_z2 USING gist (geometry);

-- ne_50m_glaciated_areas
-- etldoc: ne_50m_glaciated_areas ->  ne_50m_glaciated_areas_gen_z4
DROP MATERIALIZED VIEW IF EXISTS ne_50m_glaciated_areas_gen_z4 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_glaciated_areas_gen_z4 AS
(
SELECT
    ST_Simplify(geometry, ZRes(6)) as geometry,
    'glacier'::text AS subclass
FROM ne_50m_glaciated_areas
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_glaciated_areas_gen_z4_idx ON ne_50m_glaciated_areas_gen_z4 USING gist (geometry);

-- etldoc: ne_50m_glaciated_areas_gen_z4 ->  ne_50m_glaciated_areas_gen_z3
DROP MATERIALIZED VIEW IF EXISTS ne_50m_glaciated_areas_gen_z3 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_glaciated_areas_gen_z3 AS
(
SELECT
    ST_Simplify(geometry, ZRes(5)) as geometry,
    subclass
FROM ne_50m_glaciated_areas_gen_z4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_glaciated_areas_gen_z3_idx ON ne_50m_glaciated_areas_gen_z3 USING gist (geometry);

-- etldoc: ne_50m_glaciated_areas_gen_z3 ->  ne_50m_glaciated_areas_gen_z2
DROP MATERIALIZED VIEW IF EXISTS ne_50m_glaciated_areas_gen_z2 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_glaciated_areas_gen_z2 AS
(
SELECT
    ST_Simplify(geometry, ZRes(4)) as geometry,
    subclass
FROM ne_50m_glaciated_areas_gen_z3
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_glaciated_areas_gen_z2_idx ON ne_50m_glaciated_areas_gen_z2 USING gist (geometry);

-- ne_10m_glaciated_areas
-- etldoc: ne_10m_glaciated_areas ->  ne_10m_glaciated_areas_gen_z6
DROP MATERIALIZED VIEW IF EXISTS ne_10m_glaciated_areas_gen_z6 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_glaciated_areas_gen_z6 AS
(
SELECT
    ST_Simplify(geometry, ZRes(8)) as geometry,
    'glacier'::text AS subclass
FROM ne_10m_glaciated_areas
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_glaciated_areas_gen_z6_idx ON ne_10m_glaciated_areas_gen_z6 USING gist (geometry);

-- etldoc: ne_10m_glaciated_areas_gen_z6 ->  ne_10m_glaciated_areas_gen_z5
DROP MATERIALIZED VIEW IF EXISTS ne_10m_glaciated_areas_gen_z5 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_glaciated_areas_gen_z5 AS
(
SELECT
    ST_Simplify(geometry, ZRes(7)) as geometry,
    subclass
FROM ne_10m_glaciated_areas_gen_z6
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_glaciated_areas_gen_z5_idx ON ne_10m_glaciated_areas_gen_z5 USING gist (geometry);

-- ne_10m_antarctic_ice_shelves_polys
-- etldoc: ne_10m_antarctic_ice_shelves_polys ->  ne_10m_antarctic_ice_shelves_polys_gen_z6
DROP MATERIALIZED VIEW IF EXISTS ne_10m_antarctic_ice_shelves_polys_gen_z6 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_antarctic_ice_shelves_polys_gen_z6 AS
(
SELECT
    ST_Simplify(geometry, ZRes(8)) as geometry,
    'ice_shelf'::text AS subclass
FROM ne_10m_antarctic_ice_shelves_polys
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_antarctic_ice_shelves_polys_gen_z6_idx ON ne_10m_antarctic_ice_shelves_polys_gen_z6 USING gist (geometry);

-- etldoc: ne_10m_antarctic_ice_shelves_polys_gen_z6 ->  ne_10m_antarctic_ice_shelves_polys_gen_z5
DROP MATERIALIZED VIEW IF EXISTS ne_10m_antarctic_ice_shelves_polys_gen_z5 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_antarctic_ice_shelves_polys_gen_z5 AS
(
SELECT
    ST_Simplify(geometry, ZRes(7)) as geometry,
    subclass
FROM ne_10m_antarctic_ice_shelves_polys_gen_z6
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_antarctic_ice_shelves_polys_gen_z5_idx ON ne_10m_antarctic_ice_shelves_polys_gen_z5 USING gist (geometry);

-- etldoc: ne_110m_glaciated_areas_gen_z0 ->  landcover_z0
CREATE OR REPLACE VIEW landcover_z0 AS
(
SELECT
    geometry,
    subclass
FROM ne_110m_glaciated_areas_gen_z0
    );

-- etldoc: ne_110m_glaciated_areas_gen_z1 ->  landcover_z1
CREATE OR REPLACE VIEW landcover_z1 AS
(
SELECT
    geometry,
    subclass
FROM ne_110m_glaciated_areas_gen_z1
    );

CREATE OR REPLACE VIEW landcover_z2 AS
(
-- etldoc: ne_50m_glaciated_areas_gen_z2 ->  landcover_z2
SELECT
    geometry,
    subclass
FROM ne_50m_glaciated_areas_gen_z2
UNION ALL
-- etldoc: ne_50m_antarctic_ice_shelves_polys_gen_z2 ->  landcover_z2
SELECT
    geometry,
    subclass
FROM ne_50m_antarctic_ice_shelves_polys_gen_z2
    );

CREATE OR REPLACE VIEW landcover_z3 AS
(
-- etldoc: ne_50m_glaciated_areas_gen_z3 ->  landcover_z3
SELECT
    geometry,
    subclass
FROM ne_50m_glaciated_areas_gen_z3
UNION ALL
-- etldoc: ne_50m_antarctic_ice_shelves_polys_gen_z3 ->  landcover_z3
SELECT
    geometry,
    subclass
FROM ne_50m_antarctic_ice_shelves_polys_gen_z3
    );

CREATE OR REPLACE VIEW landcover_z4 AS
(
-- etldoc: ne_50m_glaciated_areas_gen_z4 ->  landcover_z4
SELECT
    geometry,
    subclass
FROM ne_50m_glaciated_areas_gen_z4
UNION ALL
-- etldoc: ne_50m_antarctic_ice_shelves_polys_gen_z4 ->  landcover_z4
SELECT
    geometry,
    subclass
FROM ne_50m_antarctic_ice_shelves_polys_gen_z4
    );

CREATE OR REPLACE VIEW landcover_z5 AS
(
-- etldoc: ne_10m_glaciated_areas_gen_z5 ->  landcover_z5
SELECT
    geometry,
    subclass
FROM ne_10m_glaciated_areas_gen_z5
UNION ALL
-- etldoc: ne_10m_antarctic_ice_shelves_polys_gen_z5 ->  landcover_z5
SELECT
    geometry,
    subclass
FROM ne_10m_antarctic_ice_shelves_polys_gen_z5
    );

CREATE OR REPLACE VIEW landcover_z6 AS
(
-- etldoc: ne_10m_glaciated_areas_gen_z6 ->  landcover_z6
SELECT
    geometry,
    subclass
FROM ne_10m_glaciated_areas_gen_z6
UNION ALL
-- etldoc: ne_10m_antarctic_ice_shelves_polys_gen_z6 ->  landcover_z6
SELECT
    geometry,
    subclass
FROM ne_10m_antarctic_ice_shelves_polys_gen_z6
    );

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z7;
CREATE MATERIALIZED VIEW osm_landcover_planet_z7 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z7 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z7_idx ON osm_landcover_planet_z7 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z8;
CREATE MATERIALIZED VIEW osm_landcover_planet_z8 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z8 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z8_idx ON osm_landcover_planet_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z9;
CREATE MATERIALIZED VIEW osm_landcover_planet_z9 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z9 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z9_idx ON osm_landcover_planet_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z10;
CREATE MATERIALIZED VIEW osm_landcover_planet_z10 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z10 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z10_idx ON osm_landcover_planet_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z11;
CREATE MATERIALIZED VIEW osm_landcover_planet_z11 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z11 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z11_idx ON osm_landcover_planet_z11 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover__planetz12;
CREATE MATERIALIZED VIEW osm_landcover_planet_z12 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z12 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z12_idx ON osm_landcover_planet_z12 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z13;
CREATE MATERIALIZED VIEW osm_landcover_planet_z13 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z13 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z13_idx ON osm_landcover_planet_z13 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z14;
CREATE MATERIALIZED VIEW osm_landcover_planet_z14 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z14 ol, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z14_idx ON osm_landcover_planet_z14 USING gist (geometry);
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;