-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;

CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                class          text,
                "rank"         integer,
                codigeo        integer,
                icgc_id_match  bigint
            )
AS
$$
SELECT 
    -- icgc place
    NULL::int AS osm_id,
    icgc_id,
    geom,
    name,
    class,
    rank,
    codigeo,
    icgc_id_match
FROM icgc_data.place
WHERE zoom <= zoom_level and geom && bbox

UNION ALL

SELECT osm_id,
       NULL::int AS icgc_id,
       geometry,
       name,
       class,
       rank,
       NULL::int AS codigeo,
       NULL::int AS icgc_id_match
FROM (
         SELECT
             -- etldoc: osm_continent_point -> layer_place:z0_3
             osm_id * 10 AS osm_id,
             geometry,
             name,
             'continent' AS class,
             1 AS "rank"
         FROM osm_continent_point 
         WHERE geometry && bbox
           AND zoom_level < 4

         UNION ALL

         SELECT
             -- etldoc: osm_country_point -> layer_place:z0_3
             -- etldoc: osm_country_point -> layer_place:z4_7
             -- etldoc: osm_country_point -> layer_place:z8_11
             -- etldoc: osm_country_point -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             geometry,
             name,
             'country' AS class,
             "rank"
         FROM osm_country_point 
         WHERE geometry && bbox
           AND "rank" <= zoom_level + 1
           AND name <> ''

         UNION ALL

         SELECT
             -- etldoc: osm_state_point  -> layer_place:z0_3
             -- etldoc: osm_state_point  -> layer_place:z4_7
             -- etldoc: osm_state_point  -> layer_place:z8_11
             -- etldoc: osm_state_point  -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             geometry,
             name,
             place::text AS class,
             "rank"
         FROM osm_state_point osp
         WHERE geometry && bbox
           AND name <> ''
           AND zoom_level > 1

         UNION ALL

         SELECT
             -- etldoc: osm_island_point    -> layer_place:z12_14
             -- There is only one feature in the osm_island_point layer that is contained by Catalonia.
             -- So, perform the filter or delete the feature?
             *
         FROM osm_island_point_planet
         WHERE zoom_level >= 12
            AND geometry && bbox

         UNION ALL

         SELECT
             -- etldoc: osm_island_polygon  -> layer_place:z8_11
             -- etldoc: osm_island_polygon  -> layer_place:z12_14
             *
         FROM osm_island_polygon_planet 
         WHERE geometry && bbox
           AND ((zoom_level = 8 AND island_rank(area) <= 3)
             OR (zoom_level = 9 AND island_rank(area) <= 4)
             OR (zoom_level >= 10))

         UNION ALL

         -- layer_city
         SELECT
             -- etldoc: layer_city          -> layer_place:z0_3
             -- etldoc: layer_city          -> layer_place:z4_7
             -- etldoc: layer_city          -> layer_place:z8_11
             -- etldoc: layer_city          -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             geometry,
             name,
             place::text AS class,
             "rank"
         -- The city layer is already filtered by extend
         FROM layer_city(bbox, zoom_level, pixel_width)
         ORDER BY "rank" ASC
     ) AS place_all
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
