-- 
CREATE OR REPLACE FUNCTION layer_contour(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id  bigint,
                geometry geometry,
                class    text,
                height   integer
            )
AS
$$
SELECT icgc_id,
       geom,
       class,
       height
FROM contour
WHERE geom && bbox
    AND zoom_level >= 14;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
