-- etldoc: layer_transportation_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_transportation_name | <z6> z6 | <z7> z7 | <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_transportation_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id       bigint,
                geometry      geometry,
                name          text,
                "name:latin"  text,
                ref           text,
                ref_length    int,
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
            NULL::text AS name,
            NULL::text AS "name:latin",
            NULL::text AS ref,
            6::int AS ref_length,
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
        FROM icgc_test.transportation_name_bdu 
        WHERE zoom_level BETWEEN 9 AND 13
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
        FROM icgc_test.transportation_name_bdu 
        WHERE zoom_level >= 13 
            AND name <> ''
) as zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;