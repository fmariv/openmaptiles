-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                icgc_id        int,
                geometry       geometry,
                name           text,
                class          text,
                "rank"         bigint
            )
AS
$$
SELECT 
    -- icgc place
    icgc_id,
    geom,
    name,
    class,
    rank
FROM icgc_data.place_div_admin
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
