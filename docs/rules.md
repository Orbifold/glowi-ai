# Business Rules & Logic

## 1. Hard Constraints (Filters)
*Matches failing these checks are excluded immediately.*

| ID | Parameter | Rule | Type |
| :--- | :--- | :--- | :--- |
| C1 | **Distance** | Filter if > 25km (Birdflight). *Note: Soft filter, can be expanded to 60km by consultant.* | Soft (Default On) |
| C2 | **Travel Time** | Filter if > 30min. *Note: Soft filter, can be expanded to 60min.* | Soft (Default On) |
| C3 | **Availability** | **Permanent:** Match only if requested hours differ by at least 2 hours from planned. <br> **One-Time:** Match only if cleaner is unavailable/absent. | HARD |
| C7 | **Allergies** | If Client has animals and Cleaner has specific animal allergy: NO MATCH. | Soft (Default On) |
| C8 | **Smoking** | If Client smokes inside and Cleaner has asthma/preference for non-smoking: NO MATCH. | Soft (Default On) |
| C9 | **Hours** | Requested hours must match offered hours for the specific period. | HARD |
| C10 | **Exclusion** | If counterpart is on Blacklist: NO MATCH. | HARD |
| C11 | **Empty Slots** | Only show cleaners who actually need hours filled. | HARD |

## 2. Scoring Logic (Ranking)
*Total Score is a weighted sum. Calculate per parameter.*

| ID | Parameter | Weight | Logic / Formula |
| :--- | :--- | :--- | :--- |
| S1 | **Distance** | 12% | **Calculation Logic (Linear Fall-off):** <br> *Based on Office Type & Transport Mode.* <br> **Car/Moto:** <br> - Big City: `-8d + 100` (d≤12.5), else 0 <br> - Standard: `-4d + 100` (d≤25), else 0 <br> - Countryside: `-2.5d + 100` (d≤40), else 0 <br> **Moped/E-Bike:** `-6d + 100` (d≤15), else 0 <br> **Bicycle:** `-9d + 100` (d≤11.11), else 0 <br> **Foot:** `-33d + 100` (d≤3), else 0 <br> *Logic:* Use max distance of (To-Target) or (From-Target). If gap > 2h, calculate (Prev->Home->Next). |
| S2 | **Preference** | N/A | Star/Flag. If Client/HHH has set a preference for this specific person, ensure they appear in the list (override score if within 60km). |
| S3 | **Travel Time** | 21% | Formula: `-3.3m + 100` (m≤30), else 0. <br> *Public Transport Exception:* Travel Time counts 50%, Distance counts 0%. |
| S7 | **Language** | 5% | Match if shared language exists. If no data, exclude from weight calc (distribute 5% elsewhere). |
| S8 | **Fears** | 16% | If Client has animals and Cleaner has Fear: 0% for this component. Else 100%. |
| S9 | **Tasks** | 12% | **Weighted Match based on Client Preference Order:** <br> 1 Pref: 100% if match. <br> 2 Prefs: 1st=70%, 2nd=30%. <br> 3 Prefs: 60% / 30% / 10%. <br> 4 Prefs: 60% / 30% / 5% / 5%. |
| S10 | **Allergy** | 30% | *Note: Requirements text duplicates 'Fears' description here. Assume standard Allergy check logic.* Match = 0%, No Issue = 100%. |

## 3. Specific Calculation Rules
- **Economically Unemployed (EW):**
    - Icon is TRUE if: Cleaner cannot work the whole day.
    - Icon is FALSE if: Cleaner works part of the day (e.g., client in afternoon, looking for replacement in morning).