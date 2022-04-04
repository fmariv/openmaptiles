--TODO: Find a way to nicely generalize landcover
--CREATE TABLE IF NOT EXISTS landcover_grouped_gen2 AS (
--	SELECT osm_id, ST_Simplify((ST_Dump(geometry)).geom, 600) AS geometry, landuse, "natural", wetland
--	FROM (
--	  SELECT max(osm_id) AS osm_id, ST_Union(ST_Buffer(geometry, 600)) AS geometry, landuse, "natural", wetland
--	  FROM osm_landcover_polygon_gen1
--	  GROUP BY LabelGrid(geometry, 15000000), landuse, "natural", wetland
--	) AS grouped_measurements
--);
--CREATE INDEX IF NOT EXISTS landcover_grouped_gen2_geometry_idx ON landcover_grouped_gen2 USING gist(geometry);

CREATE OR REPLACE FUNCTION landcover_class(subclass varchar) RETURNS text AS
$$
SELECT CASE
           %%FIELD_MAPPING: class %%
           END;
$$ LANGUAGE SQL IMMUTABLE
                -- STRICT
                PARALLEL SAFE;

-- etldoc: layer_landcover[shape=record fillcolor=lightpink, style="rounded, filled", label="layer_landcover | <z0> z0 | <z1> z1 | <z2> z2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
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
SELECT geometry,
       landcover_class(subclass) AS class,
       subclass,
       NULLIF(icgc_id, 0) AS icgc_id
FROM (
         -- etldoc:  landcover_z0 -> layer_landcover:z0
         SELECT geometry, 
                subclass,
                0::int as icgc_id
         FROM landcover_z0
         WHERE zoom_level = 0
           AND geometry && bbox
         UNION ALL

         -- etldoc:  landcover_z1 -> layer_landcover:z1
         SELECT geometry,
                subclass,
                0::int as icgc_id
         FROM landcover_z1
         WHERE zoom_level = 1
           AND geometry && bbox
         UNION ALL

         -- etldoc:  landcover_z2 -> layer_landcover:z2
         SELECT geometry, 
                subclass,
                0::int as icgc_id
         FROM landcover_z2
         WHERE zoom_level = 2
           AND geometry && bbox
         UNION ALL

         -- etldoc:  landcover_z3 -> layer_landcover:z3
         SELECT geometry,
                subclass,
                0::int as icgc_id
         FROM landcover_z3
         WHERE zoom_level = 3
           AND geometry && bbox
         UNION ALL

         -- etldoc:  landcover_z4 -> layer_landcover:z4
         SELECT geometry,
                subclass,
                0::int as icgc_id
         FROM landcover_z4
         WHERE zoom_level = 4
           AND geometry && bbox
         UNION ALL

         -- etldoc:  landcover_z5 -> layer_landcover:z5
         SELECT geometry, 
                subclass,
                0::int as icgc_id
         FROM landcover_z5
         WHERE zoom_level = 5
           AND geometry && bbox
         UNION ALL

         -- etldoc:  landcover_z6 -> layer_landcover:z6
         SELECT geometry,
                subclass,
                0::int as icgc_id
         FROM landcover_z6
         WHERE zoom_level = 6
           AND geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z7 -> layer_landcover:z7
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z7 l, icgc_data.catalunya c
         WHERE zoom_level = 7
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z8 -> layer_landcover:z8
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z8 l, icgc_data.catalunya c
         WHERE zoom_level = 8
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z9 -> layer_landcover:z9
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z9 l, icgc_data.catalunya c
         WHERE zoom_level = 9
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z10 -> layer_landcover:z10
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z10 l, icgc_data.catalunya c
         WHERE zoom_level = 10
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z11 -> layer_landcover:z11
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z11 l, icgc_data.catalunya c
         WHERE zoom_level = 11
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z12 -> layer_landcover:z12
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z12 l, icgc_data.catalunya c
         WHERE zoom_level = 12
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_gen_z13 -> layer_landcover:z13
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_gen_z13 l, icgc_data.catalunya c
         WHERE zoom_level = 13
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

         -- etldoc:  osm_landcover_polygon -> layer_landcover:z14_
         SELECT l.geometry, 
                l.subclass,
                0::int as icgc_id
         FROM osm_landcover_polygon l, icgc_data.catalunya c
         WHERE zoom_level = 14
           AND ST_Disjoint(c.geometry, l.geometry)
           AND l.geometry && bbox
         UNION ALL

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
     ) AS zoom_levels;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;