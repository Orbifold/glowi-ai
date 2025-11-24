# Task 01: Endpoint - Find Permanent Clients for a Cleaner

## Context
**Scenario (Case 1):** A Cleaner has unfilled contractual hours in their base planning (permanent schedule) and wants another client.
**Goal:** Return a list of the top 30 "Permanent Client" matches for this specific Cleaner.

## Input Data
- Cleaner Identifier (ID)
- Trigger Context: "Base Planning / Permanent"

## Implementation Steps

### 1. Data Retrieval
Retrieve the **Cleaner Profile**:
- Contractual hours vs Planned hours.
- Transport method.
- Home coordinates.
- Skills/Tasks (Cleaning, Ironing, etc.).
- Constraints (Allergies, Smoking preference, Fears).

Retrieve **Candidate Clients**:
- Filter for clients who need **Permanent** help (Constraint C3: Difference > 2 hours between requested and planned).
- Retrieve Client Coordinates, Tasks required, Pets, Smoking habits.

### 2. Apply Filters (Constraint Engine)
Filter the Candidate Clients list using the **Rules (C1 - C11)** defined in `rules.md`.
- **Crucial:** Ensure Filter C3 (Permanent Availability) is strictly applied.
- **Crucial:** Apply Filter C1 (Distance < 25km) and C2 (Time < 30min) unless flags indicate "Extended Search".

### 3. Calculate Scores (Scoring Engine)
For every passing candidate, calculate the Matching Score (0-100) using **Rules (S1 - S10)** in `rules.md`.
- Calculate Distance Score (S1) based on Cleaner's Transport Mode.
- Calculate Task Match (S9) based on Client's priority list.
- Calculate Weights (12% Distance, 21% Time, 30% Allergy, etc.).

### 4. Output Construction
Sort candidates by **Score (Descending)**. Take Top 30.
Map to JSON Output format:
1.  **Score**: The calculated percentage.
2.  **Client**: Name/ID.
3.  **Date/Hours**: Proposed timeslot.
4.  **Amount of Hours**: Duration.
5.  **Contact Info**: Client details.
6.  **Score Calculation**: Breakdown (e.g., "Distance: 8/12, Tasks: 12/12").
7.  **Travel Distance**: In km.
8.  **Travel Time**: In minutes.
9.  **Travel Mode**: (Car/Bike/etc).
10. **EW Possible**: Boolean/Icon logic (Check: Is this filling a gap in a partial day? If yes -> No EW. If empty day -> Yes EW).
11. **Filters Used**: List constraints applied.

## Development Instructions
- Create a `PermanentClientMatchingService`.
- Reuse the shared `ConstraintEvaluator` and `ScoringCalculator` (create these if they don't exist).
- Ensure the code is modular (Vertical Slice or Clean Architecture).
- Mock the Data Repository for now (use dummy JSON data for Clients/Cleaners).