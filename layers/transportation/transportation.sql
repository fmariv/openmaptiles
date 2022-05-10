CREATE OR REPLACE FUNCTION highway_is_link(highway text) RETURNS boolean AS
$$
SELECT highway LIKE '%_link';
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;


-- etldoc: layer_transportation[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="<sql> layer_transportation |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_transportation(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_transportation(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id         int,
                geometry        geometry,
                class           text,
                subclass        text,
                ramp            integer,
                oneway          integer,
                network         text,
                brunnel         text,
                service         text,
                access          text,
                toll            integer,
                expressway      integer,
                layer           integer,
                level           integer,
                indoor          integer,
                d_categori      text,
                codi_via        text,
                surface         text,
                width           double precision,
                highspeed       text,
                conveying       text,
                gauge           int,
                observacio      text
            )
AS
$$
SELECT icgc_id,
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
       width,
       highspeed,
       conveying,
       gauge,
       observacio
FROM (
        -- z_6_8mtc_vials
        SELECT
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
            NULL::int AS width,
            NULL::text AS highspeed,
            NULL::text AS conveying,
            NULL::int AS gauge,
            NULL::text AS observacio
        FROM contextmaps.z_6_8_mtc_vials
        WHERE zoom_level BETWEEN 6 AND 8
        UNION ALL

        -- transportation_bdu - xarxa catalogada
        SELECT
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
            width,
            highspeed,
            conveying,
            gauge,
            observacio
        FROM icgc_test.transportation
        WHERE class IN ('motorway', 'primary', 'secondary', 'tertiary', 'minor', 'rail')
        	AND zoom_level BETWEEN 9 AND 12
        UNION ALL

        -- transportation_bdu
        SELECT
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
            width,
            highspeed,
            conveying,
            gauge,
            observacio
        FROM icgc_test.transportation
        WHERE zoom_level >= 13
        UNION ALL

        -- osca
        SELECT
            icgc_id,
            geometry,
            class,
            NULL::text AS subclass,
            NULL::int AS ramp,
            NULL::int AS oneway,
            NULL::text AS network,
            NULL::text AS brunnel,
            NULL::text AS service,
            NULL::text AS access,
            NULL::int AS toll,
            NULL::int AS expressway,
            NULL::int AS layer,
            NULL::int AS level,
            NULL::int AS indoor,
            d_categori,
            codi_via,
            NULL::text AS surface,
            NULL::int AS width,
            NULL::text AS highspeed,
            NULL::text AS conveying,
            NULL::int AS gauge,
            observacio
        FROM contextmaps.osca
        WHERE zoom_level >= 6
        UNION ALL

        -- voreres
        SELECT
            icgc_id,
            geometry,
            class,
            NULL::text AS subclass,
            NULL::int as ramp,
            NULL::int as oneway,
            NULL::text AS network,
            NULL::text AS brunnel,
            NULL::text AS service,
            NULL::text AS access,
            NULL::int AS toll,
            NULL::int AS expressway,
            NULL::int AS layer,
            NULL::int AS level,
            NULL::int AS indoor,
            NULL::text AS d_categori,
            NULL::text AS codi_via,
            NULL::text AS surface,
            NULL::int AS width,
            NULL::text AS highspeed,
            NULL::text AS conveying,
            NULL::int AS gauge,
            NULL::text AS observacio
        FROM contextmaps.voreres
        WHERE zoom_level >= 12
) AS icgc_zoom_levels
WHERE geom && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
