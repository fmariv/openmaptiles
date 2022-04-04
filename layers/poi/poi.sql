-- etldoc: layer_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_poi | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_poi(bbox geometry, zoom_level integer, pixel_width numeric);
CREATE OR REPLACE FUNCTION layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                "name:latin"   text,
                class          text,
                subclass       text,
                categoria      text,
                layer          text,
                "rank"         int,
                classicgc      text,
                icgc_id_match  bigint
                icgc_zoom      int
            )
AS
$$
SELECT 
       -- icgc POI 
       NULL::bigint as osm_id,
       icgc_id,
       geom,
       name,
       name AS "name:latin",
       class,
       subclass,
       categoria,
       layer,
       rank,
       classicgc,
       icgc_id_match,
       zoom AS icgc_zoom
FROM icgc_data.poi
WHERE geom && bbox
    AND zoom_level >= zoom
    AND zoom <> 0

UNION ALL

SELECT *
FROM (
    -- Planet POI
    SELECT  osm_id_hash AS osm_id,
            NULL::bigint AS icgc_id,
            poi_union.geometry,
            NULLIF(name, '') AS name,
            name AS "name:latin",
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
            NULL::text AS classicgc,
            NULL::int AS icgc_id_match,
            NULL::int AS icgc_zoom
    FROM (
            -- etldoc: osm_poi_point ->  layer_poi:z12
            -- etldoc: osm_poi_point ->  layer_poi:z13
            SELECT *
            FROM osm_poi_point_planet
            WHERE geometry && bbox
            AND zoom_level BETWEEN 12 AND 13
            AND ((subclass = 'station' AND mapping_key = 'railway')
                OR subclass IN ('halt', 'ferry_terminal'))

            UNION ALL

            -- etldoc: osm_poi_point ->  layer_poi:z14_
            SELECT *
            FROM osm_poi_point_planet 
            WHERE geometry && bbox
            AND zoom_level = 14

            UNION ALL

            -- etldoc: osm_poi_polygon ->  layer_poi:z12
            -- etldoc: osm_poi_polygon ->  layer_poi:z13
            SELECT *
            FROM osm_poi_polygon_planet 
            WHERE geometry && bbox
            AND zoom_level BETWEEN 12 AND 13
            AND ((subclass = 'station' AND mapping_key = 'railway')
                OR subclass IN ('halt', 'ferry_terminal'))

            UNION ALL

            -- etldoc: osm_poi_polygon ->  layer_poi:z14_
            SELECT *
            FROM osm_poi_polygon_planet
            WHERE geometry && bbox
            AND zoom_level = 14
        ) AS poi_union
    ORDER BY "rank"
    ) AS planet_poi;
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
