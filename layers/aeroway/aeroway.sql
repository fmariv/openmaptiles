-- etldoc: layer_aeroway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_aeroway |<z10> z10|<z11> z11|<z12> z12|<z13> z13|<z14_> z14+" ];

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
      ) AS zoom_levels,
      (
        SELECT geometry AS muni_geom 
        FROM contextmaps.boundary_div_admin
        WHERE codimuni = '431205'
        AND class = 'municipi' 
        AND adminlevel IS NOT NULL
        ) AS muni
WHERE geom && bbox
   AND ST_Intersects(muni.muni_geom, zoom_levels.geom);
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
