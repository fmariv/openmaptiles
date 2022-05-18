DROP FUNCTION IF EXISTS layer_transportation(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_transportation(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id         int,
                geometry        geometry,
                class           text,
                classicgc       text,
                d_categori      text
            )
AS
$$
SELECT icgc_id,
       geometry,
       class,
       classicgc,
       d_categori
FROM admpt.transportation_path_tourist
WHERE geometry && bbox
    AND zoom_level >= 8;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
