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
DROP FUNCTION IF EXISTS layer_water(bbox geometry, zoom_level int);
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
SELECT geom,
       class::text,
       waterway_brunnel(is_bridge, is_tunnel) AS brunnel,
       is_intermittent::int AS intermittent,
       NULLIF(icgc_id, 0) AS icgc_id,
       jsel,
       "rank",
       contextmaps
FROM (
         -- water_z_7_8_carto
         SELECT 
                geom,
                class,
                NULL::BOOLEAN AS is_intermittent,
                NULL::BOOLEAN AS is_bridge,
                null::BOOLEAN as is_tunnel,
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
                NULL::BOOLEAN AS is_intermittent,
                NULL::BOOLEAN AS is_bridge,
                null::BOOLEAN as is_tunnel,
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
                NULL::BOOLEAN AS is_intermittent,
                NULL::BOOLEAN AS is_bridge,
                null::BOOLEAN as is_tunnel,
                icgc_id,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.water_z_10_11_carto
         WHERE (zoom_level BETWEEN 10 AND 11 ) AND geom && bbox) 
         AS zoom_levels
WHERE geom && bbox
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
WHERE zoom_level >= 12 AND geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
