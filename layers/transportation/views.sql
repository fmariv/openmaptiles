
--- Transportation tables creation

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z6;
CREATE MATERIALIZED VIEW transportation_gen_planet_z6 AS
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
	FROM osm_transportation_merge_linestring_gen_z6 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z6_idx ON transportation_gen_planet_z6 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z7;
CREATE MATERIALIZED VIEW transportation_gen_planet_z7 AS
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
	FROM osm_transportation_merge_linestring_gen_z7 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z7_idx ON transportation_gen_planet_z7 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z8;
CREATE MATERIALIZED VIEW transportation_gen_planet_z8 AS
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
	FROM osm_transportation_merge_linestring_gen_z8 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z8_idx ON transportation_gen_planet_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z9;
CREATE MATERIALIZED VIEW transportation_gen_planet_z9 AS
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
	FROM osm_transportation_merge_linestring_gen_z9 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z9_idx ON transportation_gen_planet_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z10;
CREATE MATERIALIZED VIEW transportation_gen_planet_z10 AS
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
	FROM osm_transportation_merge_linestring_gen_z10 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z10_idx ON transportation_gen_planet_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z11;
CREATE MATERIALIZED VIEW transportation_gen_planet_z11 AS
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

DROP MATERIALIZED VIEW IF EXISTS transportation_railway_planet_z8;
CREATE MATERIALIZED VIEW transportation_railway_planet_z8 AS
(
	SELECT    
			ST_Difference(orl.geometry, c.geometry) AS geometry, 
			osm_id,
			railway,
			service_value(service) AS service,
			z_order
	FROM osm_railway_linestring_gen_z8 orl, icgc_data.catalunya c
	WHERE railway = 'rail'
        AND service = ''
        AND usage = 'main'
);
CREATE INDEX IF NOT EXISTS transportation_railway_planet_z8_idx ON transportation_railway_planet_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_railway_planet_z9;
CREATE MATERIALIZED VIEW transportation_railway_planet_z9 AS
(
	SELECT    
			ST_Difference(orl.geometry, c.geometry) AS geometry, 
			osm_id,
			railway,
			service_value(service) AS service,
			layer,
			z_order
	FROM osm_railway_linestring_gen_z9 orl, icgc_data.catalunya c
	WHERE railway = 'rail'
        AND service = ''
        AND usage = 'main'
);
CREATE INDEX IF NOT EXISTS transportation_railway_planet_z9_idx ON transportation_railway_planet_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_railway_planet_z10;
CREATE MATERIALIZED VIEW transportation_railway_planet_z10 AS
(
	SELECT    
			ST_Difference(orl.geometry, c.geometry) AS geometry, 
			osm_id,
			railway,
			service_value(service) AS service,
			is_bridge,
			is_tunnel,
			is_ford,
			is_ramp,
			is_oneway,
			layer,
			z_order
	FROM osm_railway_linestring_gen_z10 orl, icgc_data.catalunya c
	WHERE railway IN ('rail', 'narrow_gauge')
        AND service = ''
);
CREATE INDEX IF NOT EXISTS transportation_railway_planet_z10_idx ON transportation_railway_planet_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_railway_planet_z11;
CREATE MATERIALIZED VIEW transportation_railway_planet_z11 AS
(
	SELECT    
			ST_Difference(orl.geometry, c.geometry) AS geometry, 
			osm_id,
			railway,
			service_value(service) AS service,
			is_bridge,
			is_tunnel,
			is_ford,
			is_ramp,
			is_oneway,
			layer,
			z_order
	FROM osm_railway_linestring_gen_z11 orl, icgc_data.catalunya c
	WHERE railway IN ('rail', 'narrow_gauge', 'light_rail')
        AND service = ''
);
CREATE INDEX IF NOT EXISTS transportation_railway_planet_z11_idx ON transportation_railway_planet_z11 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_railway_planet_z12;
CREATE MATERIALIZED VIEW transportation_railway_planet_z12 AS
(
	SELECT    
			ST_Difference(orl.geometry, c.geometry) AS geometry, 
			osm_id,
			railway,
			service_value(service) AS service,
			is_bridge,
			is_tunnel,
			is_ford,
			is_ramp,
			is_oneway,
			layer,
			z_order
	FROM osm_railway_linestring_gen_z12 orl, icgc_data.catalunya c
	WHERE railway IN ('rail', 'narrow_gauge', 'light_rail')
        AND service = ''
);
CREATE INDEX IF NOT EXISTS transportation_railway_planet_z12_idx ON transportation_railway_planet_z12 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_railway_planet_z13_14;
CREATE MATERIALIZED VIEW transportation_railway_planet_z13_14 AS
(
	SELECT    
			ST_Difference(orl.geometry, c.geometry) AS geometry, 
			osm_id,
			railway,
			service_value(service) AS service,
			is_bridge,
			is_tunnel,
			is_ford,
			is_ramp,
			is_oneway,
			layer,
			z_order
	FROM osm_railway_linestring orl, icgc_data.catalunya c
	WHERE railway IN ('rail', 'narrow_gauge', 'light_rail')
        AND service = ''
);
CREATE INDEX IF NOT EXISTS transportation_railway_planet_z13_14_idx ON transportation_railway_planet_z13_14 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_highway_polygon_planet;
CREATE MATERIALIZED VIEW transportation_highway_polygon_planet AS
(
	SELECT    
			ST_Difference(ohp.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			public_transport,
			CASE
				WHEN man_made IN ('bridge') THEN TRUE
				ELSE FALSE
				END AS is_bridge,
			FALSE AS is_tunnel,
                    FALSE AS is_ford,
			FALSE AS is_ramp,
			FALSE::int AS is_oneway,
			man_made,
			layer,
			z_order
	FROM osm_highway_polygon ohp, icgc_data.catalunya c
	WHERE (
			man_made IN ('bridge', 'pier')
			OR (is_area AND COALESCE(layer, 0) >= 0)
		  )
);
CREATE INDEX IF NOT EXISTS transportation_highway_polygon_planet_idx ON transportation_highway_polygon_planet USING gist (geometry);

