-- etldoc: layer_waterway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="layer_waterway | <z3> z3 |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ];

CREATE OR REPLACE FUNCTION layer_waterway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (   
            	icgc_id      bigint,
                geometry     geometry,
                class        text,
                name         text,
                entorn       text
            )
AS
$$
SELECT icgc_id,
       geometry,
       class,
       NULLIF(name, '') AS name,
       entorn
FROM (
         -- etldoc: waterway_z3 ->  layer_waterway:z3
         SELECT *
         FROM waterway_z3
         WHERE zoom_level = 3
         UNION ALL

         -- etldoc: waterway_z4 ->  layer_waterway:z4
         SELECT *
         FROM waterway_z4
         WHERE zoom_level = 4
         UNION ALL

         -- etldoc: waterway_z5 ->  layer_waterway:z5
         SELECT *
         FROM waterway_z5
         WHERE zoom_level = 5
         UNION ALL

         -- etldoc: waterway_z6 ->  layer_waterway:z6
         SELECT *
         FROM waterway_z6
         WHERE zoom_level = 6
         UNION ALL

         -- etldoc: waterway_z7 ->  layer_waterway:z7
         SELECT *
         FROM waterway_z7
         WHERE zoom_level = 7
         UNION ALL

         -- etldoc: waterway_z8 ->  layer_waterway:z8
         SELECT *
         FROM waterway_z8
         WHERE zoom_level = 8
         UNION ALL

         -- etldoc: waterway_z9 ->  layer_waterway:z9
         SELECT *
         FROM waterway_z9
         WHERE zoom_level = 9
         UNION ALL

         -- etldoc: waterway_z10 ->  layer_waterway:z10
         SELECT *
         FROM waterway_z10
         WHERE zoom_level = 10
         UNION ALL

         -- etldoc: waterway_z11 ->  layer_waterway:z11
         SELECT *
         FROM waterway_z11
         WHERE zoom_level = 11
         UNION ALL

         -- etldoc: waterway_z12 ->  layer_waterway:z12
         SELECT *
         FROM waterway_z12
         WHERE zoom_level = 12
         UNION ALL

         -- etldoc: waterway_z13 ->  layer_waterway:z13
         SELECT *
         FROM waterway_z13
         WHERE zoom_level = 13
         UNION ALL

         -- etldoc: waterway_z14 ->  layer_waterway:z14
         SELECT *
         FROM waterway_z14
         WHERE zoom_level >= 14
         UNION ALL

         -- icgc waterway_z_7_8_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn
         FROM icgc_data.waterway_z_7_8_carto
         WHERE (zoom_level BETWEEN 7 AND 8) AND geom && bbox
         UNION ALL

         -- waterway_z_9_10_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn
         FROM icgc_data.waterway_z_9_10_carto 
         WHERE (zoom_level = 9) AND geom && bbox
         UNION ALL

         -- waterway_z_10_11_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn
         FROM icgc_data.waterway_z_10_11_carto 
         WHERE (zoom_level BETWEEN 10 AND 11) AND geom && bbox
         UNION ALL

         -- waterway strahler
         SELECT icgc_id,
                geom,
                class,
                name,
                entorn
         FROM icgc_data.waterway_bt5mv30_strahler w
         WHERE 
         (w.entorn <> 'UR' ) AND (
            ((zoom_level BETWEEN 12 AND 13) AND (w.strahler_order > 2 OR w.jsel in ('3A','3B','3C','2A','2B') ) AND w.geom && bbox) OR
            ((zoom_level = 14)  AND (w.strahler_order >1 OR w.jsel in ('3A','3B','3C','2A','2B') ) AND w.geom && bbox) OR
            ((zoom_level >14)  AND w.geom && bbox) )
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
