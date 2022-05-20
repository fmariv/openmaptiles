DROP FUNCTION IF EXISTS layer_contour(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_contour(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id  bigint,
                geometry geometry,
                class    text,
                height   double precision
            )
AS
$$
SELECT icgc_id,
       ST_Intersection(c.geom, muni.muni_geom) as geometry,
       class,
       height
FROM contextmaps.contour c, (SELECT geometry AS muni_geom
                            FROM historic.boundary_div_admin_20220518
                            WHERE codimuni = '431205'
                            AND class = 'municipi' 
                            AND adminlevel IS NOT NULL
                           ) AS muni
WHERE geom && bbox
    AND ST_Intersects(c.geom, muni.muni_geom)
    AND zoom_level >= 14

UNION ALL 

SELECT c.objectid,
       ST_Intersection(c.geometry, muni.muni_geom) as geometry,
       NULL::text AS class,
       NULL AS height
FROM contextmaps.corbes_mtc250M c, (SELECT geometry AS muni_geom
                                    FROM historic.boundary_div_admin_20220518
                                    WHERE codimuni = '431205'
                                    AND class = 'municipi' 
                                    AND adminlevel IS NOT NULL
                                  ) AS muni
WHERE c.geometry && bbox
    AND ST_Intersects(c.geometry, muni.muni_geom)
    AND zoom_level BETWEEN 7 AND 13 
;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
