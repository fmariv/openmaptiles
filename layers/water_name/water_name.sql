-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_water_name(bbox geometry, zoom_level integer);
CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id      int,
                geometry     geometry,
                name         text,
                "name:latin" text,
                class        text,
                codigeo      bigint,
                mtc1m        text,
                mtc2m        text,
                layer        text
            )
AS
$$
SELECT 
     -- water_name icgc
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
   AND layer = 'water_name';
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
