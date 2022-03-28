-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1> z1 |<z2> z2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
CREATE OR REPLACE FUNCTION layer_boundary(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id       integer,
                geometry      geometry,
                name          text,
                class         text,
                rank          bigint,
                admin_level   bigint
            )
AS
$$
SELECT id AS icgc_id,
       geometry,
       'Comunitat Autònom de Catalunya' AS name,
       'Comunitat Autònom' AS class,
       NULL::int AS rank,
       2 AS adminlevel
FROM icgc_data.catalunya
WHERE geometry && bbox
   AND zoom_level >= 6
UNION ALL 

SELECT icgc_id,
       geometry,
       name,
       class,
       rank,
       adminlevel
FROM icgc_data.boundary_div_admin
WHERE class = 'comarca' 
   AND adminlevel IS NOT NULL
   AND geometry && bbox
   AND zoom_level >= 8
UNION ALL 

SELECT icgc_id,
       geometry,
       name,
       class,
       rank,
       adminlevel
FROM icgc_data.boundary_div_admin
WHERE class = 'municipi' 
   AND adminlevel IS NOT NULL
   AND geometry && bbox
   AND zoom_level >= 10;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;


