-- etldoc: layer_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_poi | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id         bigint,
                icgc_id        bigint,
                geometry       geometry,
                name           text,
                name_en        text,
                name_de        text,
                tags           hstore,
                class          text,
                subclass       text,
                agg_stop       integer,
                layer          integer,
                level          integer,
                indoor         integer,
                "rank"         int,
                zoom           integer,
                layer_type     text,
                classicgc      text,
                icgc_id_match  bigint
            )
AS
$$
SELECT osm_id_hash AS osm_id,
       icgc_id,
       geometry,
       NULLIF(name, '') AS name,
       COALESCE(NULLIF(name_en, ''), name) AS name_en,
       COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
       tags,
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
       agg_stop,
       NULLIF(layer, 0) AS layer,
       "level",
       CASE WHEN indoor = TRUE THEN 1 END AS indoor,
       row_number() OVER (
           PARTITION BY LabelGrid(geometry, 100 * pixel_width)
           ORDER BY CASE WHEN name = '' THEN 2000 ELSE poi_class_rank(poi_class(subclass, mapping_key)) END ASC
           )::int AS "rank",
       zoom,
       layer_type,
       classicgc,
       icgc_id_match
FROM (
         -- etldoc: osm_poi_point ->  layer_poi:z12
         -- etldoc: osm_poi_point ->  layer_poi:z13
         SELECT *,
                osm_id * 10 AS osm_id_hash,
                NULL::int AS icgc_id,
                NULL::int AS zoom,
                NULL::text AS layer_type,
                NULL::text AS classicgc,
                NULL::int AS icgc_id_match
         FROM osm_poi_point
         WHERE geometry && bbox
           AND zoom_level BETWEEN 12 AND 13
           AND ((subclass = 'station' AND mapping_key = 'railway')
             OR subclass IN ('halt', 'ferry_terminal'))

         UNION ALL

         -- etldoc: osm_poi_point ->  layer_poi:z14_
         SELECT *,
                osm_id * 10 AS osm_id_hash,
                NULL::int AS icgc_id,
                NULL::int AS zoom,
                NULL::text AS layer_type,
                NULL::text AS classicgc,
                NULL::int AS icgc_id_match
         FROM osm_poi_point
         WHERE geometry && bbox
           AND zoom_level >= 14

         UNION ALL

         -- etldoc: osm_poi_polygon ->  layer_poi:z12
         -- etldoc: osm_poi_polygon ->  layer_poi:z13
         SELECT *,
                NULL::integer AS agg_stop,
                CASE
                    WHEN osm_id < 0 THEN -osm_id * 10 + 4
                    ELSE osm_id * 10 + 1
                    END AS osm_id_hash,
                NULL::int AS icgc_id,
                NULL::int AS zoom,
                NULL::text AS layer_type,
                NULL::text AS classicgc,
                NULL::int AS icgc_id_match
         FROM osm_poi_polygon
         WHERE geometry && bbox
           AND zoom_level BETWEEN 12 AND 13
           AND ((subclass = 'station' AND mapping_key = 'railway')
             OR subclass IN ('halt', 'ferry_terminal'))

         UNION ALL

         -- etldoc: osm_poi_polygon ->  layer_poi:z14_
         SELECT *,
                NULL::integer AS agg_stop,
                CASE
                    WHEN osm_id < 0 THEN -osm_id * 10 + 4
                    ELSE osm_id * 10 + 1
                    END AS osm_id_hash,
                NULL::int AS icgc_id,
                NULL::int AS zoom,
                NULL::text AS layer_type,
                NULL::text AS classicgc,
                NULL::int AS icgc_id_match
         FROM osm_poi_polygon
         WHERE geometry && bbox
           AND zoom_level >= 14
         union all 
         
         -- icgc POI
         SELECT 
         		null::int as id,
                null::int as osm_id,
                name,
                NULL::text AS name_en,
                NULL::text AS name_de,
                NULL::hstore AS tags,
                subclass,
                null::text as mapping_key,
                null::text as station,
                null::text as funicular,
                null::text as information,
                null::text as uic_ref,
                null::text as religion,
                null::int as level,
                null::boolean as indoor,
                null::int as layer,
                null::text as sport,
                geom,
                null::int as agg_stop,
                null::int as osm_id_hash,
                icgc_id,
                zoom,
                layer AS layer_type,
                classicgc,
                icgc_id_match
         FROM poi
         WHERE geom && bbox
           AND zoom_level >= zoom
           AND zoom > 0
     ) AS poi_union
ORDER BY "rank"
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
