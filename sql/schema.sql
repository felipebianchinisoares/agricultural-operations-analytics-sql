PRAGMA foreign_keys = ON;

CREATE TABLE farms (farm_id INTEGER PRIMARY KEY, farm_name TEXT NOT NULL UNIQUE, region TEXT NOT NULL);
CREATE TABLE fields (field_id INTEGER PRIMARY KEY, farm_id INTEGER NOT NULL REFERENCES farms(farm_id), field_name TEXT NOT NULL, area_ha REAL NOT NULL CHECK(area_ha > 0), soil_type TEXT NOT NULL, UNIQUE(farm_id, field_name));
CREATE TABLE machines (machine_id INTEGER PRIMARY KEY, machine_code TEXT NOT NULL UNIQUE, machine_type TEXT NOT NULL, model_year INTEGER NOT NULL CHECK(model_year BETWEEN 2000 AND 2030), engine_hours REAL NOT NULL CHECK(engine_hours >= 0));
CREATE TABLE seasons (season_id INTEGER PRIMARY KEY, season_label TEXT NOT NULL UNIQUE, start_date TEXT NOT NULL, end_date TEXT NOT NULL CHECK(end_date > start_date));
CREATE TABLE crops (crop_id INTEGER PRIMARY KEY, crop_name TEXT NOT NULL UNIQUE);
CREATE TABLE field_seasons (field_season_id INTEGER PRIMARY KEY, field_id INTEGER NOT NULL REFERENCES fields(field_id), season_id INTEGER NOT NULL REFERENCES seasons(season_id), crop_id INTEGER NOT NULL REFERENCES crops(crop_id), yield_t_ha REAL CHECK(yield_t_ha >= 0), UNIQUE(field_id, season_id));
CREATE TABLE operations (operation_id INTEGER PRIMARY KEY, field_season_id INTEGER NOT NULL REFERENCES field_seasons(field_season_id), machine_id INTEGER REFERENCES machines(machine_id), operation_type TEXT NOT NULL, operation_date TEXT NOT NULL, planned_cost_brl REAL NOT NULL CHECK(planned_cost_brl >= 0), actual_cost_brl REAL NOT NULL CHECK(actual_cost_brl >= 0), duration_hours REAL NOT NULL CHECK(duration_hours > 0));
CREATE TABLE maintenance_events (event_id INTEGER PRIMARY KEY, machine_id INTEGER NOT NULL REFERENCES machines(machine_id), event_date TEXT NOT NULL, event_type TEXT NOT NULL, downtime_hours REAL NOT NULL CHECK(downtime_hours >= 0), maintenance_cost_brl REAL NOT NULL CHECK(maintenance_cost_brl >= 0));

CREATE INDEX idx_operations_field_season ON operations(field_season_id);
CREATE INDEX idx_operations_machine ON operations(machine_id);
CREATE INDEX idx_maintenance_machine_date ON maintenance_events(machine_id, event_date);
