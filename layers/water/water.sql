CREATE OR REPLACE FUNCTION water_class(waterway text, water text) RETURNS text AS
$$
SELECT CASE
           WHEN waterway='riverbank' THEN 'river'
           %%FIELD_MAPPING: class %%
           ELSE 'lake'
           END;
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;


CREATE OR REPLACE FUNCTION waterway_brunnel(is_bridge bool, is_tunnel bool) RETURNS text AS
$$
SELECT CASE
           WHEN is_bridge THEN 'bridge'
           WHEN is_tunnel THEN 'tunnel'
           END;
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;


-- etldoc:     layer_water [shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water |<z0> z0|<z1>z1|<z2>z2|<z3>z3 |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12+" ] ;

CREATE OR REPLACE FUNCTION layer_water(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry     geometry,
                class        text,
                brunnel      text,
                intermittent int,
                icgc_id      bigint,
                jsel         text,
                "rank"       integer,
                contextmaps  text
            )
AS
$$
SELECT geometry,
       class::text,
       waterway_brunnel(is_bridge, is_tunnel) AS brunnel,
       is_intermittent::int AS intermittent,
       icgc_id,
       NULL::text AS jsel,
       NULL::int AS "rank",
       NULL::text AS contextmaps
FROM (
         -- etldoc: water_z0 ->  layer_water:z0
         SELECT *
         FROM water_z0
         WHERE zoom_level = 0
         UNION ALL

         -- etldoc: water_z1 ->  layer_water:z1
         SELECT *
         FROM water_z1
         WHERE zoom_level = 1
         UNION ALL

         -- etldoc: water_z2 ->  layer_water:z2
         SELECT *
         FROM water_z2
         WHERE zoom_level = 2
         UNION ALL

         -- etldoc: water_z3 ->  layer_water:z3
         SELECT *
         FROM water_z3
         WHERE zoom_level = 3
         UNION ALL

         -- etldoc: water_z4 ->  layer_water:z4
         SELECT *
         FROM water_z4
         WHERE zoom_level = 4
         UNION ALL

         -- etldoc: water_z5 ->  layer_water:z5
         SELECT *
         FROM water_z5
         WHERE zoom_level = 5
         UNION ALL

         -- etldoc: water_z6 ->  layer_water:z6
         SELECT *
         FROM water_z6
         WHERE zoom_level = 6
         UNION ALL

         -- etldoc: water_z7 ->  layer_water:z7
         SELECT *
         FROM water_z7
         WHERE zoom_level = 7
         UNION ALL

         -- etldoc: water_z8 ->  layer_water:z8
         SELECT *
         FROM water_z8
         WHERE zoom_level = 8
         UNION ALL

         -- etldoc: water_z9 ->  layer_water:z9
         SELECT *
         FROM water_z9
         WHERE zoom_level = 9
         UNION ALL

         -- etldoc: water_z10 ->  layer_water:z10
         SELECT *
         FROM water_z10
         WHERE zoom_level = 10
         UNION ALL

         -- etldoc: water_z11 ->  layer_water:z11
         SELECT *
         FROM water_z11
         WHERE zoom_level = 11
         UNION ALL

         -- etldoc: water_z12 ->  layer_water:z12
         SELECT *
         FROM water_z12
         WHERE zoom_level BETWEEN 12 AND 14
     ) AS zoom_levels
WHERE geometry && bbox
UNION ALL

SELECT geometry,
       class::text,
       NULL::BOOLEAN AS brunnel,
       NULL::BOOLEAN AS intermittent,
       icgc_id,
       jsel,
       "rank",
       contextmaps
FROM (
         -- water_z_7_8_carto
         SELECT 
                geom,
                class,
                NULL::BOOLEAN AS brunnel,
                NULL::BOOLEAN AS intermittent,
                icgc_id,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.water_z_7_8_carto
         WHERE (zoom_level <= 8 ) AND geom && bbox
         UNION ALL

         -- water_z_9_10_carto
         SELECT 
                geom,
                class,
                NULL::BOOLEAN AS brunnel,
                NULL::BOOLEAN AS intermittent,
                icgc_id,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.water_z_9_10_carto
         WHERE (zoom_level = 9 ) AND geom && bbox
         UNION ALL

         -- water_z_10_11_carto
         SELECT 
                geom,
                class,
                NULL::BOOLEAN AS brunnel,
                NULL::BOOLEAN AS intermittent,
                icgc_id,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.water_z_10_11_carto
         WHERE (zoom_level BETWEEN 10 AND 11 ) AND geom && bbox
        UNION ALL
 
         -- water5m
         SELECT 
                geometry,
                class,
                brunnel,
                CAST(intermittent AS int),
                icgc_id,
                jsel,
                "rank",
                contextmaps
         FROM icgc_data.water5m
         WHERE zoom_level >= 12 AND geometry && bbox
) AS zoom_levels_icgc
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
