DROP FUNCTION IF EXISTS layer_contour(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_contour(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id     integer,
                geometry    geometry,
                class       text,
                height      text,
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
    -- mtc25m_altimetria_simbol
    SELECT
        icgc_id,
        geometry,
        class,
        height,
        name
    FROM admpt.mtc25m_altimetria_simbol
    WHERE zoom_level >= 7
    UNION ALL

    -- mtc25m_codi_vertex
    SELECT
        icgc_id,
        geometry,
        NULL::text AS class,
        CAST(height AS text) as height,
        text AS name
    FROM admpt.mtc25m_codi_vertex
    WHERE zoom_level >= 7
    UNION ALL

    -- cotes 50m
    SELECT
        icgc_id,
        geometry,
        class,
        textstring AS height,
        NULL::text AS name
    FROM admpt.contour_cotes50m
    WHERE zoom_level BETWEEN 10 AND 11
    UNION ALL

    -- altimetria 50
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        NULL::text AS name
    FROM admpt.mtc50m_altimetria_simbol
    WHERE zoom_level BETWEEN 10 AND 11
    UNION ALL

    -- mtc250_corbes_nivell
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        NULL::text AS name
    FROM admpt.mtc250m_corbes_nivell
    WHERE zoom_level = 9
    UNION ALL

    -- mtc250m_cota_altimetrica_p_lines
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        NULL::text AS name
    FROM admpt.mtc250m_etiquetes_corbes_altimetria_p_lines
    WHERE zoom_level = 9
    UNION ALL

    -- mtc250m_cota_batimetrica_p_lines
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        NULL::text AS name
    FROM admpt.mtc250m_etiqueta_batimetria_p_lines
    WHERE zoom_level = 9
    UNION ALL

    -- mtc250_altimetria_simbol
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        nom AS name
    FROM admpt.mtc250m_altimetria_simbol
    WHERE zoom_level = 9
    UNION ALL

    -- mtc50m_corbes_nivell
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        NULL::text AS name
    FROM admpt.mtc50m_corbes_nivell
    WHERE zoom_level BETWEEN 10 AND 11
    UNION ALL

    -- etiquetes corbes
    SELECT
        icgc_id,
        geometry,
        class,
        text AS height,
        NULL::text AS name
    FROM admpt.etiquetes_corbes
    WHERE zoom_level BETWEEN 11 AND 13
    UNION ALL

    -- mtc25m_corbes_nivell
    SELECT
        icgc_id,
        geometry,
        class,
        NULL::text AS height,
        NULL::text AS name
    FROM admpt.mtc25m_corbes_nivell
    WHERE zoom_level BETWEEN 12 AND 13
    UNION ALL

    -- cotes 5m
    SELECT
        icgc_id,
        geometry,
        class,
        name AS height,
        NULL::text AS name
    FROM admpt.contour_cotes5m
    WHERE zoom_level >= 14
    ) as contour
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
