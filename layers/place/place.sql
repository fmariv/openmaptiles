-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
drop function if exists layer_place(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id        int,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                class          text,
                "rank"         bigint
            )
AS
$$
SELECT 
    -- icgc place
    icgc_id,
    geometry,
    name,
    name AS "name:latin",
    class,
    rank
FROM divisions_administratives.place_div_admin
WHERE geometry && bbox
    AND zoom_level >= 6;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
