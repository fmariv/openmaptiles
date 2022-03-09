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
       ST_Intersection(c.geom, cat.geometry) as geometry,
       class,
       height
FROM icgc_data.contour c, icgc_data.catalunya cat
WHERE geom && bbox
    AND zoom_level >= 14

UNION ALL 

SELECT objectid,
       ST_Intersection(c.geometry, cat.geometry) as geometry,
       NULL::text AS class,
       NULL AS height
FROM icgc_data.corbes_mtc250M c, icgc_data.catalunya cat
WHERE geom && bbox
    AND zoom_level BETWEEN 7 AND 13 
;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
