-- etldoc: layer_park[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_park |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ] ;
CREATE OR REPLACE FUNCTION layer_park(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id   bigint,
                icgc_id  bigint,
                geometry geometry,
                class    text,
                name     text,
                name_en  text,
                name_de  text,
                tags     hstore,
                rank     integer
            )
AS
$$
SELECT osm_id,
       icgc_id,
       ST_Intersection(zoom_levels.geom, muni.muni_geom) as geometry,
       class,
       NULLIF(name, '') AS name,
       NULLIF(name_en, '') AS name_en,
       NULLIF(name_de, '') AS name_de,
       tags,
       rank
FROM (
         -- icgc park
         SELECT NULL::bigint AS osm_id,
                icgc_id,
                geom,
                class,
                NULL::text AS name,
                NULL::text AS name_en,
                NULL::text AS name_de,
                NULL::hstore AS tags,
                NULL::int AS rank
         FROM icgc_data.park
         WHERE zoom_level >= 6 AND geom && bbox
     ) AS zoom_levels,
     (
        SELECT geometry AS muni_geom 
        FROM icgc_data.boundary_div_admin 
        WHERE name = 'Tremp' 
        AND class = 'municipi' 
        AND adminlevel IS NOT NULL
    ) AS muni
WHERE ST_Intersects(muni.muni_geom, zoom_levels.geom)
     ;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
