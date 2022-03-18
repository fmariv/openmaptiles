-- etldoc: layer_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_poi | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;
CREATE OR REPLACE FUNCTION layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                class          text,
                subclass       text,
                categoria      text,
                layer          text,
                "rank"         int,
                classicgc      text,
                icgc_id_match  bigint
                -- No s'inclou zoom per què dona error al generar les mbtiles
            )
AS
$$
SELECT 
       -- icgc POI 
       NULL::bigint as osm_id,
       icgc_id,
       geom,
       name,
       class,
       subclass,
       categoria,
       layer,
       rank,
       classicgc,
       icgc_id_match
FROM icgc_data.poi
WHERE geom && bbox
    AND zoom_level >= zoom
    AND zoom <> 0
;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
