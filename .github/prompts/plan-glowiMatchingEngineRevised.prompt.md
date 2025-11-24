# Revised Project Plan: Glowi Matching Engine (ME)

## Goal
Create a matching engine (ME) which efficiently pairs cleaners to clients based on various criteria such as location, availability, and service type. The ME should be scalable, reliable, and based on Google OR Tools for C#.

## Project Context
This is a **greenfield project** with comprehensive business requirements documented but zero implementation. The following plan addresses infrastructure setup, data modeling, core engine implementation, and API development in a logical sequence.

## Status & Phases

### Phase 0: Solution & Infrastructure Setup
**Goal:** Establish .NET solution structure and development environment

- [ ] Create .NET solution with three projects:
  - `Glowi.MatchingEngine.Api` (ASP.NET Core Web API)
  - `Glowi.MatchingEngine.Core` (Business logic, domain models)
  - `Glowi.MatchingEngine.Infrastructure` (Data access, EF Core)
- [ ] Add NuGet packages:
  - `Npgsql.EntityFrameworkCore.PostgreSQL` (PostgreSQL provider)
  - `NetTopologySuite` or `GeoCoordinate.NetCore` (geographic calculations)
  - `Swashbuckle.AspNetCore` (Swagger/OpenAPI)
  - `Serilog` (Logging)
- [ ] Create `appsettings.json` with connection strings for local PostgreSQL and configuration sections
- [ ] Initialize Git repository with proper `.gitignore` for .NET projects
- [x] **Decision Resolved:** .NET Core v10.0.100 is installed and will be used
- [x] **Decision Resolved:** Google.OrTools NuGet package will be used for optimization capabilities

### Phase 1: Database Foundation
**Goal:** Design and implement complete data model with EF Core

- [ ] Design PostgreSQL schema covering all required entities:
  - `Cleaner` (ID, Name, ContactInfo, TransportMode, ContractualHours, etc.)
  - `Client` (ID, Name, ContactInfo, RequiredTasks, HasPets, Smoking, etc.)
  - `Address` (ID, Street, City, Coordinates/Geography, OfficeType)
  - `Schedule` (ID, EntityID, EntityType, DayOfWeek, StartTime, EndTime, IsPermanent)
  - `Preference` (ID, EntityID, EntityType, PreferenceType, Value, Priority)
  - `Constraint` (ID, EntityID, EntityType, ConstraintType, Value)
  - `Blacklist` (CleanerID, ClientID, Reason, CreatedDate)
- [ ] Create SQL schema script (`schema.sql`) defining all tables, indexes, and constraints
- [ ] Create SQL seed data script (`seed-data.sql`) with sample cleaners, clients, and test scenarios
- [ ] Implement EF Core `GlowiDbContext` with entity configurations
  - Configure relationships and indexes
  - Set up value converters for enums and complex types
  - Configure geography/coordinate columns using NetTopologySuite
- [ ] Create initial migration and apply to database
- [ ] Implement Repository Pattern:
  - `ICleanerRepository` / `CleanerRepository`
  - `IClientRepository` / `ClientRepository`
  - `IScheduleRepository` / `ScheduleRepository`
  - `IPreferenceRepository` / `PreferenceRepository`
- [ ] Create seed data fixtures:
  - 20+ test cleaners with realistic coordinates, transport modes, skills
  - 30+ test clients with various requirements, locations, preferences
  - Include edge cases (allergies, fears, smoking, blacklists)
- [ ] Write repository integration tests

### Phase 2: Core Matching Engine
**Goal:** Implement constraint filtering and scoring logic

#### 2.1 Distance & Geography
- [ ] Implement `DistanceCalculator` class:
  - Haversine formula for "birdflight" distance calculation
  - Support for different coordinate systems
  - Distance scoring logic (S1) with transport-mode-specific formulas:
    - Car/Moto: Big City, Standard, Countryside variations
    - Moped/E-Bike, Bicycle, Foot formulas
  - Handle 2hr+ gap scenarios (Prev→Home→Next routing)
- [ ] Unit tests for distance calculations with known coordinate pairs
- [ ] **Decision Required:** Travel time calculation approach (API vs estimation vs lookup)

#### 2.2 Constraint Engine
- [ ] Implement `ConstraintEvaluator` class applying all filters (C1-C11):
  - `C1`: Distance filter (< 25km, expandable to 60km)
  - `C2`: Travel time filter (< 30min, expandable to 60min)
  - `C3`: Availability (permanent 2hr gap, one-time unavailability)
  - `C7`: Allergies (animals vs cleaner allergies)
  - `C8`: Smoking (client smokes inside vs cleaner preferences)
  - `C9`: Hours matching for specific period
  - `C10`: Blacklist exclusion
  - `C11`: Empty slots validation
- [ ] Support for soft/hard constraint configuration
- [ ] Return `ValidMatch` objects with constraint metadata
- [ ] Unit tests for each constraint rule with edge cases
- [ ] **Decision Required:** Extended search flag mechanism (API params, roles, config)

#### 2.3 Scoring Engine
- [ ] Implement `ScoringCalculator` class with weighted scoring (S1-S10):
  - `S1`: Distance (12% weight) - reuse DistanceCalculator
  - `S2`: Preference override (Star/Flag system, force within 60km)
  - `S3`: Travel Time (21% weight, formula: -3.3m + 100)
  - `S7`: Language match (5% weight)
  - `S8`: Fears (16% weight, animals vs cleaner fears)
  - `S9`: Tasks (12% weight, weighted by client preference order)
  - `S10`: Allergy (30% weight)
- [ ] Handle missing data (redistribute weights)
- [ ] Public transport exception (50% travel time, 0% distance)
- [ ] Return score breakdown for transparency
- [ ] Unit tests for each scoring component and edge cases
- [ ] **Decision Required:** Should scoring weights be configurable?

#### 2.4 Orchestration
- [ ] Implement `MatchingOrchestrator` service:
  - Coordinate: Data Retrieval → Filter → Score → Sort → Top 30
  - Handle different matching scenarios (permanent vs one-time)
  - Calculate EW (Economically Unemployed) eligibility
  - Generate detailed match results with breakdowns
- [ ] Create domain models and DTOs:
  - `MatchRequest` (input)
  - `MatchResult` (output with score, breakdown, travel metrics)
  - `MatchCandidate` (intermediate processing)
- [ ] Integration tests with mock repositories

### Phase 3: REST API Implementation
**Goal:** Expose matching engine via ASP.NET Core endpoints

#### 3.1 API Infrastructure
- [ ] Set up ASP.NET Core project structure:
  - Controllers folder
  - Middleware (error handling, validation, logging)
  - Dependency injection configuration
- [ ] Configure Swagger/OpenAPI documentation
- [ ] Implement API DTOs (separate from domain models):
  - Request models with validation attributes
  - Response models with JSON serialization
  - Error response models
- [ ] Add health check endpoint
- [ ] **Decision Required:** Authentication/authorization strategy (JWT, API keys, roles)

#### 3.2 Endpoint Implementation
- [ ] **Task 01: POST /api/matching/permanent-clients-for-cleaner** (CASE 1)
  - Input: CleanerID, optional extended search flags
  - Output: Top 30 permanent client matches
  - Implement as per `task-01-endpoint-permanent-clients.md`
- [ ] **Task 02: POST /api/matching/permanent-cleaners-for-client** (CASE 5)
  - Input: ClientID
  - Output: Top 30 permanent cleaner matches
- [ ] **Task 03: POST /api/matching/onetime-clients-for-cleaner** (CASE 2/4)
  - Input: CleanerID, available hours
  - Output: Top 30 one-time client matches
- [ ] **Task 04: POST /api/matching/onetime-cleaner-for-client** (CASE 6)
  - Input: ClientID, available hours
  - Output: Top 30 one-time cleaner matches
- [ ] **Task 05: POST /api/matching/onetime-clients-specific-period**
  - Input: CleanerID, specific date range
  - Output: Top 30 one-time client matches for period
- [ ] **Task 06: POST /api/matching/onetime-cleaner-specific-period**
  - Input: ClientID, specific date range
  - Output: Top 30 one-time cleaner matches for period
- [ ] **Task 07: POST /api/matching/onetime-cleaner-variation**
  - Input: ClientID, available hours variation
  - Output: Top 30 one-time cleaner matches
- [ ] **Consider:** Consolidate endpoints using query parameters instead of 7 separate endpoints

#### 3.3 Testing & Documentation
- [ ] Integration tests for each endpoint using WebApplicationFactory
- [ ] Test cases for constraint violations (should return empty or filtered results)
- [ ] Test cases for scoring accuracy with known scenarios
- [ ] OpenAPI/Swagger documentation with examples
- [ ] Postman collection for manual testing

### Phase 4: Geographic Services Integration
**Goal:** Add travel time calculations and optimize geographic operations

- [ ] Evaluate travel time calculation options:
  - Option A: External API (Google Maps Distance Matrix API)
  - Option B: Estimated calculations (distance / average speed by mode)
  - Option C: Precomputed lookup tables
- [ ] Implement chosen travel time calculation service
- [ ] Add caching layer for distance/time calculations:
  - Redis or in-memory cache (IMemoryCache)
  - Cache key strategy (coordinate pairs + transport mode)
  - TTL configuration
- [ ] Configure API keys and rate limiting (if using external service)
- [ ] Add retry policies for external API calls (Polly library)
- [ ] Database indexing for coordinate/geography queries
- [ ] Performance profiling for geographic operations

### Phase 5: Testing & Optimization
**Goal:** Validate performance requirements and optimize system

#### 5.1 Performance Testing
- [ ] Create performance test suite:
  - Test with 100, 500, 1000+ candidate scenarios
  - Validate < 3 minute response time requirement
  - Profile database query performance
  - Profile scoring calculation performance
- [ ] Load testing with concurrent requests
- [ ] Identify and optimize bottlenecks

#### 5.2 Edge Case & Validation Testing
- [ ] Test scenarios with no matches (overly restrictive constraints)
- [ ] Test blacklisted pairs (should never appear)
- [ ] Test constraint violation detection
- [ ] Test scoring edge cases (missing data, null values)
- [ ] Test EW eligibility calculation accuracy
- [ ] Test preference override scenarios

#### 5.3 Database Optimization
- [ ] Add indexes on frequently queried columns:
  - Coordinates/geography columns
  - Cleaner/Client IDs
  - Schedule date/time ranges
  - Constraint and preference lookup fields
- [ ] Optimize N+1 query problems (use Include/ThenInclude)
- [ ] Consider database query caching
- [ ] Analyze and optimize slow queries

#### 5.4 Monitoring & Logging
- [ ] Implement structured logging with Serilog
- [ ] Add application insights/telemetry
- [ ] Log scoring breakdowns for debugging
- [ ] Log constraint filter results
- [ ] Monitor API endpoint performance
- [ ] Set up alerts for errors and performance degradation

### Phase 6: OR-Tools Integration (Optional)
**Goal:** Add optimization capabilities using Google OR-Tools

- [ ] **DECISION POINT:** Determine if OR-Tools is needed
  - Current design (filter→score→sort) may be sufficient
  - OR-Tools useful for: optimal global assignment, route optimization, scheduling
  - If not needed: Remove from project requirements
- [ ] If proceeding:
  - [ ] Add `Google.OrTools` NuGet package
  - [ ] Research OR-Tools constraint programming for matching problems
  - [ ] Implement OR-Tools optimization layer
  - [ ] Compare results with scoring-based approach
  - [ ] Benchmark performance implications

## Critical Decisions Required

### 1. OR-Tools Usage
**Question:** Is Google OR-Tools actually required for this project?
- **Current Approach:** Filter candidates → Calculate weighted scores → Sort → Return top 30
- **OR-Tools Approach:** Define optimization problem → Find optimal global assignment
- **Recommendation:** Current approach is simpler and likely sufficient. OR-Tools adds complexity and may not improve results for this use case.
- **Action:** Clarify requirements or remove OR-Tools from project goal.

### 2. .NET Version
**Question:** Which .NET version should be used?
- Documentation states "Dotnet Core v10.0.100" (doesn't exist)
- **Option A:** .NET 8 LTS (recommended for stability, long-term support)
- **Option B:** .NET 9 (latest features, shorter support cycle)
- **Action:** Choose version to determine NuGet package compatibility.

### 3. Travel Time Calculation
**Question:** How should travel time be calculated?
- **Option A:** External API (Google Maps, HERE, Azure Maps)
  - ✅ Accurate, real-world routing
  - ❌ Costs money, rate limits, external dependency
- **Option B:** Estimated calculation (distance / average speed)
  - ✅ Free, fast, no external dependency
  - ❌ Less accurate, doesn't account for traffic/routing
- **Option C:** Precomputed lookup tables
  - ✅ Fast, no runtime costs
  - ❌ Maintenance overhead, storage requirements
- **Action:** Choose approach based on budget and accuracy requirements.

### 4. Scoring Weight Configuration
**Question:** Should scoring weights (30% Allergy, 21% Travel Time, etc.) be configurable?
- **Option A:** Hardcoded in source code
  - ✅ Simple, no configuration complexity
  - ❌ Requires code changes and redeployment to adjust
- **Option B:** Configurable (appsettings.json or database)
  - ✅ Flexible, can be adjusted per deployment/client
  - ❌ More complex, potential for misconfiguration
- **Action:** Determine if business needs weight adjustments without code changes.

### 5. Extended Search Mechanism
**Question:** How should "extended search" work (25km→60km, 30min→60min)?
- Rules mention consultants can expand soft filters
- **Option A:** API query parameters (caller specifies extended=true)
- **Option B:** Role-based (consultant role has different limits)
- **Option C:** UI toggle (frontend controls, passes to API)
- **Action:** Define user stories for extended search functionality.

### 6. API Security
**Question:** What authentication/authorization is required?
- No security mentioned in current documentation
- **Considerations:**
  - Who can call these endpoints? (Internal only? External clients?)
  - Are there different permission levels? (Admin, consultant, viewer)
  - What data privacy requirements exist?
- **Action:** Define security requirements and authentication strategy.

### 7. Endpoint Consolidation
**Question:** Should the 7 planned endpoints be consolidated?
- Currently: 7 separate endpoints for different matching scenarios
- **Alternative:** Fewer endpoints with query parameters
  - Example: `/api/matching/find` with params: `entityType`, `matchType`, `periodType`
- **Trade-offs:** Simpler API vs. more explicit/discoverable endpoints
- **Action:** Decide on API design philosophy.

## Non-Functional Requirements Tracking

### Maintainability ✅
- Strict separation: Data Retrieval / Constraint Logic / Scoring Logic
- Repository pattern for database abstraction
- Service layer orchestration

### Speed ⏱️
- Target: < 3 minutes per requested list
- Will be validated in Phase 5 performance testing
- Optimization strategies: caching, indexing, query optimization

### Correctness ✅
- No result violating HARD constraints should appear
- Comprehensive unit tests for each constraint
- Integration tests for end-to-end validation

## Dependencies & Risks

### External Dependencies
- PostgreSQL database
- Geographic calculation library (NetTopologySuite or GeoCoordinate)
- Potentially: External routing/travel time API
- Potentially: Redis for caching

### Technical Risks
1. **Performance:** Achieving <3min with large datasets may require optimization
2. **Geographic Accuracy:** Distance/time calculations must be reliable
3. **Complexity:** Scoring logic with 10 parameters and multiple edge cases is complex
4. **Data Quality:** Matching quality depends on accurate cleaner/client data

### Mitigation Strategies
- Early performance testing (Phase 5)
- Comprehensive test coverage (unit + integration)
- Logging and monitoring for debugging
- Seed data covering edge cases

## Success Criteria

### Phase 0-1 (Foundation)
- ✅ .NET solution builds without errors
- ✅ Database migrations apply successfully
- ✅ Seed data loads correctly
- ✅ Repository tests pass

### Phase 2 (Core Engine)
- ✅ All 11 constraints (C1-C11) implemented and tested
- ✅ All 10 scoring parameters (S1-S10) implemented and tested
- ✅ Distance calculations match expected values
- ✅ Scoring breakdowns are transparent and traceable

### Phase 3 (API)
- ✅ All endpoints return valid JSON responses
- ✅ Swagger documentation is complete and accurate
- ✅ Integration tests pass for all endpoints
- ✅ Error handling is consistent

### Phase 4-5 (Optimization)
- ✅ Travel time calculations are accurate (within acceptable margin)
- ✅ Response times meet <3min requirement under load
- ✅ No constraint violations in returned results
- ✅ Logging provides adequate debugging information

## Timeline Estimation

*Note: Estimates assume 1 full-time developer*

- **Phase 0:** 2-3 days (solution setup, environment configuration)
- **Phase 1:** 5-7 days (database schema, EF Core, repositories, seed data)
- **Phase 2:** 10-14 days (core engine, constraints, scoring, tests)
- **Phase 3:** 7-10 days (API endpoints, integration tests, documentation)
- **Phase 4:** 3-5 days (geographic services, caching, optimization)
- **Phase 5:** 5-7 days (testing, profiling, optimization, monitoring)
- **Phase 6:** 5-7 days (OR-Tools integration, if required)

**Total:** 32-46 days (~6-9 weeks) without OR-Tools, 37-53 days with OR-Tools

## Next Immediate Actions

1. ✅ Review and approve this revised project plan
2. ⏳ Answer critical decision questions (OR-Tools, .NET version, travel time, etc.)
3. ⏳ Create initial .NET solution structure (Phase 0 start)
4. ⏳ Set up development environment (PostgreSQL, Docker, IDE)
5. ⏳ Begin database schema design (Phase 1 start)
