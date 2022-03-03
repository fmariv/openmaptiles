-- 
CREATE OR REPLACE FUNCTION layer_template(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                
            )
AS
$$
SELECT 
FROM 
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
