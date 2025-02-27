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
        --z_7mtc_vials
        SELECT
            NULL::int AS osm_id,
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
        FROM icgc_data.z_7mtc_vials t
        WHERE zoom_level BETWEEN 6 AND 7
        UNION ALL

        -- z_8mtc_vials
        SELECT
            NULL::int AS osm_id,
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
        FROM icgc_data.z_8mtc_vials 
        WHERE zoom_level = 8
        UNION ALL

        -- z_11_13_transportation_contextmaps
        SELECT
            NULL::int AS osm_id,
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
        FROM icgc_data.z_11_13_transportation_contextmaps
        WHERE zoom_level BETWEEN 9 AND 12
        UNION ALL

        -- z_13_18_transportation_contextmaps
        SELECT
            NULL::int AS osm_id,
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
WHERE geom && bbox
UNION ALL

SELECT planet_transportation.*
FROM
    (SELECT osm_id,
        NULL::int AS icgc_id,
        geometry,
        CASE
            WHEN highway <> '' OR public_transport <> ''
                THEN highway_class(highway, public_transport, construction)
            WHEN railway <> '' THEN railway_class(railway)
            WHEN aerialway <> '' THEN 'aerialway'
            WHEN shipway <> '' THEN shipway
            WHEN man_made <> '' THEN man_made
            END AS class,
        CASE
            WHEN railway IS NOT NULL THEN railway
            WHEN (highway IS NOT NULL OR public_transport IS NOT NULL)
                AND highway_class(highway, public_transport, construction) = 'path'
                THEN COALESCE(NULLIF(public_transport, ''), highway)
            WHEN aerialway IS NOT NULL THEN aerialway
            END AS subclass,
        -- All links are considered as ramps as well
        CASE
            WHEN highway_is_link(highway)
                OR is_ramp
                THEN 1 END AS ramp,
        CASE WHEN is_oneway <> 0 THEN is_oneway::int END AS oneway,
        brunnel(is_bridge, is_tunnel, is_ford) AS brunnel,
        NULLIF(service, '') AS service,
        NULLIF(layer, 0) layer,
        "level",
        CASE WHEN indoor = TRUE THEN 1 END AS indoor,
        NULL::text AS d_categori,
        NULL::TEXT AS codi_via,
        NULL::text AS observacio
    FROM (
            -- transportation_gen_planet_z6 -> layer_transportation:z6
            SELECT osm_id,
                    geometry,
                    highway,
                    construction,
                    network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    NULL AS service,
                    NULL AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM transportation_gen_planet_z6
            WHERE zoom_level = 6 
            UNION ALL 
            
            -- transportation_gen_planet_z7 -> layer_transportation:z7
            SELECT osm_id,
                    geometry,
                    highway,
                    construction,
                    network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    NULL AS service,
                    NULL AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM transportation_gen_planet_z7
            WHERE zoom_level = 7
            UNION ALL 

            -- transportation_gen_planet_z8 -> layer_transportation:z8
            SELECT osm_id,
                    geometry,
                    highway,
                    construction,
                    network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    NULL AS service,
                    NULL AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM transportation_gen_planet_z8
            WHERE zoom_level = 8
            UNION ALL 
            
            -- transportation_gen_planet_z9 -> layer_transportation:z9
            SELECT osm_id,
                    geometry,
                    highway,
                    construction,
                    network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    NULL AS service,
                    NULL AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM transportation_gen_planet_z9
            WHERE zoom_level = 9
            UNION ALL 

            -- transportation_gen_planet_z10 -> layer_transportation:z10
            SELECT osm_id,
                    geometry,
                    highway,
                    construction,
                    network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    NULL AS service,
                    NULL AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM transportation_gen_planet_z10
            WHERE zoom_level = 10
            UNION ALL 
            
            -- transportation_gen_planet_z11 -> layer_transportation:z11
            SELECT osm_id,
                    geometry,
                    highway,
                    construction,
                    network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    NULL AS service,
                    NULL AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM transportation_gen_planet_z11
            WHERE zoom_level = 11
            UNION ALL

            -- etldoc: osm_railway_linestring_gen_z8  ->  layer_transportation:z8
            SELECT  osm_id,
                    orl.geometry,
                    NULL AS highway,
                    NULL AS construction,
                    NULL AS network,
                    railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    service_value(service) AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    NULL::boolean AS is_bridge,
                    NULL::boolean AS is_tunnel,
                    NULL::boolean AS is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    NULL::int AS layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_railway_linestring_gen_z8 orl, icgc_data.catalunya c
            WHERE zoom_level = 8
            AND railway = 'rail'
            AND service = ''
            AND usage = 'main'
            AND ST_Disjoint(c.geometry, orl.geometry)
            UNION ALL

            -- etldoc: osm_railway_linestring_gen_z9  ->  layer_transportation:z9
            SELECT osm_id,
                    orl.geometry,
                    NULL AS highway,
                    NULL AS construction,
                    NULL AS network,
                    railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    service_value(service) AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    NULL::boolean AS is_bridge,
                    NULL::boolean AS is_tunnel,
                    NULL::boolean AS is_ford,
                    NULL::boolean AS expressway,
                    NULL::boolean AS is_ramp,
                    NULL::int AS is_oneway,
                    NULL AS man_made,
                    layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_railway_linestring_gen_z9 orl, icgc_data.catalunya c
            WHERE zoom_level = 9
            AND railway = 'rail'
            AND service = ''
            AND usage = 'main'
            AND ST_Disjoint(c.geometry, orl.geometry)
            UNION ALL

            -- etldoc: osm_railway_linestring_gen_z10  ->  layer_transportation:z10
            SELECT osm_id,
                    orl.geometry,
                    NULL AS highway,
                    NULL AS construction,
                    NULL AS network,
                    railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    service_value(service) AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    is_ramp,
                    is_oneway,
                    NULL AS man_made,
                    layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_railway_linestring_gen_z10 orl, icgc_data.catalunya c
            WHERE zoom_level = 10
            AND railway IN ('rail', 'narrow_gauge')
            AND service = ''
            AND ST_Disjoint(c.geometry, orl.geometry)
            UNION ALL

            -- etldoc: osm_railway_linestring_gen_z11  ->  layer_transportation:z11
            SELECT osm_id,
                    orl.geometry,
                    NULL AS highway,
                    NULL AS construction,
                    NULL AS network,
                    railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    service_value(service) AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    is_ramp,
                    is_oneway,
                    NULL AS man_made,
                    layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_railway_linestring_gen_z11 orl, icgc_data.catalunya c
            WHERE zoom_level = 11
            AND railway IN ('rail', 'narrow_gauge', 'light_rail')
            AND service = ''
            AND ST_Disjoint(c.geometry, orl.geometry)
            UNION ALL

            -- etldoc: osm_railway_linestring_gen_z12  ->  layer_transportation:z12
            SELECT osm_id,
                    orl.geometry,
                    NULL AS highway,
                    NULL AS construction,
                    NULL AS network,
                    railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    service_value(service) AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    is_ramp,
                    is_oneway,
                    NULL AS man_made,
                    layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_railway_linestring_gen_z12 orl, icgc_data.catalunya c
            WHERE zoom_level = 12
            AND railway IN ('rail', 'narrow_gauge', 'light_rail')
            AND service = ''
            AND ST_Disjoint(c.geometry, orl.geometry)
            UNION ALL

            -- etldoc: osm_railway_linestring ->  layer_transportation:z13
            -- etldoc: osm_railway_linestring ->  layer_transportation:z14_
            SELECT osm_id,
                    orl.geometry,
                    NULL AS highway,
                    NULL AS construction,
                    NULL AS network,
                    railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    NULL AS public_transport,
                    service_value(service) AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    is_bridge,
                    is_tunnel,
                    is_ford,
                    NULL::boolean AS expressway,
                    is_ramp,
                    is_oneway,
                    NULL AS man_made,
                    layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_railway_linestring orl, icgc_data.catalunya c
            WHERE zoom_level BETWEEN 13 AND 14
            AND railway IN ('rail', 'narrow_gauge', 'light_rail')
            AND service = ''
            AND ST_Disjoint(c.geometry, orl.geometry)
            UNION ALL

            -- NOTE: We limit the selection of polys because we need to be
            -- careful to net get false positives here because
            -- it is possible that closed linestrings appear both as
            -- highway linestrings and as polygon
            -- etldoc: osm_highway_polygon ->  layer_transportation:z13
            -- etldoc: osm_highway_polygon ->  layer_transportation:z14_
            SELECT osm_id,
                    ohp.geometry,
                    highway,
                    NULL AS construction,
                    NULL AS network,
                    NULL AS railway,
                    NULL AS aerialway,
                    NULL AS shipway,
                    public_transport,
                    NULL AS service,
                    NULL::text AS access,
                    NULL::boolean AS toll,
                    CASE
                        WHEN man_made IN ('bridge') THEN TRUE
                        ELSE FALSE
                        END AS is_bridge,
                    FALSE AS is_tunnel,
                    FALSE AS is_ford,
                    NULL::boolean AS expressway,
                    FALSE AS is_ramp,
                    FALSE::int AS is_oneway,
                    man_made,
                    layer,
                    NULL::int AS level,
                    NULL::boolean AS indoor,
                    NULL AS bicycle,
                    NULL AS foot,
                    NULL AS horse,
                    NULL AS mtb_scale,
                    NULL AS surface,
                    z_order
            FROM osm_highway_polygon ohp, icgc_data.catalunya c
                -- We do not want underground pedestrian areas for now
            WHERE zoom_level BETWEEN 13 AND 14
            AND (
                    man_made IN ('bridge', 'pier')
                    OR (is_area AND COALESCE(layer, 0) >= 0)
                )
            AND ST_Disjoint(c.geometry, ohp.geometry)
     ) AS zoom_levels
WHERE geometry && bbox
ORDER BY z_order ASC) 
AS planet_transportation;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
