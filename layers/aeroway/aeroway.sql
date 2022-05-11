-- etldoc: layer_aeroway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_aeroway |<z10> z10|<z11> z11|<z12> z12|<z13> z13|<z14_> z14+" ];
DROP FUNCTION IF EXISTS layer_aeroway(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_aeroway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id  bigint,
                geometry geometry,
                class    text,
                ref      text,
                tipus    int
            )
AS
$$
SELECT icgc_id, geom, aeroway AS class, ref, tipus
FROM (

         -- icgc aeroway
         SELECT icgc_id, geom, class AS aeroway, NULL::text AS ref, tipus
         FROM contextmaps.aeroway
         WHERE zoom_level >= 10 AND geom && bbox
     ) AS zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
