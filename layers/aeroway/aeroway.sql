-- etldoc: layer_aeroway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_aeroway |<z10> z10|<z11> z11|<z12> z12|<z13> z13|<z14_> z14+" ];

CREATE OR REPLACE FUNCTION layer_aeroway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry geometry,
                class    text,
                ref      text
            )
AS
$$
SELECT geometry, aeroway AS class, ref
FROM (
         -- etldoc:  osm_aeroway_linestring_gen_z10 -> layer_aeroway:z10
         SELECT oel.geometry, oel.aeroway, oel.ref
         FROM osm_aeroway_linestring_gen_z10 oel, admin.cat c
         WHERE zoom_level = 10
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_linestring_gen_z11 -> layer_aeroway:z11
         SELECT oel.geometry, oel.aeroway, oel.ref
         FROM osm_aeroway_linestring_gen_z11 oel, admin.cat c
         WHERE zoom_level = 11
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_linestring_gen_z12 -> layer_aeroway:z12
         SELECT oel.geometry, oel.aeroway, oel.ref
         FROM osm_aeroway_linestring_gen_z12 oel, admin.cat c
         WHERE zoom_level = 12
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_linestring -> layer_aeroway:z13
         -- etldoc:  osm_aeroway_linestring -> layer_aeroway:z14_
         SELECT oel.geometry, oel.aeroway, oel.ref
         FROM osm_aeroway_linestring oel, admin.cat c
         WHERE zoom_level >= 13
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z10 -> layer_aeroway:z10
         SELECT oep.geometry, oep.aeroway, oep.ref
         FROM osm_aeroway_polygon_gen_z10 oep, admin.cat c
         WHERE zoom_level = 10
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z11 -> layer_aeroway:z11
         SELECT oep.geometry, oep.aeroway, oep.ref
         FROM osm_aeroway_polygon_gen_z11 oep, admin.cat c
         WHERE zoom_level = 11
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z12 -> layer_aeroway:z12
         SELECT oep.geometry, oep.aeroway, oep.ref
         FROM osm_aeroway_polygon_gen_z12 oep, admin.cat c
         WHERE zoom_level = 12
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z13 -> layer_aeroway:z13
         SELECT oep.geometry, oep.aeroway, oep.ref
         FROM osm_aeroway_polygon_gen_z13 oep, admin.cat c
         WHERE zoom_level = 13
             AND ST_Disjoint(c.geometry, oep.geometry)                       
         UNION ALL
         -- etldoc:  osm_aeroway_polygon -> layer_aeroway:z14_
         SELECT oep.geometry, oep.aeroway, oep.ref
         FROM osm_aeroway_polygon oep, admin.cat c
         WHERE zoom_level >= 14
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         
         -- etldoc:  osm_aeroway_point -> layer_aeroway:z14_
         SELECT oep.geometry, oep.aeroway, oep.ref
         FROM osm_aeroway_point oep, admin.cat c
         WHERE zoom_level >= 14
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL

         -- icgc aeroway
         SELECT geom, NULL::text AS aeroway, NULL::text AS ref
         FROM aeroway
         WHERE zoom_level >= 10 AND geom && bbox
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
