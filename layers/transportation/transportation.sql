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
                icgc_id    bigint,
                geometry   geometry,
                class      text,
                subclass   text,
                ramp       integer,
                oneway     integer,
                brunnel    text,
                service    text,
                layer      integer,
                level      integer,
                indoor     integer,
                d_categori text,
                codi_via   text,
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
       brunnel,
       service,
       layer,
       level,
       indoor,
       d_categori,
       codi_via,
       observacio
FROM (
        -- z_8mtc_vials
        SELECT
            NULL::bigint AS osm_id,
            icgc_id,
            geom,
            class,
            NULL::text AS subclass,
            NULL::int as ramp,
            NULL::int as oneway,
            brunnel,
            NULL::text AS service,
            NULL::int AS layer,
            NULL::int AS level,
            NULL::int AS indoor,
            layer as d_categori,
            codi_via,
            NULL::text AS observacio
        FROM icgc_data.z_6_8_mtc_vials 
        WHERE zoom_level BETWEEN 6 AND 8
        UNION ALL

        -- z_11_13_transportation_contextmaps
        SELECT
            NULL::bigint AS osm_id,
            icgc_id,
            geom,
            class,
            subclass,
            ramp,
            oneway,
            brunnel,
            service,
            layer,
            level,
            indoor,
            d_categori,
            codi_via,
            observacio
        FROM icgc_data.z_9_12_transportation_contextmaps
        WHERE zoom_level BETWEEN 9 AND 12
        UNION ALL

        -- z_13_18_transportation_contextmaps
        SELECT
            NULL::bigint AS osm_id,
            icgc_id,
            geom,
            class,
            subclass,
            ramp,
            oneway,
            brunnel,
            service,
            layer,
            level,
            indoor,
            d_categori,
            codi_via,
            observacio
        FROM icgc_data.z_13_18_transportation_contextmaps 
        WHERE zoom_level >= 13
) AS icgc_zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
