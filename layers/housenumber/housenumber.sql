-- etldoc: layer_housenumber[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_housenumber | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_housenumber(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                osm_id      bigint,
                icgc_id     bigint,
                geometry    geometry,
                housenumber text
            )
AS
$$
SELECT
    -- etldoc: osm_housenumber_point -> layer_housenumber:z14_
    ohp.osm_id,
    NULL::int AS icgc_id,
    ohp.geometry,
    ohp.housenumber
FROM osm_housenumber_point ohp, icgc_data.catalunya c
WHERE zoom_level >= 14
  AND ohp.geometry && bbox
  AND ST_Disjoint(c.geometry, ohp.geometry)

UNION ALL 

-- icgc housenumber
SELECT 
     NULL::int AS osm_id,
     icgc_id,
     geom, 
     housenumber
FROM icgc_data.housenumber
WHERE geom && bbox AND zoom_level >= 14 
  ;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
