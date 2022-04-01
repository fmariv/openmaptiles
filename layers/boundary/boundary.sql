-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1> z1 |<z2> z2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
CREATE OR REPLACE FUNCTION layer_boundary(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id       int,
                geometry      geometry,
                name          text,
                admin_level   bigint,
                adm0_l        text,
                adm0_r        text,
                disputed      int,
                disputed_name text,
                claimed_by    text,
                maritime      int
            )
AS
$$
SELECT icgc_id,
       geometry,
       name,
       adm_level,
       adm0_l,
       adm0_r,
       disputed,
       disp_name,
       claimed_by,
       maritime
FROM icgc_data.boundary_mon_0_l
WHERE adm_level = 2 
    AND (maritime IS NULL or maritime = 0)
    AND (disputed = 0 OR disputed IS NULL)
    AND geometry && bbox
UNION ALL 

SELECT icgc_id,
       geometry,
       name,
       adm_level,
       adm0_l,
       adm0_r,
       disputed,
       disp_name,
       NULL::text AS claimed_by,
       maritime
FROM icgc_data.boundary_mon_1_l
WHERE adm_level IN (2, 3, 4, 5, 6, 7)
   AND maritime = 1
   AND geometry && bbox
UNION ALL 

SELECT icgc_id,
       geometry,
       name,
       adm_level,
       adm0_l,
       adm0_r,
       disputed,
       disp_name,
       NULL::text AS claimed_by,
       maritime
FROM icgc_data.boundary_mon_1_l
WHERE adm_level IN ( 3, 4, 5, 6, 7, 8)
    AND maritime = 0
    AND geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
