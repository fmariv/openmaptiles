-- etldoc:     layer_water [shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water |<z0> z0|<z1>z1|<z2>z2|<z3>z3 |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12+" ] ;
DROP FUNCTION IF EXISTS layer_water(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_water(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry     geometry,
                class        text,
                brunnel      text,
                intermittent int,
                icgc_id      int
            )
AS
$$
SELECT geometry,
       class,
       NULL::text AS brunnel,
       NULL::int AS intermittent,
       icgc_id
FROM contextmaps.ocean
WHERE geometry && bbox
    AND zoom_level BETWEEN 1 AND 2
UNION ALL

SELECT geometry,
       class,
       NULL::text AS brunnel,
       NULL::int AS intermittent,
       icgc_id
FROM contextmaps.subdivided_ocean
WHERE geometry && bbox
    AND zoom_level >= 3;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
