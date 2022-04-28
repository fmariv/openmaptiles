DROP FUNCTION IF EXISTS layer_landcover(bbox geometry, zoom_level int);
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
SELECT geom,
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
         UNION ALL

         -- landcover ACA
         SELECT geometry,
                class,
                icgc_id
         FROM icgc_data.landcover_aca
         WHERE (zoom_level > 12 AND geometry && bbox )
     ) AS zoom_levels;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;