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
                mtc25m     text,
                colorcaixa bigint,
                rank       smallint,
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
      mtc25m,    
      colorcaixa,
      rank,      
      codigeo,
      NULL::int AS z_order   
FROM (
      SELECT * FROM 
      (
        SELECT
            icgc_id::bigint,
            geom,
            name::text,
            name::text AS ref,
            6::int AS ref_length,
            ''::text AS network,
            ''::text AS id_via,
            class::text,
            ''::text AS subclass,
            0::INT AS layer,
            0::INT AS level,
            0::INT AS indoor,
            0::smallint AS zoom,
            ''::text AS mtc25m,
            0::bigint AS colorcaixa,
            0::smallint AS rank,
            0::integer AS codigeo
            FROM icgc_data.transportation_name_lines
            WHERE zoom_level BETWEEN 6 AND 14
               AND geom && bbox
        UNION ALL

        SELECT
            icgc_id::bigint,
            ST_GeometryN(geom, 1) AS geom,
            name::text,
            ''::text AS ref,
            0::int AS ref_length,
            ''::text AS network,
            ''::text AS id_via,
            class::text,
            ''::text AS subclass,
            0::INT AS layer,
            0::INT AS level,
            0::INT AS indoor,
            zoom::smallint,
            ''::text AS mtc25m,
            0::bigint AS colorcaixa,
            rank::smallint,
            codigeo::integer
            FROM icgc_data.transportation_name 
            WHERE zoom_level BETWEEN zoom AND 14 
               AND geom && bbox
        UNION ALL

        SELECT
            icgc_id::bigint,
            geom,
            name::text,
            name::text AS ref,
            ref_length::INT,
            ''::text AS network,
            id_via::text,
            class::text,
            ''::text AS subclass,
            0::int AS layer,
            0::int AS level,
            0::int AS indoor,
            13::smallint AS zoom,
            ''::text AS mtc25m,
            0::bigint AS colorcaixa,
            0::smallint AS rank,
            0::integer AS codigeo
            FROM icgc_data.z_13_18_transportation_contextmaps_name 
            WHERE zoom_level >= 13 
                AND geom && bbox
      ) AS data_unordered
      ORDER BY zoom, rank
) AS icgc_data;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;