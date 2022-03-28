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
       ST_Intersection(zoom_levels.geom, muni.muni_geom) as geometry,
       class,
       NULLIF(name, '') AS name,
       entorn
FROM (
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
     ) AS zoom_levels,
     (
        SELECT geometry AS muni_geom 
        FROM icgc_data.boundary_div_admin 
        WHERE name = 'Tremp' 
        AND class = 'municipi' 
        AND adminlevel IS NOT NULL
        ) AS muni
WHERE geom && bbox
   AND ST_Intersects(muni.muni_geom, zoom_levels.geom);
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
