-- etldoc: layer_mountain_peak[shape=record fillcolor=lightpink,
-- etldoc:     style="rounded,filled", label="layer_mountain_peak | <z7_> z7+ | <z13_> z13+" ] ;

CREATE OR REPLACE FUNCTION layer_mountain_peak(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id      bigint,
                geometry     geometry,
                name         text,
                "name:latin" text,
                class        text,
                codigeo      int,
                mtc1m        text,
                mtc2m        text,
                layer        text
            )
AS
$$
SELECT 
     -- mountain_peak icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     codigeo,
     mtc1m,
     mtc2m,
     layer
FROM icgc_test.mtc1m
WHERE geometry && bbox
   AND layer = 'mountain_peak';

$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
