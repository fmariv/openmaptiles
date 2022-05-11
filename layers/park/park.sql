-- etldoc: layer_park[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_park |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ] ;
DROP FUNCTION IF EXISTS layer_park(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_park(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
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
SELECT icgc_id,
       geom,
       class,
       NULLIF(name, '') AS name,
       NULLIF(name_en, '') AS name_en,
       NULLIF(name_de, '') AS name_de,
       tags,
       rank
FROM (
         -- icgc park
         SELECT icgc_id,
                geom,
                class,
                NULL::text AS name,
                NULL::text AS name_en,
                NULL::text AS name_de,
                NULL::hstore AS tags,
                NULL::int AS rank
         FROM contextmaps.park
         WHERE zoom_level >= 6 AND geom && bbox
     ) AS park_all;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
