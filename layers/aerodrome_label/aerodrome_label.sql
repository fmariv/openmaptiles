-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_water_name(bbox geometry, zoom_level integer);
CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id      bigint,
                geometry     geometry,
                name         text,
                "name:latin" text,
                class        text,
                icgc_zoom    smallint,
                "rank"       smallint,
                codigeo      bigint,
                fontsize     float,
                mtc1m        text,
                mtc2m        text,
                layer        text
            )
AS
$$
SELECT
     -- water_name icgc
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
     cast(icgc_id AS bigint) as icgc_id,
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
FROM icgc_data.mtc1m
WHERE geometry && bbox
   AND layer = 'water_name'
   AND zoom_level BETWEEN 6 AND 10;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
