-- etldoc: layer_place[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_place | <z0_3> z0-3|<z4_7> z4-7|<z8_11> z8-11| <z12_14> z12-z14+" ] ;
DROP FUNCTION IF EXISTS layer_place(bbox geometry, zoom_level int, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_place(bbox geometry, zoom_level int, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                class          text,
                "rank"         integer,
                codigeo        integer,
                icgc_id_match  bigint,
                icgc_zoom      smallint,
                mtc1m          text,
                mtc2m          text,
                layer          text
            )
AS
$$
SELECT 
    -- icgc place
    NULL::int AS osm_id,
    icgc_id,
    geom,
    name,
    name AS "name:latin",
    class,
    "rank",
    codigeo,
    icgc_id_match,
    zoom AS icgc_zoom,
    NULL::text AS mtc1m,
    NULL::text AS mtc2m,
    NULL::text AS layer
FROM icgc_data.place
WHERE zoom <= zoom_level and geom && bbox
UNION ALL

SELECT 
     -- mtc1m icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     NULL::smallint AS "rank",
     codigeo,
     NULL::bigint AS icgc_id_match,
     NULL::smallint AS icgc_zoom,
     mtc1m,
     mtc2m,
     layer
FROM icgc_test.mtc1m
WHERE geometry && bbox
   AND layer = 'place'
   AND zoom_level BETWEEN 6 AND 10
UNION ALL

SELECT 
     -- place5m icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     "rank",
     codigeo,
     NULL::bigint AS icgc_id_match,
     NULL::smallint AS icgc_zoom,
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     layer
FROM icgc_data.place5m
WHERE geometry && bbox
   AND zoom_level >= 12
UNION ALL

SELECT 
     -- place5m along icgc
     icgc_id,
     geometry,
     name,
     name AS "name:latin",
     class,
     "rank",
     codigeo,
     NULL::bigint AS icgc_id_match,
     NULL::smallint AS icgc_zoom,
     NULL::text AS mtc1m,
     NULL::text AS mtc2m,
     layer
FROM icgc_data.place5m_along
WHERE geometry && bbox
   AND zoom_level >= 12
UNION ALL

SELECT osm_id,
       NULL::int AS icgc_id,
       geometry,
       name,
       class,
       rank,
       NULL::int AS codigeo,
       NULL::int AS icgc_id_match,
       NULL::int AS icgc_zoom,
       NULL::text AS mtc1m,
       NULL::text AS mtc2m,
       NULL::text AS layer
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
             osm_id * 10 AS osm_id,
             geometry,
             name,
             'island' AS class,
             7 AS "rank"
         FROM osm_island_point oip
         WHERE zoom_level BETWEEN 12 AND 14
            AND geometry && bbox

         UNION ALL

         SELECT
             -- etldoc: osm_island_polygon  -> layer_place:z8_11
             -- etldoc: osm_island_polygon  -> layer_place:z12_14
             osm_id * 10 AS osm_id,
             oip.geometry,
             oip.name,
             'island' AS class,
             island_rank(area) AS "rank"
         FROM osm_island_polygon oip, icgc_data.catalunya c
         WHERE oip.geometry && bbox
           AND ST_Disjoint(c.geometry, oip.geometry)
           AND ((zoom_level = 8 AND island_rank(area) <= 3)
             OR (zoom_level = 9 AND island_rank(area) <= 4)
             OR (zoom_level BETWEEN 10 AND 14))

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
