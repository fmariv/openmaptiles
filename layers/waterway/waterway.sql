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
CREATE OR REPLACE VIEW waterway_z6 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z6 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc: waterway_relation_gen_z7 ->  waterway_z7
CREATE OR REPLACE VIEW waterway_z7 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z7 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc: waterway_relation_gen_z8 ->  waterway_z8
CREATE OR REPLACE VIEW waterway_z8 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z8 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc: osm_important_waterway_linestring_gen_z9 ->  waterway_z9
CREATE OR REPLACE VIEW waterway_z9 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z9 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc: osm_important_waterway_linestring_gen_z10 ->  waterway_z10
CREATE OR REPLACE VIEW waterway_z10 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z10 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc:osm_important_waterway_linestring_gen_z11 ->  waterway_z11
CREATE OR REPLACE VIEW waterway_z11 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z11 w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc: osm_waterway_linestring ->  waterway_z12
CREATE OR REPLACE VIEW waterway_z12 AS
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

-- etldoc: osm_waterway_linestring ->  waterway_z13
CREATE OR REPLACE VIEW waterway_z13 AS
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

-- etldoc: osm_waterway_linestring ->  waterway_z14
CREATE OR REPLACE VIEW waterway_z14 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, icgc_data.catalunya
WHERE ST_DISJOINT(icgc_data.catalunya.geometry, w.geometry)
    );

-- etldoc: layer_waterway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="layer_waterway | <z3> z3 |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ];

CREATE OR REPLACE FUNCTION layer_waterway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (   
            	  icgc_id      bigint,
                geometry     geometry,
                class        text,
                name         text,
                entorn       text
            )
AS
$$
SELECT icgc_id,
       geom,
       class,
       NULLIF(name, '') AS name,
       entorn
FROM (
         -- icgc waterway_z_7_8_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn
         FROM icgc_data.waterway_z_7_8_carto
         WHERE (zoom_level BETWEEN 7 AND 8) AND geom && bbox
         UNION ALL

         -- waterway_z_9_10_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn
         FROM icgc_data.waterway_z_9_10_carto 
         WHERE (zoom_level = 9) AND geom && bbox
         UNION ALL

         -- waterway_z_10_11_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn
         FROM icgc_data.waterway_z_10_11_carto 
         WHERE (zoom_level BETWEEN 10 AND 11) AND geom && bbox
         UNION ALL

         -- waterway strahler
         SELECT icgc_id,
                geom,
                class,
                name,
                entorn
         FROM icgc_data.waterway_bt5mv30_strahler w
         WHERE 
         (w.entorn <> 'UR' ) AND (
            ((zoom_level BETWEEN 12 AND 13) AND (w.strahler_order > 2 OR w.jsel in ('3A','3B','3C','2A','2B') ) AND w.geom && bbox) OR
            ((zoom_level = 14)  AND (w.strahler_order >1 OR w.jsel in ('3A','3B','3C','2A','2B') ) AND w.geom && bbox) OR
            ((zoom_level >14)  AND w.geom && bbox) )
     ) AS zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
