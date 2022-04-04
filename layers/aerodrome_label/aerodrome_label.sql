
-- etldoc: layer_aerodrome_label[shape=record fillcolor=lightpink, style="rounded,filled", label="layer_aerodrome_label | <z8> z8 | <z9> z9 | <z10_> z10+" ] ;
DROP FUNCTION IF EXISTS layer_aerodrome_label(bbox geometry, zoom_level integer);
CREATE OR REPLACE FUNCTION layer_aerodrome_label(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                id              bigint,
                icgc_id         bigint,
                geometry        geometry,
                name            text,
                "name:latin"    text,
                name_en         text,
                name_de         text,
                tags            hstore,
                class           text,
                iata            text,
                icao            text,
                ele             int,
                ele_ft          int
            )
AS
$$
SELECT
    -- etldoc: osm_aerodrome_label_point -> layer_aerodrome_label:z8
    -- etldoc: osm_aerodrome_label_point -> layer_aerodrome_label:z9
    ABS(osm_id) AS id, -- mvt feature IDs can't be negative
    NULL::int as icgc_id,
    oalp.geometry,
    oalp.name,
    oalp.name AS "name:latin",
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    oalp.tags,
    aerodrome_type AS class,
    NULLIF(iata, '') AS iata,
    NULLIF(icao, '') AS icao,
    substring(ele FROM E'^(-?\\d+)(\\D|$)')::int AS ele,
    round(substring(ele FROM E'^(-?\\d+)(\\D|$)')::int * 3.2808399)::int AS ele_ft
FROM osm_aerodrome_label_point oalp, icgc_data.catalunya c
WHERE oalp.geometry && bbox
  AND ST_Disjoint(c.geometry, oalp.geometry)
  AND aerodrome_type = 'international'
  AND iata <> ''
  AND zoom_level BETWEEN 8 AND 9

UNION ALL

SELECT
    -- etldoc: osm_aerodrome_label_point -> layer_aerodrome_label:z10_
    ABS(osm_id) AS id, -- mvt feature IDs can't be negative
    NULL::int as icgc_id,
    oalp.geometry,
    oalp.name,
    oalp.name AS "name:latin"
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    oalp.tags,
    aerodrome_type AS class,
    NULLIF(iata, '') AS iata,
    NULLIF(icao, '') AS icao,
    substring(ele FROM E'^(-?\\d+)(\\D|$)')::int AS ele,
    round(substring(ele FROM E'^(-?\\d+)(\\D|$)')::int * 3.2808399)::int AS ele_ft
FROM osm_aerodrome_label_point oalp, icgc_data.catalunya c
WHERE oalp.geometry && bbox
  AND ST_Disjoint(c.geometry, oalp.geometry)
  AND zoom_level BETWEEN 10 AND 14

UNION ALL

SELECT 
    -- icgc aerodrome label
    NULL::int AS id,
    icgc_id,
    geom,
    name,
    name AS "name:latin",
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
