-- etldoc:     layer_water [shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water |<z0> z0|<z1>z1|<z2>z2|<z3>z3 |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12+" ] ;
DROP FUNCTION IF EXISTS layer_water(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_water(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                icgc_id         integer,
                geometry        geometry,
                localtype       text,
                localid         text,
                codi            text,
                origin          text,
                persistent      text,
                name            text,
                nom_conca       text
            )
AS
$$
SELECT icgc_id,
       geometry,
       localtype,
       localid,
       codi,
       origin,
       persistent,
       name,
       nom_conca
FROM (
         -- wetland
        SELECT
            icgc_id,
            geometry,
            localtype,
            localid,
            NULL::text AS codi,
            NULL::text AS origin,
            NULL::text AS persistent,
            NULL::text AS name,
            NULL::text AS nom_conca
        FROM contextmaps.wetland
        UNION ALL

        -- standing_water
        SELECT
            icgc_id,
            geometry,
            localtype,
            localid,
            NULL::text AS codi,
            origin,
            persisten,
            name,
            NULL::text AS nom_conca
        FROM contextmaps.standing_water
        UNION ALL

        -- conques_litoral
        SELECT
            icgc_id,
            geometry,
            NULL::text AS localtype,
            NULL::text AS localid,
            codi,
            NULL::text AS origin,
            NULL::text AS persistent,
            NULL::text AS name,
            nom_conca
        FROM contextmaps.conques50m_litoral
        UNION ALL

        -- conques
        SELECT
            icgc_id,
            geometry,
            NULL::text AS localtype,
            NULL::text AS localid,
            codi,
            NULL::text AS origin,
            NULL::text AS persistent,
            NULL::text AS name,
            nom_conca
        FROM contextmaps.conques50m
    ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
