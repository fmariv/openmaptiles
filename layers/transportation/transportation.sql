CREATE OR REPLACE FUNCTION highway_is_link(highway text) RETURNS boolean AS
$$
SELECT highway LIKE '%_link';
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;


-- etldoc: layer_transportation[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="<sql> layer_transportation |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
CREATE OR REPLACE FUNCTION layer_transportation(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                osm_id     bigint,
                icgc_id    int,
                geometry   geometry,
                class      text,
                subclass   text,
                ramp       integer,
                oneway     integer,
                network    text,
                brunnel    text,
                service    text,
                access     text,
                toll       integer,
                expressway integer,
                layer      integer,
                level      integer,
                indoor     integer,
                d_categori text,
                codi_via   text,
                surface    text,
                observacio text
            )
AS
$$
SELECT osm_id,
       icgc_id,
       geom,
       class,
       subclass,
       ramp,
       oneway,
       network,
       brunnel,
       service,
       access,
       toll,
       expressway,
       layer,
       level,
       indoor,
       d_categori,
       codi_via,
       surface,
       observacio
FROM (
        -- z_6_8mtc_vials
        SELECT
            NULL::bigint AS osm_id,
            icgc_id,
            geom,
            class,
            NULL::text AS subclass,
            NULL::int as ramp,
            NULL::int as oneway,
            NULL::text AS network,
            brunnel,
            NULL::text AS service,
            NULL::text AS access,
            NULL::int AS toll,
            NULL::int AS expressway,
            NULL::int AS layer,
            NULL::int AS level,
            NULL::int AS indoor,
            layer as d_categori,
            codi_via,
            NULL::text AS surface,
            NULL::text AS observacio
        FROM icgc_data.z_6_8_mtc_vials 
        WHERE zoom_level BETWEEN 6 AND 8
        UNION ALL

        -- transportation_bdu - xarxa catalogada
        SELECT
            NULL::bigint AS osm_id,
            icgc_id,
            geometry,
            class,
            subclass,
            ramp,
            oneway,
            network,
            brunnel,
            service,
            NULL::text AS access,
            NULL::int AS toll,
            NULL::int AS expressway,
            layer,
            level,
            indoor,
            d_categori,
            codi_via,
            surface,
            observacio
        FROM icgc_test.transportation_bdu
        WHERE class IN ('motorway', 'primary', 'tertiary', 'secondary', 'minor')
        	AND zoom_level BETWEEN 9 AND 12
        UNION ALL

        -- transportation_bdu
        SELECT
            NULL::bigint AS osm_id,
            icgc_id,
            geometry,
            class,
            subclass,
            ramp,
            oneway,
            network,
            brunnel,
            service,
            NULL::text AS access,
            NULL::int AS toll,
            NULL::int AS expressway,
            layer,
            level,
            indoor,
            d_categori,
            codi_via,
            surface,
            observacio
        FROM icgc_test.transportation_bdu 
        WHERE class IN ('motorway', 'primary', 'secondary', 'tertiary', 'minor', 'busway', 'service', 
                        'pedestrian', 'track', 'path', 'rail', 'gondola', 'chair_lift', 'cable_car', 
                        'magic_carpet', 'tram', 'funicular')
            AND zoom_level >= 13
) AS icgc_zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
