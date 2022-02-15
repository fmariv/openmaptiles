-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;

CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                name_en        text,
                name_de        text,
                tags           hstore,
                class          text,
                "rank"         integer,
                capital        integer,
                iso_a2         text,
                codigeo        integer,
                zoom           integer,
                icgc_id_match  integer
            )
AS
$$
SELECT place_all.*
FROM (
         SELECT
             -- etldoc: osm_continent_point -> layer_place:z0_3
             osm_id * 10 AS osm_id,
             NULL::int AS icgc_id,
             ocp.geometry,
             ocp.name,
             COALESCE(NULLIF(name_en, ''), name) AS name_en,
             COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
             ocp.tags,
             'continent' AS class,
             1 AS "rank",
             NULL::int AS capital,
             NULL::text AS iso_a2,
             NULL::int AS codigeo,
             NULL::int AS zoom,
             NULL::int AS icgc_id_match 
         FROM osm_continent_point ocp, admin.cat c
         WHERE ocp.geometry && bbox
           AND ST_Disjoint(c.geometry, ocp.geometry)
           AND zoom_level < 4

         UNION ALL

         SELECT
             -- etldoc: osm_country_point -> layer_place:z0_3
             -- etldoc: osm_country_point -> layer_place:z4_7
             -- etldoc: osm_country_point -> layer_place:z8_11
             -- etldoc: osm_country_point -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             NULL::int AS icgc_id,
             ocp.geometry,
             ocp.name,
             COALESCE(NULLIF(name_en, ''), name) AS name_en,
             COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
             ocp.tags,
             'country' AS class,
             "rank",
             NULL::int AS capital,
             iso3166_1_alpha_2 AS iso_a2,
             NULL::int AS codigeo,
             NULL::int AS zoom,
             NULL::int AS icgc_id_match 
         FROM osm_country_point ocp, admin.cat c
         WHERE ocp.geometry && bbox
           AND ST_Disjoint(c.geometry, ocp.geometry)
           AND "rank" <= zoom_level + 1
           AND name <> ''

         UNION ALL

         SELECT
             -- etldoc: osm_state_point  -> layer_place:z0_3
             -- etldoc: osm_state_point  -> layer_place:z4_7
             -- etldoc: osm_state_point  -> layer_place:z8_11
             -- etldoc: osm_state_point  -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             NULL::int AS icgc_id,
             osp.geometry,
             osp.name,
             COALESCE(NULLIF(name_en, ''), name) AS name_en,
             COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
             osp.tags,
             place::text AS class,
             "rank",
             NULL::int AS capital,
             NULL::text AS iso_a2,
             NULL::int AS codigeo,
             NULL::int AS zoom,
             NULL::int AS icgc_id_match 
         FROM osm_state_point osp, admin.cat c
         WHERE osp.geometry && bbox
           AND ST_Disjoint(c.geometry, osp.geometry)
           AND name <> ''
           AND zoom_level > 1

         UNION ALL

         SELECT
             -- etldoc: osm_island_point    -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             NULL::int AS icgc_id,
             oip.geometry,
             oip.name,
             COALESCE(NULLIF(name_en, ''), name) AS name_en,
             COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
             oip.tags,
             'island' AS class,
             7 AS "rank",
             NULL::int AS capital,
             NULL::text AS iso_a2,
             NULL::int AS codigeo,
             NULL::int AS zoom,
             NULL::int AS icgc_id_match 
         FROM osm_island_point oip, admin.cat c
         WHERE zoom_level >= 12
           AND ST_Disjoint(c.geometry, oip.geometry)
           AND oip.geometry && bbox

         UNION ALL

         SELECT
             -- etldoc: osm_island_polygon  -> layer_place:z8_11
             -- etldoc: osm_island_polygon  -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             NULL::int AS icgc_id,
             oip.geometry,
             oip.name,
             COALESCE(NULLIF(name_en, ''), name) AS name_en,
             COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
             oip.tags,
             'island' AS class,
             island_rank(area) AS "rank",
             NULL::int AS capital,
             NULL::text AS iso_a2,
             NULL::int AS codigeo,
             NULL::int AS zoom,
             NULL::int AS icgc_id_match 
         FROM osm_island_polygon oip, admin.cat c
         WHERE oip.geometry && bbox
           AND ST_Disjoint(c.geometry, oip.geometry)
           AND ((zoom_level = 8 AND island_rank(area) <= 3)
             OR (zoom_level = 9 AND island_rank(area) <= 4)
             OR (zoom_level >= 10))

         UNION ALL

         -- icgc place
         SELECT 
             NULL::int AS osm_id,
             icgc_id,
             geom,
             name,
             NULL::text AS name_en,
             NULL::text AS name_de,
             NULL::hstore AS tags,
             class,
             rank,
             NULL::int AS capital,
             NULL::text AS iso_a2,
             codigeo,
             zoom,
             icgc_id_match
         FROM place
         WHERE zoom <= zoom_level and geom && bbox

         UNION ALL

         -- layer_city
         SELECT
             -- etldoc: layer_city          -> layer_place:z0_3
             -- etldoc: layer_city          -> layer_place:z4_7
             -- etldoc: layer_city          -> layer_place:z8_11
             -- etldoc: layer_city          -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             NULL::int AS icgc_id,
             geometry,
             name,
             name_en,
             name_de,
             tags,
             place::text AS class,
             "rank",
             capital,
             NULL::text AS iso_a2,
             NULL::int AS codigeo,
             NULL::int AS zoom,
             NULL::int AS icgc_id_match 
         -- The city layer is already filtered by extend
         FROM layer_city(bbox, zoom_level, pixel_width)
         ORDER BY "rank" ASC
     ) AS place_all
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
