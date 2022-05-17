DROP MATERIALIZED VIEW IF EXISTS osm_island_point_planet;
CREATE MATERIALIZED VIEW osm_island_point_planet AS
(
SELECT osm_id * 10 AS osm_id,
       oip.geometry,
       name,
       'island' AS class,
       7 AS "rank"
FROM osm_island_point oip, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_island_point_planet_idx ON osm_island_point_planet USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_island_polygon_planet;
CREATE MATERIALIZED VIEW osm_island_polygon_planet AS
(
SELECT  osm_id * 10 AS osm_id,
        oip.geometry,
        name,
        'island' AS class,
        island_rank(area) AS "rank"
FROM osm_island_polygon oip, icgc_data.catalunya c
WHERE ST_Disjoint(c.geometry, oip.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_island_polygon_planet_idx ON osm_island_polygon_planet USING gist (geometry);