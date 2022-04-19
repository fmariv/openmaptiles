-- etldoc: layer_waterway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="layer_waterway | <z3> z3 |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ];
DROP FUNCTION IF EXISTS layer_waterway(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_waterway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (   
            	icgc_id      bigint,
              geometry     geometry,
              class        text,
              name         text,
              "name:latin" text,
              entorn       text,
              jsel         text,
              "rank"       integer,
              contextmaps  text
            )
AS
$$
SELECT icgc_id,
       geom,
       class,
       NULLIF(name, '') AS name,
       name AS "name:latin",
       entorn,
       jsel,
       "rank",
       contextmaps
FROM (
         -- icgc waterway_z_7_8_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.waterway_z_7_8_carto
         WHERE (zoom_level BETWEEN 7 AND 8) AND geom && bbox
         UNION ALL

         -- waterway_z_9_10_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.waterway_z_9_10_carto 
         WHERE (zoom_level = 9) AND geom && bbox
         UNION ALL

         -- waterway_z_10_11_carto
         SELECT icgc_id,
                geom,
                class,
                name,
                'GE' AS entorn,
                NULL::text AS jsel,
                NULL::int AS "rank",
                NULL::text AS contextmaps
         FROM icgc_data.waterway_z_10_11_carto 
         WHERE (zoom_level BETWEEN 10 AND 11) AND geom && bbox
         UNION ALL

         -- waterway5m
         SELECT icgc_id,
                geometry,
                class,
                name,
                NULL::text AS entorn,
                jsel,
                "rank",
                contextmaps
         FROM icgc_data.waterway5m
         WHERE zoom_level >= 12
     ) AS zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
