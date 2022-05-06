-- etldoc: layer_transportation_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_transportation_name | <z6> z6 | <z7> z7 | <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_transportation_name(bbox geometry, zoom_level integer);
CREATE OR REPLACE FUNCTION layer_transportation_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id       bigint,
                geometry      geometry,
                name          text,
                "name:latin"  text,
                ref           text,
                ref_length    bigint,
                network       text,
                codi_via      text,
                class         text,
                subclass      text,
                brunnel       text,
                layer         int,
                level         int,
                indoor        int
            )
AS
$$
SELECT
      icgc_id,
      geom,  
      name,
      "name:latin",      
      ref,       
      ref_length,
      network,   
      codi_via,    
      class,     
      subclass,  
      brunnel,
      layer,     
      level,     
      indoor 
FROM (
        -- z_6_8_mtc_vials
        SELECT
            icgc_id::bigint,
            geom,
            codi_via AS name,
            codi_via AS "name:latin",
            codi_via AS ref,
            LENGTH(codi_via) AS ref_length,
            ''::text AS network,
            codi_via,
            class,
            NULL::text AS subclass,
            brunnel,
            NULL::INT AS layer,
            NULL::INT AS level,
            NULL::INT AS indoor
        FROM icgc_data.z_6_8_mtc_vials
        WHERE zoom_level BETWEEN 6 AND 8
            AND codi_via <> ''
        UNION ALL

        -- transportation_name_line3_3857
        SELECT
            icgc_id,
            geometry,
            name,
            name AS "name:latin",
            ref,
            ref_length,
            ''::text AS network,
            name AS codi_via,
            class,
            NULL::text AS subclass,
            NULL::text AS brunnel,
            NULL::INT AS layer,
            NULL::INT AS level,
            NULL::INT AS indoor
        FROM icgc_data.transportation_name_line3_3857
        WHERE zoom_level >= 10
        UNION ALL

        -- transportation_name_bdu - xarxa catalogada
        SELECT
            icgc_id,
            geometry,
            name,
            name AS "name:latin",
            ref,
            ref_length,
            network,
            id_via as codi_via,
            class,
            subclass,
            brunnel,
            layer,
            level,
            indoor
        FROM icgc_test.transportation_name
        WHERE zoom_level BETWEEN 9 AND 12
            AND class in ('motorway', 'primary', 'secondary', 'tertiary')
            AND name <> ''
        UNION ALL

        -- transportation_name_bdu
        SELECT
            icgc_id,
            geometry,
            name,
            name AS "name:latin",
            ref,
            ref_length,
            network,
            id_via as codi_via,
            class,
            subclass,
            brunnel,
            layer,
            level,
            indoor
        FROM icgc_test.transportation_name
        WHERE zoom_level >= 13
            AND name <> ''
) as zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;