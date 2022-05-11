-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
DROP FUNCTION IF EXISTS layer_place(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                class          text,
                "rank"         integer,
                codigeo        bigint,
                icgc_id_match  bigint,
                icgc_zoom      smallint,
                mtc1m          text,
                mtc2m          text,
                layer          text
            )
AS
$$
SELECT 
    -- icgc place
    icgc_id,
    geom,
    name,
    name AS "name:latin",
    class,
    "rank",
    codigeo,
    icgc_id_match,
    zoom AS icgc_zoom,
    NULL::text AS mtc1m,
    NULL::text AS mtc2m,
    NULL::text AS layer
FROM contextmaps.place
WHERE (zoom <= zoom_level AND zoom < 12) AND geom && bbox
UNION ALL

SELECT 
     -- mtc1m icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     NULL::smallint AS "rank",
     codigeo,
     NULL::bigint AS icgc_id_match,
     NULL::smallint AS icgc_zoom,
     mtc1m,
     mtc2m,
     layer
FROM contextmaps.mtc1m
WHERE geometry && bbox
   AND layer = 'place'
   AND zoom_level BETWEEN 6 AND 10
UNION ALL

SELECT 
     -- place5m icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     "rank",
     codigeo,
     NULL::bigint AS icgc_id_match,
     NULL::smallint AS icgc_zoom,
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     layer
FROM contextmaps.place5m
WHERE geometry && bbox
   AND zoom_level >= 12
UNION ALL

SELECT 
     -- place5m along icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     CAST(codigeo AS text) AS class,
     "rank",
     codigeo,
     NULL::bigint AS icgc_id_match,
     NULL::smallint AS icgc_zoom,
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     layer
FROM contextmaps.place5m_along
WHERE geometry && bbox
   AND zoom_level >= 12
   AND codigeo NOT BETWEEN 50000 AND 59999;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
