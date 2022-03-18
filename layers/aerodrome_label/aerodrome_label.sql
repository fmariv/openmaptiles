
-- etldoc: layer_aerodrome_label[shape=record fillcolor=lightpink, style="rounded,filled", label="layer_aerodrome_label | <z8> z8 | <z9> z9 | <z10_> z10+" ] ;

CREATE OR REPLACE FUNCTION layer_aerodrome_label(bbox geometry,
                                                 zoom_level integer)
    RETURNS TABLE
            (
                id       bigint,
                icgc_id  bigint,
                geometry geometry,
                name     text,
                name_en  text,
                name_de  text,
                tags     hstore,
                class    text,
                iata     text,
                icao     text,
                ele      int,
                ele_ft   int
            )
AS
$$
SELECT 
    -- icgc aerodrome label
    NULL::bigint AS id,
    icgc_id,
    geom,
    name,
    name_en,
    name_de,
    NULL::hstore AS tags,
    class,
    iata,
    icao,
    CAST(ele AS int) AS ele,
    CAST(ele AS int) AS ele_ft
FROM icgc_data.aerodrome_label
WHERE zoom_level >= 10 AND geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
