-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                osm_id       bigint,
                icgc_id      bigint,
                geometry     geometry,
                name         text,
                name_en      text,
                name_de      text,
                tags         hstore,
                class        text,
                intermittent int,
                zoom         int,
                rank         int,
                codigeo     int,
                fontsize    float
            )
AS
$$
SELECT
    -- etldoc: osm_water_lakeline ->  layer_water_name:z9_13
    -- etldoc: osm_water_lakeline ->  layer_water_name:z14_
    CASE
        WHEN osm_id < 0 THEN -osm_id * 10 + 4
        ELSE osm_id * 10 + 1
        END AS osm_id_hash,
    NULL::INT AS icgc_id,
    w.geometry,
    w.name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    w.tags,
    'lake'::text AS class,
    is_intermittent::int AS intermittent,
    NULL::INT AS zoom,
    NULL::INT AS rank,
    NULL::INT AS codigeo,
    NULL::FLOAT AS fontsize
FROM osm_water_lakeline w, admin.cat c
WHERE w.geometry && bbox
  AND ST_Disjoint(c.geometry, w.geometry)
  AND ((zoom_level BETWEEN 9 AND 13 AND LineLabel(zoom_level, NULLIF(name, ''), w.geometry))
    OR (zoom_level >= 14))
UNION ALL

SELECT
    -- etldoc: osm_water_point ->  layer_water_name:z9_13
    -- etldoc: osm_water_point ->  layer_water_name:z14_
    CASE
        WHEN osm_id < 0 THEN -osm_id * 10 + 4
        ELSE osm_id * 10 + 1
        END AS osm_id_hash,
    NULL::INT AS icgc_id,
    w.geometry,
    w.name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    w.tags,
    'lake'::text AS class,
    is_intermittent::int AS intermittent,
    NULL::INT AS zoom,
    NULL::INT AS rank,
    NULL::INT AS codigeo,
    NULL::FLOAT AS fontsize
FROM osm_water_point w, admin.cat c
WHERE w.geometry && bbox
  AND ST_Disjoint(c.geometry, w.geometry)
  AND (
        (zoom_level BETWEEN 9 AND 13 AND area > 70000 * 2 ^ (20 - zoom_level))
        OR (zoom_level >= 14)
    )
UNION ALL

SELECT
    -- etldoc: osm_marine_point ->  layer_water_name:z0_8
    -- etldoc: osm_marine_point ->  layer_water_name:z9_13
    -- etldoc: osm_marine_point ->  layer_water_name:z14_
    osm_id * 10 AS osm_id_hash,
    NULL::INT AS icgc_id,
    omp.geometry,
    omp.name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    omp.tags,
    place::text AS class,
    is_intermittent::int AS intermittent,
    NULL::INT AS zoom,
    NULL::INT AS rank,
    NULL::INT AS codigeo,
    NULL::FLOAT AS fontsize
FROM osm_marine_point omp, ocean_d15 od
WHERE omp.geometry && bbox
  AND ST_Disjoint(od.geom, omp.geometry)
  AND (
        place = 'ocean'
        OR (zoom_level >= "rank" AND "rank" IS NOT NULL)
        OR (zoom_level >= 8)
    )
UNION ALL

SELECT 
     -- water_name icgc
     NULL::INT as osm_id,
     w.icgc_id,
     w.geom,
     w.name,
     NULL::TEXT AS name_en,
     NULL::TEXT AS name_de,
     NULL::hstore AS tags,
     w.class,
     NULL::INT AS intermittent,
     w.zoom,
     w.rank,
     w.codigeo,
     w.fontsize
FROM water_name w
WHERE zoom_level >= w.zoom AND w.geom && bbox
UNION ALL

SELECT
     -- waterway icgc
     NULL::INT as osm_id,
     w.icgc_id,
     w.geom,
     w.name,
     NULL::TEXT AS name_en,
     NULL::TEXT AS name_de,
     NULL::hstore AS tags,
     w.class,
     NULL::INT AS intermittent,
     w.zoom,
     w.rank,
     w.codigeo,
     w.fontsize
FROM waterway w
WHERE zoom_level >= w.zoom AND w.geom && bbox
    ;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
