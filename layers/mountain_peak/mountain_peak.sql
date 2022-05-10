-- etldoc: layer_mountain_peak[shape=record fillcolor=lightpink,
-- etldoc:     style="rounded,filled", label="layer_mountain_peak | <z7_> z7+ | <z13_> z13+" ] ;
DROP FUNCTION IF EXISTS layer_mountain_peak(bbox geometry, zoom_level integer, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_mountain_peak(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id      bigint,
                geometry     geometry,
                name         text,
                "name:latin" text,
                class        text,
                codigeo      bigint,
                rank         int,
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
     NULL::int AS "rank",
     mtc1m,
     mtc2m,
     layer
FROM contextmaps.mtc1m
WHERE geometry && bbox
   AND layer = 'mountain_peak'
   AND zoom_level BETWEEN 6 AND 10
UNION ALL

SELECT 
     -- place5m along icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     CAST(codigeo AS text) AS class,
     codigeo,
     "rank",
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     layer
FROM contextmaps.place5m_along
WHERE geometry && bbox
   AND zoom_level >= 12
   AND codigeo BETWEEN 50000 AND 59999;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
