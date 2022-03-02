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
       ST_Intersection(contour.geom, c.geometry) as geometry,
       class,
       height
FROM contour, admin.cat c
WHERE contour.geom && bbox
    AND zoom_level >= 14;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
