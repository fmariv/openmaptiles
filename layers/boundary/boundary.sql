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
                admin_level   integer,
                maritime      integer,
                mtc25         text,
                escala        text,
                area          double precision
            )
AS
$$
SELECT
    icgc_id,
    geometry,
    name,
    class,
    rank,
    adminlevel,
    0 AS maritime,
    mtc25,
    escala,
    area
FROM
    (
        -- catalunya
        SELECT icgc_id,
               geometry,
               nomcat      AS name,
               'country'   AS class,
               0           AS rank,
               4           AS adminlevel,
               NULL::text  AS mtc25,
               '5m'        AS escala,
                areaca5000 AS area
        FROM divisions_administratives.catalunya_5000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcat     AS name,
               'country'  AS class,
               0          AS rank,
               4          AS adminlevel,
               NULL::text AS mtc25,
               '50m'       AS escala,
                areaca5000 AS area
        FROM divisions_administratives.catalunya_50000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcat     AS name,
               'country'  AS class,
               0          AS rank,
               4          AS adminlevel,
               NULL::text AS mtc25,
               '500m'       AS escala,
                areaca5000 AS area
        FROM divisions_administratives.catalunya_500000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcat     AS name,
               'country'  AS class,
               0          AS rank,
               4          AS adminlevel,
               NULL::text AS mtc25,
               '100m'       AS escala,
                areaca5000 AS area
        FROM divisions_administratives.catalunya_100000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcat     AS name,
               'country'  AS class,
               0          AS rank,
               4          AS adminlevel,
               NULL::text AS mtc25,
               '250m'       AS escala,
                areaca5000 AS area
        FROM divisions_administratives.catalunya_250000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcat     AS name,
               'country'  AS class,
               0          AS rank,
               4          AS adminlevel,
               NULL::text AS mtc25,
               '1M'       AS escala,
                areaca5000 AS area
        FROM divisions_administratives.catalunya_1000000
        UNION ALL

        -- vegueries
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel,
               NULL::text   AS mtc25,
               '5m'         AS escala,
                areav5000 AS area
        FROM divisions_administratives.vegueries_5000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel,
               NULL::text   AS mtc25,
               '50m'         AS escala,
                areav5000 AS area
        FROM divisions_administratives.vegueries_50000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel,
               NULL::text   AS mtc25,
               '500m'         AS escala,
                areav5000 AS area
        FROM divisions_administratives.vegueries_500000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel,
               NULL::text   AS mtc25,
               '100m'         AS escala,
                areav5000 AS area
        FROM divisions_administratives.vegueries_100000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel,
               NULL::text   AS mtc25,
               '250m'         AS escala,
                areav5000 AS area
        FROM divisions_administratives.vegueries_250000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomvegue     AS name,
               'vegueria'   AS class,
               0            AS rank,
               5            AS adminlevel,
               NULL::text   AS mtc25,
               '1M'         AS escala,
                areav5000 AS area
        FROM divisions_administratives.vegueries_1000000
        UNION ALL

        -- provincies
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel,
               NULL::text   AS mtc25,
               '5m'         AS escala,
                areap5000 AS area
        FROM divisions_administratives.provincies_5000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel,
               NULL::text   AS mtc25,
               '50m'         AS escala,
                areap5000 AS area
        FROM divisions_administratives.provincies_50000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel,
               NULL::text   AS mtc25,
               '500m'         AS escala,
                areap5000 AS area
        FROM divisions_administratives.provincies_500000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel,
               NULL::text   AS mtc25,
               '100m'         AS escala,
                areap5000 AS area
        FROM divisions_administratives.provincies_100000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel,
               NULL::text   AS mtc25,
               '250m'         AS escala,
                areap5000 AS area
        FROM divisions_administratives.provincies_250000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomprov      AS name,
               'provincia'  AS class,
               0            AS rank,
               6            AS adminlevel,
               NULL::text   AS mtc25,
               '1M'         AS escala,
                areap5000 AS area
        FROM divisions_administratives.provincies_1000000
        UNION ALL

        -- comarques
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '5m'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_5000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '5m'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_5000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '50m'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_50000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '500m'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_500000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '100m'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_100000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '250m'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_250000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nomcomar     AS name,
               'comarca'    AS class,
               0            AS rank,
               7            AS adminlevel,
               NULL::text   AS mtc25,
               '1M'         AS escala,
                areac5000 AS area
        FROM divisions_administratives.comarques_1000000
        UNION ALL
        SELECT icgc_id,
               geometry,
               NULL::text    AS name,
               'comarca'    AS class,
               0            AS rank,
               admin_level  AS adminlevel,
               'SI'         AS mtc25,
               NULL::text   AS escala,
               NULL::numeric   AS area
        FROM divisions_administratives.limits_banda
        UNION ALL

        -- municipis
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel,
               NULL::text   AS mtc25,
               '5m'         AS escala,
                aream5000 AS area
        FROM divisions_administratives.municipis_5000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel,
               NULL::text   AS mtc25,
               '50m'         AS escala,
                aream5000 AS area
        FROM divisions_administratives.municipis_50000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel,
               NULL::text   AS mtc25,
               '500m'         AS escala,
                aream5000 AS area
        FROM divisions_administratives.municipis_500000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel,
               NULL::text   AS mtc25,
               '100m'         AS escala,
                aream5000 AS area
        FROM divisions_administratives.municipis_100000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel,
               NULL::text   AS mtc25,
               '250m'         AS escala,
                aream5000 AS area
        FROM divisions_administratives.municipis_250000
        UNION ALL
        SELECT icgc_id,
               geometry,
               nommuni      AS name,
               'municipi'   AS class,
               0            AS rank,
               8            AS adminlevel,
               NULL::text   AS mtc25,
               '1M'         AS escala,
                aream5000 AS area
        FROM divisions_administratives.municipis_1000000
        UNION ALL
        SELECT icgc_id,
               geometry,
               NULL::text   AS name,
               'municipi'   AS class,
               0            AS rank,
               admin_level  AS adminlevel,
               'SI'         AS mtc25,
               NULL::text   AS escala,
               NULL::numeric AS area
        FROM work.limits_administratius
    ) AS boundary
WHERE geometry && bbox
    AND zoom_level >= 6;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;


