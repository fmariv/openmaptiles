-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1> z1 |<z2> z2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
DROP FUNCTION IF EXISTS layer_boundary(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_boundary(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id       bigint,
                geometry      geometry,
                admin_level   int,
                adm0_l        text,
                adm0_r        text,
                disputed      int,
                disputed_name text,
                claimed_by    text,
                maritime      int,
                minzoom       int,
                maxzoom       int
            )
AS
$$
SELECT icgc_id, geometry, admin_level, adm0_l, adm0_r, disputed::int, disputed_name, claimed_by, maritime::int, minzoom, maxzoom
FROM (
         -- etldoc: boundary_z0 ->  layer_boundary:z0
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z0
         WHERE geometry && bbox
           AND zoom_level = 0
         UNION ALL

         -- etldoc: boundary_z1 ->  layer_boundary:z1
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z1
         WHERE geometry && bbox
           AND zoom_level = 1
         UNION ALL

         -- etldoc: boundary_z2 ->  layer_boundary:z2
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z2
         WHERE geometry && bbox
           AND zoom_level = 2
         UNION ALL

         -- etldoc: boundary_z3 ->  layer_boundary:z3
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z3
         WHERE geometry && bbox
           AND zoom_level = 3
         UNION ALL

         -- etldoc: boundary_z4 ->  layer_boundary:z4
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z4
         WHERE geometry && bbox
           AND zoom_level = 4
         UNION ALL

         -- etldoc: boundary_z5 ->  layer_boundary:z5
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z5
         WHERE geometry && bbox
           AND zoom_level = 5
         UNION ALL

         -- etldoc: boundary_z6 ->  layer_boundary:z6
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z6
         WHERE geometry && bbox
           AND zoom_level = 6
         UNION ALL

         -- etldoc: boundary_z7 ->  layer_boundary:z7
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z7
         WHERE geometry && bbox
           AND zoom_level = 7
         UNION ALL

         -- etldoc: boundary_z8 ->  layer_boundary:z8
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z8
         WHERE geometry && bbox
           AND zoom_level = 8
         UNION ALL

         -- etldoc: boundary_z9 ->  layer_boundary:z9
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z9
         WHERE geometry && bbox
           AND zoom_level = 9
         UNION ALL

         -- etldoc: boundary_z10 ->  layer_boundary:z10
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z10
         WHERE geometry && bbox
           AND zoom_level = 10
         UNION ALL

         -- etldoc: boundary_z11 ->  layer_boundary:z11
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z11
         WHERE geometry && bbox
           AND zoom_level = 11
         UNION ALL

         -- etldoc: boundary_z12 ->  layer_boundary:z12
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z12
         WHERE geometry && bbox
           AND zoom_level = 12
         UNION ALL

         -- etldoc: boundary_z13 -> layer_boundary:z13
         SELECT *, NULL::int as icgc_id, NULL::int as minzoom, NULL::int as maxzoom
         FROM boundary_z13
         WHERE geometry && bbox
           AND zoom_level BETWEEN 13 AND 14
         UNION ALL

         -- icgc boundary
         SELECT 
                geom,
                admin_level,
                NULL::text AS adm0_l,
                NULL::text AS adm9_r,
                disputed::bool AS disputed,
                NULL::text AS disputed_name,
                NULL::text AS claimed_by,
                maritime::bool AS maritime,
                icgc_id,
                minzoom,
                maxzoom
         FROM icgc_data.boundary
         WHERE (zoom_level BETWEEN minzoom AND maxzoom) AND geom && bbox
     ) AS zoom_levels;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;

