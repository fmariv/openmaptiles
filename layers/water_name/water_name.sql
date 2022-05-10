-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_water_name(bbox geometry, zoom_level integer);
CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
    RETURNS TABLE
            (
                icgc_id      int,
                geometry     geometry,
                localtype    text,
                localid      text,
                name         text
            )
AS
$$
SELECT
     -- hydro_poi
     icgc_id,
     geometry,
     localtype,
     localid,
     name
FROM icgc_data.hydro_poi
WHERE geometry && bbox
UNION ALL

SELECT
     -- falls
     icgc_id,
     geometry,
     NULL::text AS localtype,
     localid,
    name
FROM icgc_data.falls
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
