-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                class          text,
                "rank"         smallint,
                codigeo        integer,
                icgc_id_match  bigint,
                icgc_zoom      smallint
            )
AS
$$
SELECT 
    -- icgc place
    NULL::bigint AS osm_id,
    icgc_id,
    geom,
    name,
    name AS "name:latin",
    class,
    rank,
    codigeo,
    icgc_id_match,
    zoom AS icgc_zoom
FROM icgc_data.place
WHERE zoom <= zoom_level and geom && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
