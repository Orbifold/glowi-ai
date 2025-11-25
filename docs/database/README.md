# Glowi Matching Engine - Database

This directory contains the PostgreSQL database schema and seed data for the Glowi Matching Engine.

## Files

### `schema.sql`
Complete PostgreSQL schema definition including:
- **13 main tables** for cleaners, clients, scheduling, constraints, and matching
- **Custom types** (enums) for transport modes, office types, tasks, languages, etc.
- **PostGIS geography columns** for accurate coordinate-based distance calculations
- **Indexes** optimized for geographic queries and constraint checking
- **Triggers** for automatic timestamp updates
- **Views** for common queries (cleaners needing hours, clients needing help)

### `seed-data.sql`
Sample test data including:
- **16 cleaners** with various transport modes, skills, and availability
- **21 clients** with different requirements and household details
- **33 addresses** in Amsterdam area (plus 3 far away for distance testing)
- **Skills, preferences, constraints** covering all business rules
- **Edge cases** for testing:
  - Cleaners with animal allergies/fears (C7, S8, S10)
  - Clients who smoke (C8)
  - Blacklisted pairs (C10)
  - Preferred matches (S2 override)
  - Far away locations (C1 distance filter)
  - Fully booked cleaners (C11)

## Setup Instructions

### Prerequisites
- PostgreSQL 14+ installed
- PostGIS extension enabled

### Initial Setup

1. **Create database:**
```bash
createdb glowi_matching_engine
```

2. **Apply schema:**
```bash
psql -d glowi_matching_engine -f schema.sql
```

3. **Load seed data:**
```bash
psql -d glowi_matching_engine -f seed-data.sql
```

### Verification

Run these queries to verify the setup:

```sql
-- Check cleaners with available hours
SELECT 
    first_name, 
    last_name, 
    contractual_hours, 
    planned_hours, 
    available_hours,
    transport_mode
FROM cleaners 
WHERE available_hours > 0;

-- Check clients needing permanent help (>2 hour gap per C3)
SELECT 
    first_name, 
    last_name, 
    requested_hours_permanent, 
    planned_hours_permanent,
    (requested_hours_permanent - planned_hours_permanent) AS gap
FROM clients 
WHERE (requested_hours_permanent - planned_hours_permanent) >= 2;

-- Test geographic distance calculation (Emma to Client 1)
SELECT 
    ST_Distance(
        (SELECT coordinates FROM addresses WHERE id = 'a1000001-0000-0000-0000-000000000001'),
        (SELECT coordinates FROM addresses WHERE id = 'a2000001-0000-0000-0000-000000000001')
    ) / 1000 AS distance_km;
```

## Schema Overview

### Core Entities
- `cleaners` - Cleaner profiles with employment details
- `clients` - Client profiles with service requirements  
- `addresses` - Geographic locations with PostGIS coordinates

### Scheduling
- `schedules` - Both permanent and one-time bookings
- `absences` - Cleaner unavailability periods

### Skills & Tasks
- `cleaner_skills` - Tasks cleaners can perform
- `client_task_preferences` - Priority-ordered task requirements

### Constraints
- `cleaner_constraints` - Allergies, fears, smoking preferences, asthma
- `client_animals` - Pets owned by clients
- `blacklist` - Hard exclusions (C10)

### Preferences & Languages
- `preferences` - Star/flag system for match overrides (S2)
- `cleaner_languages` / `client_languages` - Language capabilities

### Matching History
- `match_requests` - Log of matching requests
- `match_results` - Detailed results with scores and breakdowns

## Business Rules Mapping

The schema directly supports all constraint filters (C1-C11) and scoring parameters (S1-S10):

| Rule | Database Support |
|------|------------------|
| **C1** Distance | PostGIS geography + distance calculations |
| **C2** Travel Time | Requires external service integration |
| **C3** Availability | `schedules` table with `is_permanent` flag |
| **C7** Allergies | `cleaner_constraints` + `client_animals` |
| **C8** Smoking | `clients.smokes_inside` + `cleaner_constraints` |
| **C9** Hours | `schedules` duration calculations |
| **C10** Blacklist | `blacklist` table |
| **C11** Empty Slots | `cleaners.available_hours` computed column |
| **S1** Distance Score | PostGIS distance + `transport_mode` + `office_type` |
| **S2** Preference Override | `preferences` table with `is_starred`/`is_flagged` |
| **S3** Travel Time Score | Requires external service integration |
| **S7** Language Match | `cleaner_languages` + `client_languages` |
| **S8** Fears | `cleaner_constraints.animal_fear` |
| **S9** Tasks Match | `cleaner_skills` + `client_task_preferences.priority` |
| **S10** Allergy Score | `cleaner_constraints.animal_allergy` |

## Test Scenarios in Seed Data

### Constraint Testing

**C3 - Availability (Permanent):**
- Client 1: 8 hours requested, 0 planned → 8 hour gap ✅
- Client 11: 8 hours requested, 7 planned → 1 hour gap ❌

**C7 - Animal Allergies:**
- Cleaner Anna (c13) has severe dog allergy
- Should NOT match with Clients 2, 4, 6, 13, 17 (have dogs)

**C8 - Smoking:**
- Cleaner Lisa (c15) has asthma + smoking preference
- Should NOT match with Clients 3, 8, 15 (smoke inside)

**C10 - Blacklist:**
- Emma (c1) × Client 3 → Blacklisted
- Noah (c4) × Client 7 → Blacklisted
- Max (c14) × Client 14 → Blacklisted

**C1 - Distance (>25km):**
- Cleaner 16 in Purmerend (30km+ from Amsterdam center)
- Client 21 in Volendam (35km+ from Amsterdam center)

### Scoring Testing

**S2 - Preference Override:**
- Client 1 ⭐ Liam (c2) - Should appear in results even if score lower
- Client 4 ⭐ Julia (c7) - Should appear in results even if score lower

**S7 - Language Match:**
- Client 4 speaks NL/EN/DE
- Cleaner Julia (c7) speaks NL/EN/DE → Perfect match
- Cleaner Liam (c2) speaks NL/EN/DE → Perfect match

**S9 - Task Match (Weighted):**
- Client 4 has 4 task preferences (60%/30%/5%/5% weighting)
- Cleaner Julia (c7) has all 5 task types → High score

## Notes

- All coordinates are in Amsterdam area (real streets)
- UUIDs are used for all primary keys
- PostGIS `GEOGRAPHY` type uses SRID 4326 (WGS84)
- Computed columns (`available_hours`, `duration_hours`) auto-update
- Triggers maintain `updated_at` timestamps automatically
