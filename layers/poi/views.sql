DROP MATERIALIZED VIEW IF EXISTS osm_poi_point_planet;
CREATE MATERIALIZED VIEW osm_poi_point_planet AS
(
SELECT opp.*,
       osm_id * 10 AS osm_id_hash
FROM osm_poi_point opp, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, opp.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_poi_point_planet_idx ON osm_poi_point_planet USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_poi_polygon_planet;
CREATE MATERIALIZED VIEW osm_poi_polygon_planet AS
(
SELECT  opp.*,
        NULL::integer AS agg_stop,
        CASE
            WHEN osm_id < 0 THEN -osm_id * 10 + 4
            ELSE osm_id * 10 + 1
            END AS osm_id_hash
FROM osm_poi_polygon opp, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, opp.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_poi_polygon_planet_idx ON osm_poi_polygon_planet USING gist (geometry);