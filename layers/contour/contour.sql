-- 
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
       ST_Intersection(c.geom, cat.geometry) as geometry,
       class,
       height
FROM contextmaps.contour c, contextmaps.catalunya cat
WHERE geom && bbox
    AND zoom_level >= 14

UNION ALL 

SELECT c.objectid,
       ST_Intersection(c.geometry, cat.geometry) as geometry,
       NULL::text AS class,
       NULL AS height
FROM contextmaps.corbes_mtc250M c, contextmaps.catalunya cat
WHERE c.geometry && bbox
    AND zoom_level BETWEEN 7 AND 13 
;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
