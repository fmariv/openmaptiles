-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
DROP FUNCTION IF EXISTS layer_place(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id        int,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                nommuni        text,
                class          text,
                "rank"         smallint,
                tipuscap       text,
                capvegue       text,
                capprov        text,
                codimuni       text,
                codicomar      text,
                codiprov       text,
                dataalta       text
            )
AS
$$
SELECT 
    -- icgc place
    icgc_id,
    geometry,
    name,
    name AS "name:latin",
    nommuni,
    class,
    rank,
    tipuscap,
    capvegue,
    capprov,
    codimuni,
    codicomar,
    codiprov,
    dataalta
FROM divisions_administratives.place_div_admin
WHERE geometry && bbox
    AND zoom_level >= 6;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
