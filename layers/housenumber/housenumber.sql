-- etldoc: layer_housenumber[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_housenumber | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_housenumber(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                osm_id      bigint,
                geometry    geometry,
                housenumber text
            )
AS
$$
SELECT
    -- etldoc: osm_housenumber_point -> layer_housenumber:z14_
    ohp.osm_id,
    ohp.geometry,
    ohp.housenumber
FROM osm_housenumber_point ohp, admin.cat c
WHERE zoom_level >= 14
  AND ohp.geometry && bbox
  AND ST_Disjoint(c.geometry, ohp.geometry)

UNION ALL 

-- icgc housenumber
SELECT 
     icgc_id,
     geom, 
     housenumber
FROM housenumber
WHERE geom && bbox AND zoom_level >= 14 
  ;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
