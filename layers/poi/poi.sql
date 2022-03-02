-- etldoc: layer_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_poi | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                class          text,
                subclass       text,
                categoria      text,
                layer          text,
                "rank"         int,
                zoom           integer,
                classicgc      text,
                icgc_id_match  bigint
            )
AS
$$
SELECT 
       -- icgc POI 
       NULL::int as osm_id,
       icgc_id,
       geom,
       name,
       class,
       subclass,
       categoria,
       layer,
       rank,
       zoom,
       classicgc,
       icgc_id_match
FROM poi
WHERE geom && bbox
    AND zoom_level >= zoom
    AND zoom > 0

UNION ALL

SELECT planet_poi.*
FROM (
    -- Planet POI
    SELECT  osm_id_hash AS osm_id,
            NULL::int AS icgc_id,
            poi_union.geometry,
            NULLIF(name, '') AS name,
            poi_class(subclass, mapping_key) AS class,
            CASE
                WHEN subclass = 'information'
                    THEN NULLIF(information, '')
                WHEN subclass = 'place_of_worship'
                    THEN NULLIF(religion, '')
                WHEN subclass = 'pitch'
                    THEN NULLIF(sport, '')
                ELSE subclass
                END AS subclass,
            NULL::text AS categoria,
            NULL::text AS layer,
            row_number() OVER (
                PARTITION BY LabelGrid(poi_union.geometry, 100 * pixel_width)
                ORDER BY CASE WHEN name = '' THEN 2000 ELSE poi_class_rank(poi_class(subclass, mapping_key)) END ASC
                )::int AS "rank",
            NULL::int AS zoom,
            NULL::text AS classicgc,
            NULL::int AS icgc_id_match
    FROM (
            -- etldoc: osm_poi_point ->  layer_poi:z12
            -- etldoc: osm_poi_point ->  layer_poi:z13
            SELECT opp.*,
                    osm_id * 10 AS osm_id_hash
            FROM osm_poi_point opp, admin.cat c
            WHERE ST_Disjoint(c.geometry, opp.geometry)
            AND opp.geometry && bbox
            AND zoom_level BETWEEN 12 AND 13
            AND ((subclass = 'station' AND mapping_key = 'railway')
                OR subclass IN ('halt', 'ferry_terminal'))

            UNION ALL

            -- etldoc: osm_poi_point ->  layer_poi:z14_
            SELECT opp.*,
                    osm_id * 10 AS osm_id_hash
            FROM osm_poi_point opp, admin.cat c
            WHERE ST_Disjoint(c.geometry, opp.geometry)
            AND opp.geometry && bbox
            AND zoom_level >= 14

            UNION ALL

            -- etldoc: osm_poi_polygon ->  layer_poi:z12
            -- etldoc: osm_poi_polygon ->  layer_poi:z13
            SELECT opp.*,
                    NULL::integer AS agg_stop,
                    CASE
                        WHEN osm_id < 0 THEN -osm_id * 10 + 4
                        ELSE osm_id * 10 + 1
                        END AS osm_id_hash
            FROM osm_poi_polygon opp, admin.cat c
            WHERE ST_Disjoint(c.geometry, opp.geometry)
            AND opp.geometry && bbox
            AND zoom_level BETWEEN 12 AND 13
            AND ((subclass = 'station' AND mapping_key = 'railway')
                OR subclass IN ('halt', 'ferry_terminal'))

            UNION ALL

            -- etldoc: osm_poi_polygon ->  layer_poi:z14_
            SELECT  opp.*,
                    NULL::integer AS agg_stop,
                    CASE
                        WHEN osm_id < 0 THEN -osm_id * 10 + 4
                        ELSE osm_id * 10 + 1
                        END AS osm_id_hash
            FROM osm_poi_polygon opp, admin.cat c
            WHERE ST_Disjoint(c.geometry, opp.geometry)
            AND opp.geometry && bbox
            AND zoom_level >= 14
        ) AS poi_union
    ORDER BY "rank"
    ) AS planet_poi;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
