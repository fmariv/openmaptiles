CREATE OR REPLACE FUNCTION layer_landcover(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry geometry,
                class    text,
                subclass text,
                icgc_id  bigint
            )
AS
$$
SELECT ST_Intersection(zoom_levels.geom, muni.muni_geom) as geometry,
       class,
       null::text as subclass,
       NULLIF(icgc_id, 0) AS icgc_id
FROM (

         -- landcover_z7_z8
         SELECT geom,
                class,
                icgc_id
         FROM icgc_data.landcover_z7_z8
         WHERE (zoom_level BETWEEN 6 AND 8 AND geom && bbox )
         UNION ALL
 
         -- landcover_z9_z10
         SELECT geom,
                class,
                icgc_id
         FROM icgc_data.landcover_z9_z10
         WHERE (zoom_level BETWEEN 9 AND 10 AND geom && bbox )
         UNION ALL
 
         -- landcover_z11_z12
         SELECT geom,
                class,
                icgc_id
         FROM icgc_data.landcover_z11_z12
         WHERE (zoom_level BETWEEN 11 AND 12 AND geom && bbox )
         UNION ALL
 
         -- landcover_ini
         SELECT geom,
                class,
                icgc_id
         FROM icgc_data.landcover_ini
         WHERE (zoom_level BETWEEN 13 AND 14 AND geom && bbox )
         UNION ALL
 
         -- landcover_bt5m
         SELECT geom,
                class,
                icgc_id
         FROM icgc_data.landcover_bt5m
         WHERE (zoom_level > 14 AND geom && bbox )
     ) AS zoom_levels,
     (SELECT geometry AS muni_geom 
        FROM icgc_data.boundary_div_admin 
        WHERE name = 'Tremp' 
        AND class = 'municipi' 
        AND adminlevel IS NOT NULL
      ) AS muni;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;