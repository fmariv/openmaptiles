-- etldoc: layer_transportation_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_transportation_name | <z6> z6 | <z7> z7 | <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_transportation_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id    bigint,
                geometry   geometry,
                name       text,
                ref        text,
                ref_length int,
                network    text,
                id_via     text,
                class      text,
                subclass   text,
                layer      int,
                level      int,
                indoor     int,
                zoom       int,
                mtc25m     text,
                colorcaixa bigint,
                rank       int,
                codigeo    int,
                z_order    int
            )
AS
$$
SELECT
      icgc_id,
      geom,  
      name,      
      ref,       
      ref_length,
      network,   
      id_via,    
      class,     
      subclass,  
      layer,     
      level,     
      indoor,    
      zoom,      
      mtc25m,    
      colorcaixa,
      rank,      
      codigeo,
      NULL::int AS z_order   
FROM (
      SELECT * FROM 
      (
        SELECT
            t.icgc_id::bigint,
            t.geom,
            t.name::text,
            t.name::text AS ref,
            6::int AS ref_length,
            ''::text AS network,
            ''::text AS id_via,
            t.class::text,
            ''::text AS subclass,
            0::INT AS layer,
            0::INT AS level,
            0::INT AS indoor,
            0::smallint AS zoom,
            ''::text AS mtc25m,
            0::bigint AS colorcaixa,
            0::smallint AS rank,
            0::integer AS codigeo
            FROM icgc_data.transportation_name_lines t
            WHERE zoom_level < 15 AND t.geom && bbox
        UNION ALL
        SELECT
            t.icgc_id::bigint,
            ST_GeometryN(t.geom, 1) AS geom,
            t.name::text,
            ''::text AS ref,
            0::int AS ref_length,
            ''::text AS network,
            ''::text AS id_via,
            t.class::text,
            ''::text AS subclass,
            0::INT AS layer,
            0::INT AS level,
            0::INT AS indoor,
            t.zoom::smallint,
            ''::text AS mtc25m,
            0::bigint AS colorcaixa,
            t.rank::smallint,
            t.codigeo::integer
            FROM icgc_data.transportation_name t
            WHERE zoom_level < 15 AND zoom_level >= t.zoom AND t.geom && bbox
        UNION ALL
        SELECT
            t.icgc_id::bigint,
            t.geom,
            t.name::text,
            ''::text AS ref,
            0::int AS ref_length,
            ''::text AS network,
            ''::text AS id_via,
            t.class::text,
            ''::text AS subclass,
            0::INT AS layer,
            0::INT AS level,
            0::INT AS indoor,
            t.zoom::smallint,
            t.mtc25m::text,
            t.colorcaixa::bigint,
            t.rank::smallint,
            0::integer AS codigeo
            FROM icgc_data.transportation_name_line3_3857 t
            WHERE zoom_level < 15 AND zoom_level >= t.zoom AND t.geom && bbox
        UNION ALL
        SELECT
            t.icgc_id::bigint,
            t.geom,
            t.name::text,
            t.name::text AS ref,
            t.ref_length::INT,
            ''::text AS network,
            t.id_via::text,
            t.class::text,
            ''::text AS subclass,
            0::int AS layer,
            0::int AS level,
            0::int AS indoor,
            13::smallint AS zoom,
            ''::text AS mtc25m,
            0::bigint AS colorcaixa,
            0::smallint AS rank,
            0::integer AS codigeo
            FROM icgc_data.z_13_18_transportation_contextmaps_name t
            WHERE zoom_level >= 13 AND t.geom && bbox
      ) AS data_unordered
      ORDER BY zoom, rank
) AS icgc_data
UNION ALL

SELECT NULL::bigint AS icgc_id,
       planet_data.geometry,
       tags->'name' AS name,
       ref,
       NULLIF(LENGTH(ref), 0) AS ref_length,
       CASE
           WHEN network IS NOT NULL
               THEN network::text
           WHEN length(coalesce(ref, '')) > 0
               THEN 'road'
           END AS network,
       NULL::text AS id_via,
       highway_class(highway, '', subclass) AS class,
       CASE
           WHEN highway IS NOT NULL AND highway_class(highway, '', subclass) = 'path'
               THEN highway
           ELSE subclass
           END AS subclass,
       NULLIF(layer, 0) AS layer,
       "level",
       CASE WHEN indoor = TRUE THEN 1 END AS indoor,
       NULL::int AS zoom,
       NULL::text AS mtc25m,
       NULL::bigint AS colorcaixa,
       NULL::int AS rank,
       NULL::int AS codigeo,
       z_order
FROM (

         -- etldoc: osm_transportation_name_linestring_gen4 ->  layer_transportation_name:z6
         SELECT *,
                NULL::int AS layer,
                NULL::int AS level,
                NULL::boolean AS indoor
         FROM osm_transportation_name_linestring_gen4
         WHERE zoom_level = 6
         UNION ALL

         -- etldoc: osm_transportation_name_linestring_gen3 ->  layer_transportation_name:z7
         SELECT *,
                NULL::int AS layer,
                NULL::int AS level,
                NULL::boolean AS indoor
         FROM osm_transportation_name_linestring_gen3
         WHERE zoom_level = 7
         UNION ALL

         -- etldoc: osm_transportation_name_linestring_gen2 ->  layer_transportation_name:z8
         SELECT *,
                NULL::int AS layer,
                NULL::int AS level,
                NULL::boolean AS indoor
         FROM osm_transportation_name_linestring_gen2
         WHERE zoom_level = 8
         UNION ALL

         -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z9
         -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z10
         -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z11
         SELECT *,
                NULL::int AS layer,
                NULL::int AS level,
                NULL::boolean AS indoor
         FROM osm_transportation_name_linestring_gen1
         WHERE zoom_level BETWEEN 9 AND 11
         UNION ALL

         -- etldoc: osm_transportation_name_linestring ->  layer_transportation_name:z12
         SELECT geometry,
                "tags",
                ref,
                highway,
                subclass,
                brunnel,
                network,
                route_1, route_2, route_3, route_4, route_5, route_6,
                z_order,
                layer,
                "level",
                indoor
         FROM osm_transportation_name_linestring
         WHERE zoom_level = 12
           AND LineLabel(zoom_level, COALESCE(tags->'name', ref), geometry)
           AND NOT highway_is_link(highway)
           AND
               CASE WHEN highway_class(highway, NULL::text, NULL::text) NOT IN ('path', 'minor') THEN TRUE
                    WHEN highway IN ('aerialway', 'unclassified', 'residential', 'shipway') THEN TRUE
                    WHEN route_rank = 1 THEN TRUE END

         UNION ALL

         -- etldoc: osm_transportation_name_linestring ->  layer_transportation_name:z13
         SELECT geometry,
                "tags",
                ref,
                highway,
                subclass,
                brunnel,
                network,
                route_1, route_2, route_3, route_4, route_5, route_6,
                z_order,
                layer,
                "level",
                indoor
         FROM osm_transportation_name_linestring
         WHERE zoom_level = 13
           AND LineLabel(zoom_level, COALESCE(tags->'name', ref), geometry)
           AND
               CASE WHEN highway <> 'path' THEN TRUE
                    WHEN highway = 'path' AND (
                                                   tags->'name' <> ''
                                                OR network IS NOT NULL
                                                OR sac_scale <> ''
                                                OR route_rank <= 2
                                              ) THEN TRUE
               END

         UNION ALL

         -- etldoc: osm_transportation_name_linestring ->  layer_transportation_name:z14_
         SELECT geometry,
                "tags",
                ref,
                highway,
                subclass,
                brunnel,
                network,
                route_1, route_2, route_3, route_4, route_5, route_6,
                z_order,
                layer,
                "level",
                indoor
         FROM osm_transportation_name_linestring
         WHERE zoom_level >= 14
         UNION ALL

         -- etldoc: osm_highway_point ->  layer_transportation_name:z10
         SELECT
		p.geometry,
                p.tags,
                p.ref,
                (
                  SELECT highest_highway(l.tags->'highway')
                    FROM osm_highway_linestring l
                    WHERE ST_Intersects(p.geometry,l.geometry)
                ) AS class,
                'junction'::text AS subclass,
                NULL AS brunnel,
                NULL AS network,
                NULL::text AS route_1,
                NULL::text AS route_2,
                NULL::text AS route_3,
                NULL::text AS route_4,
                NULL::text AS route_5,
                NULL::text AS route_6,
                z_order,
                layer,
                NULL::int AS level,
                NULL::boolean AS indoor
         FROM osm_highway_point p
         WHERE highway = 'motorway_junction' AND zoom_level >= 10
     ) AS planet_data, icgc_data.catalunya c
WHERE planet_data.geometry && bbox
    AND ST_Disjoint(c.geometry, planet_data.geometry)
ORDER BY z_order ASC;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;