# Project Plan: Glowi Matching Engine (ME)

## Goal
The goal of this project is to create a matching engine (ME) which efficiently pairs cleaners to clients based on various criteria such as location, availability, and service type. The ME should be scalable, reliable, and based on Google OR Tools for C#.


## Status
- [ ] **Phase 1: Core Architecture Setup**
    - [ ] Initialize .NET Solution & Projects
    - [ ] Define Data Models (DTOs) for Inputs/Outputs    
- [ ] **Phase 2: Logic Engine**
    - [ ] Implement `ConstraintEngine` (Filters)
    - [ ] Implement `ScoringEngine` (Weighted Ranking)
    - [ ] Implement Distance & Travel Time Calculation Logic
- [ ] **Phase 3: Endpoint Implementation**
    - [ ] **Task 01: Endpoint - Find Permanent Clients for a Cleaner** (CASE 1)
    - [ ] Task 02: Endpoint - Find Permanent Cleaners for a Client (CASE 5)
    - [ ] Task 03: Endpoint - Find One-time Clients for a Cleaner (Available Hours) (CASE 2/4)
    - [ ] Task 04: Endpoint - Find One-time Cleaner for a Client (Available Hours) (CASE 6)
    - [ ] Task 05: Endpoint - Find One-time Clients for a Cleaner (Specific Period)
    - [ ] Task 06: Endpoint - Find One-time Cleaner for a Client (Specific Period)
    - [ ] Task 07: Endpoint - Find One-time Cleaner for a Client (Available Hours - Variation)
- [ ] **Phase 4: Testing & Validation**
    - [ ] Unit Tests for Scoring Formulas
    - [ ] Integration Tests for Constraints