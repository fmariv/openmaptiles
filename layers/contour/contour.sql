-- 
DROP FUNCTION IF EXISTS layer_contour(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_contour(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id     integer,
                geometry    geometry,
                class       text,
                height      double precision,
                name        text
            )
AS
$$
SELECT
    icgc_id,
    geometry,
    class,
    height,
    name
FROM (
    -- cotes 5m
    SELECT
        id AS icgc_id,
        geom AS geometry,
        class,
        CAST(name AS double precision) AS height,
        NULL::text AS name
    FROM admpt.contour_cotes5m
    UNION ALL

    -- etiquetes corbes
    SELECT
        id AS icgc_id,
        geom AS geometry,
        CAST(annotationclassid AS text) AS class,
        CAST(text AS double precision) AS height,
        NULL::text AS name
    FROM admpt.etiquetes_corbes
    UNION ALL

    -- mtc25m_altimetria_simbol
    SELECT
        id AS icgc_id,
        geom AS geometry,
        CAST(símbol AS text) AS class,
        NULL::double precision AS height,
        null::text as name
    FROM admpt.mtc25m_altimetria_simbol
    UNION ALL

    -- mtc25m_codi_vertex
    SELECT
        icgc_id,
        geometry,
        NULL::text AS class,
        height,
        text AS name
    FROM admpt.mtc25m_codi_vertex
    UNION ALL

    -- mtc25m_corbes_nivell
    SELECT
        id AS icgc_id,
        geom AS geometry,
        CAST(tipus_de_corba AS text) AS class,
        NULL::double precision AS height,
        NULL::text AS name
    FROM admpt.mtc25m_corbes_nivell
     ) as contour
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
