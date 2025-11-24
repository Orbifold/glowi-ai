# Architecture & Technical Guidelines

## Technologies
- **Language:** C# / .NET (Dotnet Core v10.0.100)
- **ASP.Net REST endpoints** for service exposure
- **Data Storage:** PostgreSQL
- **ORM:** Entity Framework Core


## Non-Functional Requirements
1.  **Maintainability:**
    - Strict separation between **Data Retrieval**, **Constraint Logic**, and **Scoring Logic**.
    - Database configuration can change without breaking code structure.
2.  **Speed:**
    - Current limit: < 3 minutes per requested list (Sub-optimal DB allowed initially).
    - Future-proof for optimization.
3.  **Correctness:**
    - No result violating HARD constraints should appear in the list.

## Component Design
### 1. Data Layer
- Repositories responsible for fetching Cleaner and Client profiles including addresses, coordinates, planning items, and preferences.

### 2. Logic Layer (The "Engine")
- **ConstraintEvaluator:** Accepts a source and a list of candidates. returns a filtered list of `ValidMatch` objects.
    - Handles Binary Cut-offs (Distance > 25km, Allergies, etc.).
- **ScoringCalculator:** Accepts `ValidMatch` objects. Calculates a 0-100% score based on weighted parameters.
    - **DistanceCalculator:** Handles linear fall-off formulas based on transport mode and office location.
- **Service Class:** Orchestrates the flow: `Get Data` -> `Filter` -> `Score` -> `Sort` -> `Return Top 30`.

## Data Structures
- **Input:** JSON payload representing the Trigger (e.g., Cleaner ID, Request Type).
- **Output:** JSON list of top 30 matches containing:
    1. Score
    2. Counterpart Details (Client/Cleaner)
    3. Date/Hours
    4. Contact Info
    5. Calculation Breakdown
    6. Travel Metrics (Dist/Time/Mode)
    7. Economically Unemployed (EW) Eligibility Icon
    8. Applied Filters