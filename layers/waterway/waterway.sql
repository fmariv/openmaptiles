-- etldoc: layer_waterway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc: label="layer_waterway | <z3> z3 |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ];
DROP FUNCTION IF EXISTS layer_waterway(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_waterway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (   
              icgc_id      integer,
              geometry     geometry,
              localtype    text,
              localid      text,
              name         text,
              origin       text,
              namespace    text,
              cas          text,
              ordre        integer,
              grau         integer,
              codi         text,
              codi_short   text
            )
AS
$$
SELECT icgc_id,
       geometry,
       localtype,
       localid,
       name,
       origin,
       namespace,
       cas,
       ordre,
       grau,
       codi,
       codi_short
FROM (
         -- xarxa_50
        SELECT
            icgc_id,
            geometry,
            NULL::text AS localtype,
            NULL::text AS localid,
            NULL::text AS name,
            NULL::text AS origin,
            NULL::text AS namespace,
            cas,
            ordre,
            grau,
            codi,
            codi_short
        FROM icgc_data.xarxa_50m
        UNION ALL

        -- water_course
        SELECT
            icgc_id,
            geometry,
            NULL::text AS localtype,
            localid,
            NULL::text AS name,
            origin,
            namespace,
            NULL::text AS cas,
            NULL::int AS ordre,
            NULL::int AS grau,
            NULL::text AS codi,
            NULL::text AS codi_short
        FROM icgc_data.water_course
        UNION ALL

        -- land water boundary
        SELECT
            icgc_id,
            geometry,
            localtype,
            localid,
            NULL::text AS name,
            NULL::text AS origin,
            NULL::text AS namespace,
            NULL::text AS cas,
            NULL::int AS ordre,
            null::int AS grau,
            NULL::text AS codi,
            NULL::text AS codi_short
        FROM icgc_data.land_water_boundary
        UNION ALL

        -- shoreline_construction
        SELECT
            icgc_id,
            geometry,
            localtype,
            localid,
            NULL::text AS name,
            NULL::text AS origin,
            NULL::text AS namespace,
            NULL::text AS cas,
            NULL::int AS ordre,
            NULL::int AS grau,
            NULL::text AS codi,
            NULL::text AS codi_short
        FROM icgc_data.shoreline_construction
        UNION ALL

        -- darm_or_weir
        SELECT
            icgc_id,
            geometry,
            NULL::text AS localtype,
            localid,
            name,
            NULL::text AS origin,
            NULL::text AS namespace,
            NULL::text AS cas,
            NULL::int AS ordre,
            NULL::int AS grau,
            NULL::text AS codi,
            NULL::text AS codi_short
        FROM icgc_data.dam_or_weir
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
