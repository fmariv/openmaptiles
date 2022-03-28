-- 
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
FROM icgc_data.contour c, (SELECT geometry AS muni_geom 
                            FROM icgc_data.boundary_div_admin 
                            WHERE name = 'Santa Coloma de Gramenet' 
                            AND class = 'municipi' 
                            AND adminlevel IS NOT NULL
                           ) AS muni
WHERE geom && bbox
    AND zoom_level >= 14

UNION ALL 

SELECT c.objectid,
       ST_Intersection(c.geometry, muni.muni_geom) as geometry,
       NULL::text AS class,
       NULL AS height
FROM icgc_data.corbes_mtc250M c, (SELECT geometry AS muni_geom 
                                    FROM icgc_data.boundary_div_admin 
                                    WHERE name = 'Santa Coloma de Gramenet' 
                                    AND class = 'municipi' 
                                    AND adminlevel IS NOT NULL
                                  ) AS muni
WHERE c.geometry && bbox
    AND zoom_level BETWEEN 7 AND 13 
;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
