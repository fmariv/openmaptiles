-- etldoc: layer_park[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_park |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ] ;
DROP FUNCTION IF EXISTS layer_park(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_park(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id     integer,
                geometry    geometry,
                name        text,
                class       text
            )
AS
$$
SELECT icgc_id,
       geometry,
       name,
       class
FROM (
         -- park enpe
        SELECT
            icgc_id,
            geometry,
            name,
            class
        FROM admpt.park_enpe
        UNION ALL

        -- park diba
        SELECT
            icgc_id,
            geometry,
            name,
            class
        FROM admpt.park_diba
        UNION ALL

        -- park xarxa natura
        SELECT
            icgc_id,
            geometry,
            name,
            class
        FROM admpt.park_xarxa_natura
        UNION ALL

        -- park pein
        SELECT
            icgc_id,
            geometry,
            name,
            class
        FROM admpt.park_pein
     ) AS park_all
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
