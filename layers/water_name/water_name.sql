-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id      bigint,
                geometry     geometry,
                name         text,
                "name:latin" text,
                class        text,
                icgc_zoom    smallint,
                rank         smallint,
                codigeo      int,
                fontsize     float
            )
AS
$$
SELECT 
     -- water_name icgc
     w.icgc_id,
     w.geom,
     w.name,
     name AS "name:latin",
     w.class,
     w.zoom AS icgc_zoom,
     w.rank,
     w.codigeo,
     w.fontsize
FROM icgc_data.water_name w
WHERE zoom_level >= w.zoom AND w.geom && bbox
UNION ALL

SELECT
     -- waterway icgc
     w.icgc_id,
     w.geom,
     w.name,
     name AS "name:latin",
     w.class,
     w.zoom AS icgc_zoom,
     w.rank,
     w.codigeo,
     w.fontsize
FROM icgc_data.waterway w
WHERE zoom_level >= w.zoom AND w.geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
