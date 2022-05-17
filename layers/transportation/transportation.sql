-- etldoc: layer_transportation[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="<sql> layer_transportation |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
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
