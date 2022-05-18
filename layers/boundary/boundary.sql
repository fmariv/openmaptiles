-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1> z1 |<z2> z2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
DROP FUNCTION IF EXISTS layer_boundary(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_boundary(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id       integer,
                geometry      geometry,
                name          text,
                class         text,
                rank          integer,
                admin_level   integer
            )
AS
$$
SELECT
    icgc_id,
    geometry,
    name,
    class,
    rank,
    adminlevel
FROM
    (
        -- catalunya
        SELECT icgc_id,
               geometry,
               nomcat    AS name,
               'country' AS class,
               0         AS rank,
               4         AS adminlevel
        FROM divisions_administratives.catalunya_5000
        UNION ALL
        SELECT icgc_id,
               ST_Boundary(geometry) AS geometry,
               nomcat    AS name,
               'country' AS class,
               0         AS rank,
               4         AS adminlevel
        FROM divisions_administratives.catalunya_5000
        UNION ALL

        -- vegueries
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel
        FROM divisions_administratives.vegueries_5000
        UNION ALL
        SELECT icgc_id,
               ST_Boundary(geometry) AS geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel
        FROM divisions_administratives.vegueries_5000
        UNION ALL

        -- provincies
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel
        FROM divisions_administratives.provincies_5000
        UNION ALL
        SELECT icgc_id,
               ST_Boundary(geometry) AS geometry,
               nomprov AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel
        FROM divisions_administratives.provincies_5000
        UNION ALL

        -- comarques
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel
        FROM divisions_administratives.comarques_5000
        UNION ALL
        SELECT icgc_id,
               ST_Boundary(geometry) AS geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel
        FROM divisions_administratives.comarques_5000
        UNION ALL

        -- municipis
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel
        FROM divisions_administratives.municipis_5000
        UNION ALL
        SELECT icgc_id,
               ST_Boundary(geometry) AS geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel
        FROM divisions_administratives.municipis_5000
    ) AS boundary
WHERE geometry && bbox
    AND zoom_level >= 6;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;


