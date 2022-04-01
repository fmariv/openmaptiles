-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id        int,
                geometry       geometry,
                name           text,
                class          text,
                "rank"         bigint,
                codi_geogr     text,
                estat          text,
                codi_estat     text,
                concepte_g     text
            )
AS
$$
SELECT 
    -- icgc place
    icgc_id,
    geom,
    name,
    class,
    rank,
    codi_geogr,
    estat,
    codi_estat,
    concepte_g
FROM icgc_test.toponimia_mundial
WHERE geom && bbox
UNION ALL

SELECT 
    -- icgc place
    icgc_id,
    geometry,
    name,
    class,
    rank,
    NULL::text AS codi_geogr,
    estat,
    sov_a3,
    NULL::text AS concepte_g
FROM icgc_data.admin_0_p
WHERE geometry && bbox
UNION ALL

SELECT 
    -- icgc place
    icgc_id,
    geometry,
    name,
    class,
    rank,
    NULL::text AS codi_geogr,
    estat,
    sov_a3,
    NULL::text AS concepte_g
FROM icgc_data.admin_1_p
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
