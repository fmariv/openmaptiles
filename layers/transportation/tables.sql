
--- Transportation tables creation

DROP TABLE IF EXISTS transportation_gen_planet_z6;
CREATE TABLE transportation_gen_planet_z6 AS
(
	SELECT    
		ST_Difference(otml.geometry, c.geometry) AS geometry, 
		osm_id,
		highway,
		network,
		construction,
		is_bridge,
		is_tunnel,
		is_ford,
		z_order
	FROM osm_transportation_merge_linestring_gen_z6 otml, icgc_data.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z6_idx ON transportation_gen_planet_z6 USING gist (geometry);

DROP TABLE IF EXISTS transportation_gen_planet_z7;
CREATE TABLE transportation_gen_planet_z7 AS
(
	SELECT    
		ST_Difference(otml.geometry, c.geometry) AS geometry, 
		osm_id,
		highway,
		network,
		construction,
		is_bridge,
		is_tunnel,
		is_ford,
		z_order
	FROM osm_transportation_merge_linestring_gen_z7 otml, icgc_data.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z7_idx ON transportation_gen_planet_z7 USING gist (geometry);

DROP TABLE IF EXISTS transportation_gen_planet_z8;
CREATE TABLE transportation_gen_planet_z8 AS
(
	SELECT    
		ST_Difference(otml.geometry, c.geometry) AS geometry, 
		osm_id,
		highway,
		network,
		construction,
		is_bridge,
		is_tunnel,
		is_ford,
		z_order
	FROM osm_transportation_merge_linestring_gen_z8 otml, icgc_data.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z8_idx ON transportation_gen_planet_z8 USING gist (geometry);

DROP TABLE IF EXISTS transportation_gen_planet_z9;
CREATE TABLE transportation_gen_planet_z9 AS
(
	SELECT    
			ST_Difference(otml.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z9 otml, icgc_data.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z9_idx ON transportation_gen_planet_z9 USING gist (geometry);

DROP TABLE IF EXISTS transportation_gen_planet_z10;
CREATE TABLE transportation_gen_planet_z10 AS
(
	SELECT    
			ST_Difference(otml.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z10 otml, icgc_data.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z10_idx ON transportation_gen_planet_z10 USING gist (geometry);

DROP TABLE IF EXISTS transportation_gen_planet_z11;
CREATE TABLE transportation_gen_planet_z11 AS
(
	SELECT    
			ST_Difference(otml.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z11 otml, icgc_data.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z11_idx ON transportation_gen_planet_z11 USING gist (geometry);
