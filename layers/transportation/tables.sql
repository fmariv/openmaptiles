
/*
--- Transportation views creation
 The total creation time expected is about 2:30h

The features of the origin tables are multilinestring, which are impossible to filter by the Catalonia extend. In order to
be able to perform a spatial filter, we had to convert those multilinestrings into single linestrings.
*/

-- DROP TABLE IF EXISTS transportation_gen_planet_z6;
CREATE TABLE transportation_gen_planet_z6 AS
(SELECT otml.*
FROM (
		SELECT    
			(ST_Dump(otml.geometry)).geom AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z6 otml
) AS otml, admin.cat c
WHERE ST_Disjoint(c.geometry, otml.geometry)
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z6_idx ON transportation_gen_planet_z6 USING gist (geometry);

-- DROP TABLE IF EXISTS transportation_gen_planet_z7;
CREATE TABLE transportation_gen_planet_z7 AS
(SELECT otml.*
FROM (
		SELECT    
			(ST_Dump(otml.geometry)).geom AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z7 otml
) AS otml, admin.cat c
WHERE ST_Disjoint(c.geometry, otml.geometry)
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z7_idx ON transportation_gen_planet_z7 USING gist (geometry);

-- DROP TABLE IF EXISTS transportation_gen_planet_z8;
CREATE TABLE transportation_gen_planet_z8 AS
(SELECT otml.*
FROM (
		SELECT    
			(ST_Dump(otml.geometry)).geom AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z8 otml
) AS otml, admin.cat c
WHERE ST_Disjoint(c.geometry, otml.geometry)
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z8_idx ON transportation_gen_planet_z8 USING gist (geometry);

-- DROP TABLE IF EXISTS transportation_gen_planet_z9;
CREATE TABLE transportation_gen_planet_z9 AS
(SELECT otml.*
FROM (
		SELECT    
			(ST_Dump(otml.geometry)).geom AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z9 otml
) AS otml, admin.cat c
WHERE ST_Disjoint(c.geometry, otml.geometry)
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z9_idx ON transportation_gen_planet_z9 USING gist (geometry);

-- DROP TABLE IF EXISTS transportation_gen_planet_z10;
CREATE TABLE transportation_gen_planet_z10 AS
(SELECT otml.*
FROM (
		SELECT    
			(ST_Dump(otml.geometry)).geom AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z10 otml
) AS otml, admin.cat c
WHERE ST_Disjoint(c.geometry, otml.geometry)
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z10_idx ON transportation_gen_planet_z10 USING gist (geometry);

-- DROP TABLE IF EXISTS transportation_gen_planet_z11;
CREATE TABLE transportation_gen_planet_z11 AS
(SELECT otml.*
FROM (
		SELECT    
			(ST_Dump(otml.geometry)).geom AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z11 otml
) AS otml, admin.cat c
WHERE ST_Disjoint(c.geometry, otml.geometry)
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z11_idx ON transportation_gen_planet_z11 USING gist (geometry);
