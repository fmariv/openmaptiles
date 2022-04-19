-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_water_name(bbox geometry, zoom_level integer);
CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                osm_id       bigint,
                icgc_id      bigint,
                geometry     geometry,
                name         text,
                "name:latin" text,
                class        text,
                icgc_zoom    int,
                rank         int,
                codigeo      int,
                fontsize     float,
                mtc1m        text,
                mtc2m        text,
                layer        text
            )
AS
$$
SELECT
    -- etldoc: osm_water_lakeline ->  layer_water_name:z9_13
    -- etldoc: osm_water_lakeline ->  layer_water_name:z14_
    CASE
        WHEN osm_id < 0 THEN -osm_id * 10 + 4
        ELSE osm_id * 10 + 1
        END AS osm_id_hash,
    NULL::INT AS icgc_id,
    w.geometry,
    w.name,
    w.name AS "name:latin",
    'lake'::text AS class,
    NULL::INT AS icgc_zoom,
    NULL::INT AS rank,
    NULL::INT AS codigeo,
    NULL::FLOAT AS fontsize,
    NULL::text AS mtc1m,
    NULL::text AS mtc2m,
    NULL::text AS layer
FROM osm_water_lakeline w, icgc_data.catalunya c
WHERE w.geometry && bbox
  AND ST_Disjoint(c.geometry, w.geometry)
  AND ((zoom_level BETWEEN 9 AND 13 AND LineLabel(zoom_level, NULLIF(name, ''), w.geometry))
    OR (zoom_level >= 14))
UNION ALL

SELECT
    -- etldoc: osm_water_point ->  layer_water_name:z9_13
    -- etldoc: osm_water_point ->  layer_water_name:z14_
    CASE
        WHEN osm_id < 0 THEN -osm_id * 10 + 4
        ELSE osm_id * 10 + 1
        END AS osm_id_hash,
    NULL::INT AS icgc_id,
    w.geometry,
    w.name,
    w.name AS "name:latin",
    'lake'::text AS class,
    NULL::INT AS icgc_zoom,
    NULL::INT AS rank,
    NULL::INT AS codigeo,
    NULL::FLOAT AS fontsize,
    NULL::text AS mtc1m,
    NULL::text AS mtc2m,
    NULL::text AS layer
FROM osm_water_point w, icgc_data.catalunya c
WHERE w.geometry && bbox
  AND ST_Disjoint(c.geometry, w.geometry)
  AND (
        (zoom_level BETWEEN 9 AND 13 AND area > 70000 * 2 ^ (20 - zoom_level))
        OR (zoom_level >= 14)
    )
UNION ALL

SELECT
    -- etldoc: osm_marine_point ->  layer_water_name:z0_8
    -- etldoc: osm_marine_point ->  layer_water_name:z9_13
    -- etldoc: osm_marine_point ->  layer_water_name:z14_
    osm_id * 10 AS osm_id_hash,
    NULL::INT AS icgc_id,
    geometry,
    name,
    name AS "name:latin",
    place::text AS class,
    NULL::INT AS icgc_zoom,
    NULL::INT AS rank,
    NULL::INT AS codigeo,
    NULL::FLOAT AS fontsize,
    NULL::text AS mtc1m,
    NULL::text AS mtc2m,
    NULL::text AS layer
FROM osm_marine_point 
WHERE geometry && bbox
  AND (
        place = 'ocean'
        OR (zoom_level >= "rank" AND "rank" IS NOT NULL)
        OR (zoom_level >= 8)
    )
UNION ALL

SELECT 
     -- water_name icgc
     NULL::INT as osm_id,
     icgc_id,
     geom,
     name,
     name AS "name:latin",
     class,
     zoom AS icgc_zoom,
     "rank",
     codigeo,
     fontsize,
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     NULL::text AS layer
FROM icgc_data.water_name 
WHERE zoom_level >= zoom AND geom && bbox
UNION ALL

SELECT
     -- waterway icgc
     NULL::INT as osm_id,
     icgc_id,
     geom,
     name,
     name AS "name:latin",
     class,
     zoom AS icgc_zoom,
     "rank",
     codigeo,
     fontsize,
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     NULL::text AS layer
FROM icgc_data.waterway 
WHERE zoom_level >= zoom AND geom && bbox
UNION ALL

SELECT 
     -- water_name icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     NULL::smallint AS icgc_zoom,
     NULL::smallint AS "rank",
     codigeo,
     NULL::float AS fontsize,
     mtc1m,
     mtc2m,
     layer
FROM icgc_test.mtc1m
WHERE geometry && bbox
   AND layer = 'water_name'
   AND zoom_level BETWEEN 6 AND 10;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
