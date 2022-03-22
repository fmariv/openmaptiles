-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1> z1 |<z2> z2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
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
 -- icgc boundary
 SELECT icgc_id,
        geom,
        admin_level,
        NULL::text AS adm0_l,
        NULL::text AS adm9_r,
        disputed,
        NULL::text AS disputed_name,
        NULL::text AS claimed_by,
        maritime,
        minzoom,
        maxzoom
 FROM icgc_data.boundary
 WHERE (zoom_level BETWEEN minzoom AND maxzoom) AND geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;

