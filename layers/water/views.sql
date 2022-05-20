-- ne_10m_ocean
-- etldoc:  ne_10m_ocean ->  ne_10m_ocean_gen_z5
DROP MATERIALIZED VIEW IF EXISTS ne_10m_ocean_gen_z5 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_ocean_gen_z5 AS
(
SELECT ST_Simplify(geometry, ZRes(7)) AS geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel
FROM ne_10m_ocean
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_ocean_gen_z5_idx ON ne_10m_ocean_gen_z5 USING gist (geometry);

-- ne_10m_lakes
-- etldoc:  ne_10m_lakes ->  ne_10m_lakes_gen_z5
DROP MATERIALIZED VIEW IF EXISTS ne_10m_lakes_gen_z5 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_lakes_gen_z5 AS
(
SELECT ogc_fid,
       ST_MakeValid(ST_Simplify(geometry, ZRes(7))) AS geometry,
       'lake'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel
FROM ne_10m_lakes
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_lakes_gen_z5_idx ON ne_10m_lakes_gen_z5 USING gist (geometry);

-- etldoc:  ne_10m_lakes_gen_z5 ->  ne_10m_lakes_gen_z4
DROP MATERIALIZED VIEW IF EXISTS ne_10m_lakes_gen_z4 CASCADE;
CREATE MATERIALIZED VIEW ne_10m_lakes_gen_z4 AS
(
SELECT ogc_fid,
       ST_MakeValid(ST_Simplify(geometry, ZRes(6))) AS geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel
FROM ne_10m_lakes_gen_z5
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_10m_lakes_gen_z4_idx ON ne_10m_lakes_gen_z4 USING gist (geometry);

-- ne_50m_ocean
-- etldoc:  ne_50m_ocean ->  ne_50m_ocean_gen_z4
DROP MATERIALIZED VIEW IF EXISTS ne_50m_ocean_gen_z4 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_ocean_gen_z4 AS
(
SELECT ST_Simplify(geometry, ZRes(6)) AS geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel
FROM ne_50m_ocean
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_ocean_gen_z4_idx ON ne_50m_ocean_gen_z4 USING gist (geometry);

-- etldoc:  ne_50m_ocean_gen_z4 ->  ne_50m_ocean_gen_z3
DROP MATERIALIZED VIEW IF EXISTS ne_50m_ocean_gen_z3 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_ocean_gen_z3 AS
(
SELECT ST_Simplify(geometry, ZRes(5)) AS geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel
FROM ne_50m_ocean_gen_z4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_ocean_gen_z3_idx ON ne_50m_ocean_gen_z3 USING gist (geometry);

-- etldoc:  ne_50m_ocean_gen_z3 ->  ne_50m_ocean_gen_z2
DROP MATERIALIZED VIEW IF EXISTS ne_50m_ocean_gen_z2 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_ocean_gen_z2 AS
(
SELECT ST_Simplify(geometry, ZRes(4)) AS geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel
FROM ne_50m_ocean_gen_z3
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_ocean_gen_z2_idx ON ne_50m_ocean_gen_z2 USING gist (geometry);

-- ne_50m_lakes
-- etldoc:  ne_50m_lakes ->  ne_50m_lakes_gen_z3
DROP MATERIALIZED VIEW IF EXISTS ne_50m_lakes_gen_z3 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_lakes_gen_z3 AS
(
SELECT ogc_fid,
       ST_MakeValid(ST_Simplify(geometry, ZRes(5))) AS geometry,
       'lakes'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel
FROM ne_50m_lakes
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_lakes_gen_z3_idx ON ne_50m_lakes_gen_z3 USING gist (geometry);

-- etldoc:  ne_50m_lakes_gen_z3 ->  ne_50m_lakes_gen_z2
DROP MATERIALIZED VIEW IF EXISTS ne_50m_lakes_gen_z2 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_lakes_gen_z2 AS
(
SELECT ogc_fid,
       ST_MakeValid(ST_Simplify(geometry, ZRes(4))) AS geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel
FROM ne_50m_lakes_gen_z3
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_lakes_gen_z2_idx ON ne_50m_lakes_gen_z2 USING gist (geometry);

--ne_110m_ocean
-- etldoc:  ne_110m_ocean ->  ne_110m_ocean_gen_z1
DROP MATERIALIZED VIEW IF EXISTS ne_110m_ocean_gen_z1 CASCADE;
CREATE MATERIALIZED VIEW ne_110m_ocean_gen_z1 AS
(
SELECT ST_Simplify(geometry, ZRes(3)) AS geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel
FROM ne_110m_ocean
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_110m_ocean_gen_z1_idx ON ne_110m_ocean_gen_z1 USING gist (geometry);

-- etldoc:  ne_110m_ocean_gen_z1 ->  ne_110m_ocean_gen_z0
DROP MATERIALIZED VIEW IF EXISTS ne_110m_ocean_gen_z0 CASCADE;
CREATE MATERIALIZED VIEW ne_110m_ocean_gen_z0 AS
(
SELECT ST_Simplify(geometry, ZRes(2)) AS geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel
FROM ne_110m_ocean_gen_z1
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_110m_ocean_gen_z0_idx ON ne_110m_ocean_gen_z0 USING gist (geometry);


-- ne_110m_lakes
-- etldoc:  ne_110m_lakes ->  ne_110m_lakes_gen_z1
DROP MATERIALIZED VIEW IF EXISTS ne_110m_lakes_gen_z1 CASCADE;
CREATE MATERIALIZED VIEW ne_110m_lakes_gen_z1 AS
(
SELECT ogc_fid,
       ST_Simplify(geometry, ZRes(3)) AS geometry,
       'lakes'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel
FROM ne_110m_lakes
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_110m_lakes_gen_z1_idx ON ne_110m_lakes_gen_z1 USING gist (geometry);

-- etldoc:  ne_110m_lakes_gen_z1 ->  ne_110m_lakes_gen_z0
DROP MATERIALIZED VIEW IF EXISTS ne_110m_lakes_gen_z0 CASCADE;
CREATE MATERIALIZED VIEW ne_110m_lakes_gen_z0 AS
(
SELECT ogc_fid,
       ST_Simplify(geometry, ZRes(2)) AS geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel
FROM ne_110m_lakes_gen_z1
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_110m_lakes_gen_z0_idx ON ne_110m_lakes_gen_z0 USING gist (geometry);


CREATE OR REPLACE VIEW water_z0 AS
(
-- etldoc:  ne_110m_ocean_gen_z0 ->  water_z0
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_110m_ocean_gen_z0
UNION ALL
-- etldoc:  ne_110m_lakes_gen_z0 ->  water_z0
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_110m_lakes_gen_z0
    );

CREATE OR REPLACE VIEW water_z1 AS
(
-- etldoc:  ne_110m_ocean_gen_z1 ->  water_z1
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_110m_ocean_gen_z1
UNION ALL
-- etldoc:  ne_110m_lakes_gen_z1 ->  water_z1
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_110m_lakes_gen_z1
    );

CREATE OR REPLACE VIEW water_z2 AS
(
-- etldoc:  ne_50m_ocean_gen_z2 ->  water_z2
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_50m_ocean_gen_z2
UNION ALL
-- etldoc:  ne_50m_lakes_gen_z2 ->  water_z2
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_50m_lakes_gen_z2
    );

CREATE OR REPLACE VIEW water_z3 AS
(
-- etldoc:  ne_50m_ocean_gen_z3 ->  water_z3
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_50m_ocean_gen_z3
UNION ALL
-- etldoc:  ne_50m_lakes_gen_z3 ->  water_z3
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_50m_lakes_gen_z3
    );

CREATE OR REPLACE VIEW water_z4 AS
(
-- etldoc:  ne_50m_ocean_gen_z4 ->  water_z4
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_50m_ocean_gen_z4
UNION ALL
-- etldoc:  ne_10m_lakes_gen_z4 ->  water_z4
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_10m_lakes_gen_z4
    );

CREATE OR REPLACE VIEW water_z5 AS
(
-- etldoc:  ne_10m_ocean_gen_z5 ->  water_z5
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_10m_ocean_gen_z5
UNION ALL
-- etldoc:  ne_10m_lakes_gen_z5 ->  water_z5
SELECT geometry,
       class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM ne_10m_lakes_gen_z5
    );

DROP MATERIALIZED VIEW IF EXISTS water_z6;
CREATE MATERIALIZED VIEW water_z6 AS
(
-- etldoc:  osm_ocean_polygon_gen_z6 ->  water_z6
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z6
UNION ALL
-- etldoc:  osm_water_polygon_gen_z6 ->  water_z6
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z6 w, icgc_data.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z6_idx ON water_z6 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z7;
CREATE MATERIALIZED VIEW water_z7 AS
(
-- etldoc:  osm_ocean_polygon_gen_z7 ->  water_z7
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z7
UNION ALL
-- etldoc:  osm_water_polygon_gen_z7 ->  water_z7
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z7 w, icgc_data.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z7_idx ON water_z7 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z8;
CREATE MATERIALIZED VIEW water_z8 AS
(
-- etldoc:  osm_ocean_polygon_gen_z8 ->  water_z8
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z8
UNION ALL
-- etldoc:  osm_water_polygon_gen_z8 ->  water_z8
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z8 w, icgc_data.catalunya c
WHERE "natural" != 'bay' 
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z8_idx ON water_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z9;
CREATE MATERIALIZED VIEW water_z9 AS
(
-- etldoc:  osm_ocean_polygon_gen_z9 ->  water_z9
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z9
UNION ALL
-- etldoc:  osm_water_polygon_gen_z9 ->  water_z9
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z9 w, icgc_data.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z9_idx ON water_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z10;
CREATE MATERIALIZED VIEW water_z10 AS
(
-- etldoc:  osm_ocean_polygon_gen_z10 ->  water_z10
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z10
UNION ALL
-- etldoc:  osm_water_polygon_gen_z10 ->  water_z10
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z10 w, icgc_data.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z10_idx ON water_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z11;
CREATE MATERIALIZED VIEW water_z11 AS
(
-- etldoc:  osm_ocean_polygon_gen_z11 ->  water_z11
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z11
UNION ALL
-- etldoc:  osm_water_polygon_gen_z11 ->  water_z11
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z11 w, icgc_data.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z11_idx ON water_z11 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z12;
CREATE MATERIALIZED VIEW water_z12 AS
(
-- etldoc:  osm_ocean_polygon_union ->  water_z12
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_union
UNION ALL
-- etldoc:  osm_water_polygon ->  water_z12
SELECT w.geometry,
       water_class(waterway, water) AS class,
       is_intermittent,
       is_bridge,
       is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon w, icgc_data.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z12_idx ON water_z12 USING gist (geometry);