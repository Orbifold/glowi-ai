-- ============================================
-- Glowi Matching Engine - PostgreSQL Schema
-- ============================================
-- This schema supports matching cleaners to clients based on:
-- - Geographic location and travel constraints
-- - Availability and scheduling
-- - Skills, preferences, and constraints
-- - Scoring parameters for optimal matching
-- ============================================

-- Enable PostGIS extension for geographic data types
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================
-- ENUMERATIONS (as lookup tables or check constraints)
-- ============================================

-- Transport modes for distance calculation
CREATE TYPE transport_mode AS ENUM (
    'car',
    'motorcycle',
    'moped',
    'ebike',
    'bicycle',
    'foot',
    'public_transport'
);

-- Office location types affecting distance scoring
CREATE TYPE office_type AS ENUM (
    'big_city',
    'standard',
    'countryside'
);

-- Entity types for polymorphic relationships
CREATE TYPE entity_type AS ENUM (
    'cleaner',
    'client'
);

-- Task types that cleaners can perform
CREATE TYPE task_type AS ENUM (
    'cleaning',
    'ironing',
    'window_cleaning',
    'deep_cleaning',
    'laundry'
);

-- Constraint types
CREATE TYPE constraint_type AS ENUM (
    'animal_allergy',
    'animal_fear',
    'asthma',
    'smoking_preference'
);

-- Animal types for allergies/fears
CREATE TYPE animal_type AS ENUM (
    'dog',
    'cat',
    'bird',
    'rabbit',
    'other'
);

-- Languages
CREATE TYPE language_code AS ENUM (
    'nl',
    'en',
    'fr',
    'de',
    'pl',
    'es',
    'other'
);

-- Days of the week
CREATE TYPE day_of_week AS ENUM (
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
);

-- ============================================
-- CORE ENTITIES
-- ============================================

-- Cleaners table
CREATE TABLE cleaners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    
    -- Employment details
    contractual_hours DECIMAL(5,2) NOT NULL CHECK (contractual_hours >= 0 AND contractual_hours <= 168),
    planned_hours DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (planned_hours >= 0 AND planned_hours <= 168),
    available_hours DECIMAL(5,2) GENERATED ALWAYS AS (contractual_hours - planned_hours) STORED,
    
    -- Transport and location
    transport_mode transport_mode NOT NULL,
    home_address_id UUID,
    
    -- Metadata
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Clients table
CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    
    -- Service requirements
    requested_hours_permanent DECIMAL(5,2) CHECK (requested_hours_permanent >= 0),
    planned_hours_permanent DECIMAL(5,2) DEFAULT 0 CHECK (planned_hours_permanent >= 0),
    
    -- Household details
    has_pets BOOLEAN NOT NULL DEFAULT false,
    smokes_inside BOOLEAN NOT NULL DEFAULT false,
    
    -- Location
    address_id UUID,
    office_type office_type NOT NULL DEFAULT 'standard',
    
    -- Metadata
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Addresses table (supports both cleaners and clients)
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    street VARCHAR(255) NOT NULL,
    house_number VARCHAR(20) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'NL',
    
    -- Geographic coordinates using PostGIS
    coordinates GEOGRAPHY(POINT, 4326) NOT NULL,
    
    -- Derived fields for quick access
    latitude DECIMAL(10,8) GENERATED ALWAYS AS (ST_Y(coordinates::geometry)) STORED,
    longitude DECIMAL(11,8) GENERATED ALWAYS AS (ST_X(coordinates::geometry)) STORED,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraints for addresses
ALTER TABLE cleaners ADD CONSTRAINT fk_cleaner_address 
    FOREIGN KEY (home_address_id) REFERENCES addresses(id) ON DELETE SET NULL;

ALTER TABLE clients ADD CONSTRAINT fk_client_address 
    FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE SET NULL;

-- ============================================
-- SCHEDULING & AVAILABILITY
-- ============================================

-- Schedules (both permanent and one-time bookings)
CREATE TABLE schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Polymorphic relationship (cleaner or client)
    entity_id UUID NOT NULL,
    entity_type entity_type NOT NULL,
    
    -- Schedule details
    day_of_week day_of_week,
    start_time TIME,
    end_time TIME,
    duration_hours DECIMAL(5,2) GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (end_time - start_time)) / 3600
    ) STORED,
    
    -- Type of schedule
    is_permanent BOOLEAN NOT NULL DEFAULT true,
    specific_date DATE, -- For one-time bookings
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CHECK (end_time > start_time),
    CHECK (is_permanent = true OR specific_date IS NOT NULL)
);

-- Absences (for one-time unavailability)
CREATE TABLE absences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cleaner_id UUID NOT NULL REFERENCES cleaners(id) ON DELETE CASCADE,
    
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CHECK (end_date >= start_date)
);

-- ============================================
-- SKILLS & TASKS
-- ============================================

-- Cleaner skills (tasks they can perform)
CREATE TABLE cleaner_skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cleaner_id UUID NOT NULL REFERENCES cleaners(id) ON DELETE CASCADE,
    task_type task_type NOT NULL,
    proficiency_level INTEGER CHECK (proficiency_level >= 1 AND proficiency_level <= 5),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(cleaner_id, task_type)
);

-- Client task preferences (ordered by priority)
CREATE TABLE client_task_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    task_type task_type NOT NULL,
    priority INTEGER NOT NULL CHECK (priority >= 1 AND priority <= 4),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(client_id, task_type),
    UNIQUE(client_id, priority)
);

-- ============================================
-- CONSTRAINTS & PREFERENCES
-- ============================================

-- Animals (owned by clients)
CREATE TABLE client_animals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    animal_type animal_type NOT NULL,
    notes TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Cleaner constraints (allergies, fears, preferences)
CREATE TABLE cleaner_constraints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cleaner_id UUID NOT NULL REFERENCES cleaners(id) ON DELETE CASCADE,
    constraint_type constraint_type NOT NULL,
    
    -- Specific details
    animal_type animal_type, -- For animal_allergy and animal_fear
    severity VARCHAR(50), -- 'mild', 'moderate', 'severe'
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Languages (spoken by cleaners and clients)
CREATE TABLE cleaner_languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cleaner_id UUID NOT NULL REFERENCES cleaners(id) ON DELETE CASCADE,
    language_code language_code NOT NULL,
    proficiency VARCHAR(50), -- 'basic', 'conversational', 'fluent', 'native'
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(cleaner_id, language_code)
);

CREATE TABLE client_languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    language_code language_code NOT NULL,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(client_id, language_code)
);

-- ============================================
-- MATCHING & PREFERENCES
-- ============================================

-- Blacklist (exclusions - hard constraint C10)
CREATE TABLE blacklist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cleaner_id UUID NOT NULL REFERENCES cleaners(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    reason TEXT,
    added_by VARCHAR(100), -- Who added this restriction
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(cleaner_id, client_id)
);

-- Preferences (star/flag system - S2 scoring override)
CREATE TABLE preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Who is expressing the preference
    source_entity_id UUID NOT NULL,
    source_entity_type entity_type NOT NULL,
    
    -- Who they prefer
    target_entity_id UUID NOT NULL,
    target_entity_type entity_type NOT NULL,
    
    -- Preference strength
    is_starred BOOLEAN NOT NULL DEFAULT false,
    is_flagged BOOLEAN NOT NULL DEFAULT false,
    notes TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(source_entity_id, source_entity_type, target_entity_id, target_entity_type)
);

-- ============================================
-- MATCHING HISTORY (for analytics and debugging)
-- ============================================

CREATE TABLE match_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Request details
    source_entity_id UUID NOT NULL,
    source_entity_type entity_type NOT NULL,
    request_type VARCHAR(50) NOT NULL, -- 'permanent', 'onetime_hours', 'onetime_period'
    
    -- Parameters
    extended_search BOOLEAN DEFAULT false,
    specific_period_start DATE,
    specific_period_end DATE,
    
    -- Results
    match_count INTEGER,
    execution_time_ms INTEGER,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE match_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_request_id UUID NOT NULL REFERENCES match_requests(id) ON DELETE CASCADE,
    
    -- Matched entity
    matched_entity_id UUID NOT NULL,
    matched_entity_type entity_type NOT NULL,
    
    -- Scoring details
    rank INTEGER NOT NULL,
    total_score DECIMAL(5,2) NOT NULL,
    
    -- Score breakdown
    distance_score DECIMAL(5,2),
    travel_time_score DECIMAL(5,2),
    language_score DECIMAL(5,2),
    fears_score DECIMAL(5,2),
    tasks_score DECIMAL(5,2),
    allergy_score DECIMAL(5,2),
    
    -- Travel metrics
    distance_km DECIMAL(8,2),
    travel_time_minutes INTEGER,
    
    -- Flags
    is_preferred BOOLEAN DEFAULT false,
    ew_eligible BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Geographic indexes
CREATE INDEX idx_addresses_coordinates ON addresses USING GIST(coordinates);

-- Entity lookups
CREATE INDEX idx_cleaners_active ON cleaners(is_active) WHERE is_active = true;
CREATE INDEX idx_clients_active ON clients(is_active) WHERE is_active = true;
CREATE INDEX idx_cleaners_transport ON cleaners(transport_mode);
CREATE INDEX idx_clients_office_type ON clients(office_type);

-- Scheduling indexes
CREATE INDEX idx_schedules_entity ON schedules(entity_id, entity_type);
CREATE INDEX idx_schedules_permanent ON schedules(is_permanent);
CREATE INDEX idx_schedules_day ON schedules(day_of_week) WHERE is_permanent = true;
CREATE INDEX idx_schedules_date ON schedules(specific_date) WHERE specific_date IS NOT NULL;
CREATE INDEX idx_absences_cleaner_dates ON absences(cleaner_id, start_date, end_date);

-- Skills and preferences
CREATE INDEX idx_cleaner_skills_cleaner ON cleaner_skills(cleaner_id);
CREATE INDEX idx_cleaner_skills_task ON cleaner_skills(task_type);
CREATE INDEX idx_client_tasks_client ON client_task_preferences(client_id);
CREATE INDEX idx_client_tasks_priority ON client_task_preferences(client_id, priority);

-- Constraints
CREATE INDEX idx_client_animals_client ON client_animals(client_id);
CREATE INDEX idx_cleaner_constraints_cleaner ON cleaner_constraints(cleaner_id);
CREATE INDEX idx_cleaner_constraints_type ON cleaner_constraints(constraint_type);

-- Languages
CREATE INDEX idx_cleaner_languages_cleaner ON cleaner_languages(cleaner_id);
CREATE INDEX idx_client_languages_client ON client_languages(client_id);

-- Matching
CREATE INDEX idx_blacklist_cleaner ON blacklist(cleaner_id);
CREATE INDEX idx_blacklist_client ON blacklist(client_id);
CREATE INDEX idx_blacklist_pair ON blacklist(cleaner_id, client_id);
CREATE INDEX idx_preferences_source ON preferences(source_entity_id, source_entity_type);
CREATE INDEX idx_preferences_target ON preferences(target_entity_id, target_entity_type);

-- History
CREATE INDEX idx_match_requests_source ON match_requests(source_entity_id, source_entity_type);
CREATE INDEX idx_match_requests_created ON match_requests(created_at);
CREATE INDEX idx_match_results_request ON match_results(match_request_id);
CREATE INDEX idx_match_results_matched ON match_results(matched_entity_id, matched_entity_type);

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- View: Cleaners with available hours needing matches
CREATE VIEW cleaners_needing_hours AS
SELECT 
    c.id,
    c.first_name,
    c.last_name,
    c.contractual_hours,
    c.planned_hours,
    c.available_hours,
    c.transport_mode,
    a.coordinates,
    a.city
FROM cleaners c
LEFT JOIN addresses a ON c.home_address_id = a.id
WHERE c.is_active = true 
  AND c.available_hours > 0;

-- View: Clients needing permanent cleaners
CREATE VIEW clients_needing_permanent_cleaners AS
SELECT 
    c.id,
    c.first_name,
    c.last_name,
    c.requested_hours_permanent,
    c.planned_hours_permanent,
    (c.requested_hours_permanent - c.planned_hours_permanent) AS unfilled_hours,
    c.office_type,
    c.has_pets,
    c.smokes_inside,
    a.coordinates,
    a.city
FROM clients c
LEFT JOIN addresses a ON c.address_id = a.id
WHERE c.is_active = true 
  AND (c.requested_hours_permanent - c.planned_hours_permanent) >= 2; -- C3 constraint

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_cleaners_updated_at BEFORE UPDATE ON cleaners
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_addresses_updated_at BEFORE UPDATE ON addresses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_schedules_updated_at BEFORE UPDATE ON schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================

COMMENT ON TABLE cleaners IS 'Core cleaner profiles with employment details and transport preferences';
COMMENT ON TABLE clients IS 'Core client profiles with service requirements and household details';
COMMENT ON TABLE addresses IS 'Geographic locations using PostGIS for coordinate-based matching';
COMMENT ON TABLE schedules IS 'Both permanent schedules and one-time bookings for cleaners and clients';
COMMENT ON TABLE blacklist IS 'Hard constraint C10: Exclusions preventing cleaner-client matching';
COMMENT ON TABLE preferences IS 'Scoring override S2: Star/flag system for preferred matches';
COMMENT ON COLUMN cleaners.available_hours IS 'Computed: contractual_hours - planned_hours';
COMMENT ON COLUMN addresses.coordinates IS 'PostGIS geography type for accurate distance calculations';
