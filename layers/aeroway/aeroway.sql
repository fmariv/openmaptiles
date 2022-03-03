-- etldoc: layer_aeroway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_aeroway |<z10> z10|<z11> z11|<z12> z12|<z13> z13|<z14_> z14+" ];

CREATE OR REPLACE FUNCTION layer_aeroway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id  bigint,
                geometry geometry,
                class    text,
                ref      text,
                tipus    int
            )
AS
$$
SELECT icgc_id, geometry, aeroway AS class, ref, tipus
FROM (
         -- etldoc:  osm_aeroway_linestring_gen_z10 -> layer_aeroway:z10
         SELECT NULL::int AS icgc_id, oel.geometry, oel.aeroway, oel.ref, NULL::int as tipus
         FROM osm_aeroway_linestring_gen_z10 oel, icgc_data.catalunya c
         WHERE zoom_level = 10
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_linestring_gen_z11 -> layer_aeroway:z11
         SELECT NULL::int AS icgc_id, oel.geometry, oel.aeroway, oel.ref, NULL::int as tipus
         FROM osm_aeroway_linestring_gen_z11 oel, icgc_data.catalunya c
         WHERE zoom_level = 11
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_linestring_gen_z12 -> layer_aeroway:z12
         SELECT NULL::int AS icgc_id, oel.geometry, oel.aeroway, oel.ref, NULL::int as tipus
         FROM osm_aeroway_linestring_gen_z12 oel, icgc_data.catalunya c
         WHERE zoom_level = 12
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_linestring -> layer_aeroway:z13
         -- etldoc:  osm_aeroway_linestring -> layer_aeroway:z14_
         SELECT NULL::int AS icgc_id, oel.geometry, oel.aeroway, oel.ref, NULL::int as tipus
         FROM osm_aeroway_linestring oel, icgc_data.catalunya c
         WHERE zoom_level >= 13
            AND ST_Disjoint(c.geometry, oel.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z10 -> layer_aeroway:z10
         SELECT NULL::int AS icgc_id, oep.geometry, oep.aeroway, oep.ref, NULL::int as tipus
         FROM osm_aeroway_polygon_gen_z10 oep, icgc_data.catalunya c
         WHERE zoom_level = 10
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z11 -> layer_aeroway:z11
         SELECT NULL::int AS icgc_id, oep.geometry, oep.aeroway, oep.ref, NULL::int as tipus
         FROM osm_aeroway_polygon_gen_z11 oep, icgc_data.catalunya c
         WHERE zoom_level = 11
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z12 -> layer_aeroway:z12
         SELECT NULL::int AS icgc_id, oep.geometry, oep.aeroway, oep.ref, NULL::int as tipus
         FROM osm_aeroway_polygon_gen_z12 oep, icgc_data.catalunya c
         WHERE zoom_level = 12
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         -- etldoc:  osm_aeroway_polygon_gen_z13 -> layer_aeroway:z13
         SELECT NULL::int AS icgc_id, oep.geometry, oep.aeroway, oep.ref, NULL::int as tipus
         FROM osm_aeroway_polygon_gen_z13 oep, icgc_data.catalunya c
         WHERE zoom_level = 13
             AND ST_Disjoint(c.geometry, oep.geometry)                       
         UNION ALL
         -- etldoc:  osm_aeroway_polygon -> layer_aeroway:z14_
         SELECT NULL::int AS icgc_id, oep.geometry, oep.aeroway, oep.ref, NULL::int as tipus
         FROM osm_aeroway_polygon oep, icgc_data.catalunya c
         WHERE zoom_level >= 14
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL
         
         -- etldoc:  osm_aeroway_point -> layer_aeroway:z14_
         SELECT NULL::int AS icgc_id, oep.geometry, oep.aeroway, oep.ref, NULL::int as tipus
         FROM osm_aeroway_point oep, icgc_data.catalunya c
         WHERE zoom_level >= 14
            AND ST_Disjoint(c.geometry, oep.geometry)
         UNION ALL

         -- icgc aeroway
         SELECT icgc_id, geom, class AS aeroway, NULL::text AS ref, tipus
         FROM icgc_data.aeroway
         WHERE zoom_level >= 10 AND geom && bbox
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
