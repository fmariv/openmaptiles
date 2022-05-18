DROP FUNCTION IF EXISTS layer_park(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_park(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id     integer,
                geometry    geometry,
                name        text,
                class       text,
                ambit       text
            )
AS
$$
SELECT icgc_id,
       geometry,
       name,
       class,
       ambit
FROM (
         -- park enpe
        SELECT
            icgc_id,
            geometry,
            name,
            class,
            ambit
        FROM admpt.park_enpe
        UNION ALL

        -- park diba
        SELECT
            icgc_id,
            geometry,
            name,
            class,
            NULL::text AS ambit
        FROM admpt.park_diba
        UNION ALL

        -- park xarxa natura
        SELECT
            icgc_id,
            geometry,
            name,
            class,
            ambit
        FROM admpt.park_xarxa_natura
        UNION ALL

        -- park pein
        SELECT
            icgc_id,
            geometry,
            name,
            class,
            ambit
        FROM admpt.park_pein
     ) AS park
WHERE geometry && bbox
    AND zoom_level >= 7;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
