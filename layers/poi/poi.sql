-- etldoc: layer_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_poi | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_poi(bbox geometry, zoom_level integer, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id             int,
                geometry            geometry,
                name                text,
                "name:latin"        text,
                class               text,
                subclass            text,
                categoria           text,
                layer               text,
                "rank"              int,
                icgc_zoom           int,
                classicgc           text,
                icgc_id_match       bigint
            )
AS
$$
SELECT 
       -- POI
       icgc_id,
       geometry,
       name,
       name AS "name:latin",
       class,
       subclass,
       categoria,
       layer,
       rank,
       zoom AS icgc_zoom,
       classicgc,
       icgc_id_match
FROM contextmaps.poi
WHERE geometry && bbox
    AND zoom_level >= zoom
    AND zoom <> 0
UNION ALL

SELECT
       -- stop_bus
       icgc_id,
       geometry,
       name,
       name AS "name:latin",
       class,
       NULL::text AS subclass,
       NULL::text AS categoria,
       NULL::text AS layer,
       NULL::int AS "rank",
       NULL::int AS icgc_zoom,
       'parada_autobus' AS classicgc,
       NULL::int AS icgc_id_match
FROM contextmaps.stop_bus
WHERE geometry && bbox
    AND zoom_level >= 132;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
