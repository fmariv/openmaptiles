DROP FUNCTION IF EXISTS layer_landcover(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_landcover(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id         integer,
                geometry        geometry,
                class           text,
                subclass        text,
                categoria       bigint,
                classicgc       text
            )
AS
$$
SELECT
       icgc_id,
       geometry,
       class,
       subclass,
       categoria,
       classicgc
FROM (
        -- cobertes sol
        SELECT
            icgc_id,
            geometry,
            NULL::text AS class,
            NULL::text AS subclass,
            categoria,
            NULL::text AS classicgc
        FROM admpt.cobertes_sol
        WHERE zoom_level >= 10
        UNION ALL

        -- landcover golf
        SELECT
            icgc_id,
            geometry,
            'golf' AS class,
            NULL::text AS subclass,
            categories AS categoria,
            classicgc
        FROM admpt.landcover_golf
        WHERE zoom_level >= 12
        UNION ALL

        -- landcover line
        SELECT
            icgc_id,
            geometry,
            class,
            NULL::text AS subclass,
            categories AS categoria,
            NULL::text AS classicgc
        FROM admpt.landcover_line
        WHERE zoom_level >= 14
        UNION ALL

        -- cobertes sol pattern
        SELECT
            icgc_id,
            geometry,
            NULL::text AS class,
            NULL::text AS subclass,
            categoria,
            NULL::text AS classicgc
        FROM admpt.cobertes_sol_pat
        WHERE zoom_level >= 14
     ) AS landcover
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;