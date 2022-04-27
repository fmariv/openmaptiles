-- etldoc: layer_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_poi | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;
CREATE OR REPLACE FUNCTION layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                class          text,
                subclass       text,
                categoria      text,
                layer          text,
                "rank"         int,
                classicgc      text,
                icgc_id_match  bigint
                icgc_zoom      int
            )
AS
$$
SELECT 
       -- icgc POI 
       NULL::bigint as osm_id,
       icgc_id,
       geom,
       name,
       name AS "name:latin",
       class,
       subclass,
       categoria,
       layer,
       rank,
       classicgc,
       icgc_id_match,
       zoom AS icgc_zoom
FROM icgc_data.poi, (
                    SELECT geometry AS muni_geom 
                    FROM icgc_data.boundary_div_admin 
                     WHERE codimuni = '431212'
                    AND class = 'municipi' 
                    AND adminlevel IS NOT NULL
                    ) AS muni
WHERE geom && bbox
    AND zoom_level >= zoom
    AND zoom <> 0
    AND ST_Intersects(muni.muni_geom, icgc_data.poi.geom)
;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
