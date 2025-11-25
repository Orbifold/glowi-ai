-- ============================================
-- Glowi Matching Engine - Seed Data
-- ============================================
-- Sample test data for development and testing
-- Includes realistic scenarios for constraint and scoring testing
-- ============================================

-- Clear existing data (for re-running script)
TRUNCATE TABLE match_results, match_requests, preferences, blacklist, 
               client_languages, cleaner_languages, cleaner_constraints, 
               client_animals, client_task_preferences, cleaner_skills, 
               absences, schedules, cleaners, clients, addresses 
RESTART IDENTITY CASCADE;

-- ============================================
-- ADDRESSES (Netherlands - Amsterdam area)
-- ============================================

-- Cleaner addresses
INSERT INTO addresses (id, street, house_number, postal_code, city, country, coordinates) VALUES
('a1000001-0000-0000-0000-000000000001', 'Damstraat', '12', '1012 JM', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8945 52.3676)')),
('a1000002-0000-0000-0000-000000000002', 'Overtoom', '45', '1054 HB', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8652 52.3607)')),
('a1000003-0000-0000-0000-000000000003', 'Hoofdweg', '123', '1058 AA', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8245 52.3573)')),
('a1000004-0000-0000-0000-000000000004', 'Linnaeusstraat', '67', '1093 EK', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9208 52.3603)')),
('a1000005-0000-0000-0000-000000000005', 'De Clercqstraat', '89', '1053 AE', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8705 52.3741)')),
('a1000006-0000-0000-0000-000000000006', 'Weesperzijde', '34', '1091 EC', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9133 52.3534)')),
('a1000007-0000-0000-0000-000000000007', 'Amstelveenseweg', '200', '1075 XN', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8556 52.3478)')),
('a1000008-0000-0000-0000-000000000008', 'Jan van Galenstraat', '150', '1051 KM', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8523 52.3821)')),
('a1000009-0000-0000-0000-000000000009', 'Bijlmerplein', '5', '1102 DA', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9479 52.3138)')),
('a1000010-0000-0000-0000-000000000010', 'Churchilllaan', '78', '1078 DT', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8798 52.3455)')),
('a1000011-0000-0000-0000-000000000011', 'Bilderdijkstraat', '123', '1053 KN', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8653 52.3697)')),
('a1000012-0000-0000-0000-000000000012', 'Piet Heinkade', '90', '1019 BR', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9158 52.3787)')),
('a1000013-0000-0000-0000-000000000013', 'Rijnstraat', '45', '1078 PZ', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8921 52.3512)')),
('a1000014-0000-0000-0000-000000000014', 'Spaarndammerstraat', '78', '1013 ST', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8743 52.3891)')),
('a1000015-0000-0000-0000-000000000015', 'Marnixstraat', '200', '1016 TL', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8801 52.3689)')),

-- Client addresses
('a2000001-0000-0000-0000-000000000001', 'Prinsengracht', '263', '1016 GV', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8825 52.3740)')),
('a2000002-0000-0000-0000-000000000002', 'Herengracht', '456', '1017 CA', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8908 52.3695)')),
('a2000003-0000-0000-0000-000000000003', 'Keizersgracht', '123', '1015 CJ', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8858 52.3734)')),
('a2000004-0000-0000-0000-000000000004', 'Vondelstraat', '78', '1054 GN', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8712 52.3623)')),
('a2000005-0000-0000-0000-000000000005', 'P.C. Hooftstraat', '34', '1071 BX', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8789 52.3586)')),
('a2000006-0000-0000-0000-000000000006', 'Beethovenstraat', '90', '1077 JH', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8834 52.3498)')),
('a2000007-0000-0000-0000-000000000007', 'Waterlooplein', '12', '1011 PG', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9013 52.3676)')),
('a2000008-0000-0000-0000-000000000008', 'Mauritskade', '45', '1092 AD', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9145 52.3589)')),
('a2000009-0000-0000-0000-000000000009', 'Olympiaplein', '67', '1076 AG', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8612 52.3467)')),
('a2000010-0000-0000-0000-000000000010', 'Ferdinand Bolstraat', '150', '1072 LJ', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8912 52.3543)')),
('a2000011-0000-0000-0000-000000000011', 'Ceintuurbaan', '234', '1072 GG', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8978 52.3556)')),
('a2000012-0000-0000-0000-000000000012', 'Wibautstraat', '89', '1091 GL', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.9089 52.3567)')),
('a2000013-0000-0000-0000-000000000013', 'Stadhouderskade', '123', '1073 AV', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8889 52.3589)')),
('a2000014-0000-0000-0000-000000000014', 'Nieuwezijds Voorburgwal', '45', '1012 RD', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8912 52.3745)')),
('a2000015-0000-0000-0000-000000000015', 'Rokin', '78', '1012 KX', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8934 52.3701)')),
('a2000016-0000-0000-0000-000000000016', 'Haarlemmerstraat', '150', '1013 EX', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8867 52.3812)')),
('a2000017-0000-0000-0000-000000000017', 'Utrechtsestraat', '90', '1017 VN', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8967 52.3634)')),
('a2000018-0000-0000-0000-000000000018', 'Kinkerstraat', '200', '1053 ED', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8623 52.3689)')),
('a2000019-0000-0000-0000-000000000019', 'Van Baerlestraat', '34', '1071 AR', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8778 52.3578)')),
('a2000020-0000-0000-0000-000000000020', 'Overtoom', '300', '1054 JA', 'Amsterdam', 'NL', ST_GeogFromText('POINT(4.8589 52.3598)')),

-- Far away addresses (for distance constraint testing - outside 25km)
('a3000001-0000-0000-0000-000000000001', 'Stationsweg', '10', '1441 EJ', 'Purmerend', 'NL', ST_GeogFromText('POINT(4.9594 52.5050)')),
('a3000002-0000-0000-0000-000000000002', 'Hoofdstraat', '50', '1131 AA', 'Volendam', 'NL', ST_GeogFromText('POINT(5.0689 52.4967)')),
('a3000003-0000-0000-0000-000000000003', 'Dorpsstraat', '25', '2121 CA', 'Bennebroek', 'NL', ST_GeogFromText('POINT(4.5978 52.3189)'));

-- ============================================
-- CLEANERS
-- ============================================

INSERT INTO cleaners (id, first_name, last_name, email, phone, contractual_hours, planned_hours, transport_mode, home_address_id, is_active) VALUES
-- Cleaners with available hours (needing matches)
('c0000001-0000-0000-0000-000000000001', 'Emma', 'de Vries', 'emma.devries@example.nl', '+31612345001', 32, 24, 'bicycle', 'a1000001-0000-0000-0000-000000000001', true),
('c0000002-0000-0000-0000-000000000002', 'Liam', 'Jansen', 'liam.jansen@example.nl', '+31612345002', 40, 30, 'car', 'a1000002-0000-0000-0000-000000000002', true),
('c0000003-0000-0000-0000-000000000003', 'Sophie', 'van Dijk', 'sophie.vandijk@example.nl', '+31612345003', 36, 28, 'ebike', 'a1000003-0000-0000-0000-000000000003', true),
('c0000004-0000-0000-0000-000000000004', 'Noah', 'Bakker', 'noah.bakker@example.nl', '+31612345004', 32, 20, 'moped', 'a1000004-0000-0000-0000-000000000004', true),
('c0000005-0000-0000-0000-000000000005', 'Mila', 'Visser', 'mila.visser@example.nl', '+31612345005', 40, 32, 'public_transport', 'a1000005-0000-0000-0000-000000000005', true),
('c0000006-0000-0000-0000-000000000006', 'Lucas', 'Smit', 'lucas.smit@example.nl', '+31612345006', 28, 18, 'bicycle', 'a1000006-0000-0000-0000-000000000006', true),
('c0000007-0000-0000-0000-000000000007', 'Julia', 'Mulder', 'julia.mulder@example.nl', '+31612345007', 36, 24, 'car', 'a1000007-0000-0000-0000-000000000007', true),
('c0000008-0000-0000-0000-000000000008', 'Finn', 'de Boer', 'finn.deboer@example.nl', '+31612345008', 32, 16, 'foot', 'a1000008-0000-0000-0000-000000000008', true),
('c0000009-0000-0000-0000-000000000009', 'Eva', 'Hendriks', 'eva.hendriks@example.nl', '+31612345009', 40, 35, 'motorcycle', 'a1000009-0000-0000-0000-000000000009', true),
('c0000010-0000-0000-0000-000000000010', 'Sem', 'van Leeuwen', 'sem.vanleeuwen@example.nl', '+31612345010', 32, 22, 'ebike', 'a1000010-0000-0000-0000-000000000010', true),

-- Cleaners fully booked (no available hours)
('c0000011-0000-0000-0000-000000000011', 'Tess', 'Dijkstra', 'tess.dijkstra@example.nl', '+31612345011', 40, 40, 'car', 'a1000011-0000-0000-0000-000000000011', true),
('c0000012-0000-0000-0000-000000000012', 'Daan', 'Meijer', 'daan.meijer@example.nl', '+31612345012', 36, 36, 'bicycle', 'a1000012-0000-0000-0000-000000000012', true),

-- Cleaners with constraints (allergies, fears)
('c0000013-0000-0000-0000-000000000013', 'Anna', 'Peters', 'anna.peters@example.nl', '+31612345013', 32, 20, 'car', 'a1000013-0000-0000-0000-000000000013', true),
('c0000014-0000-0000-0000-000000000014', 'Max', 'de Groot', 'max.degroot@example.nl', '+31612345014', 36, 24, 'ebike', 'a1000014-0000-0000-0000-000000000014', true),
('c0000015-0000-0000-0000-000000000015', 'Lisa', 'van den Berg', 'lisa.vandenberg@example.nl', '+31612345015', 28, 16, 'bicycle', 'a1000015-0000-0000-0000-000000000015', true),

-- Cleaner far away (distance constraint testing)
('c0000016-0000-0000-0000-000000000016', 'Thomas', 'Verhoeven', 'thomas.verhoeven@example.nl', '+31612345016', 40, 25, 'car', 'a3000001-0000-0000-0000-000000000001', true);

-- ============================================
-- CLIENTS
-- ============================================

INSERT INTO clients (id, first_name, last_name, email, phone, requested_hours_permanent, planned_hours_permanent, has_pets, smokes_inside, address_id, office_type, is_active) VALUES
-- Clients needing permanent help (>2 hours gap)
('cl000001-0000-0000-0000-000000000001', 'Jan', 'van der Meer', 'jan.vandermeer@example.nl', '+31612350001', 8, 0, false, false, 'a2000001-0000-0000-0000-000000000001', 'big_city', true),
('cl000002-0000-0000-0000-000000000002', 'Maria', 'Prins', 'maria.prins@example.nl', '+31612350002', 12, 6, true, false, 'a2000002-0000-0000-0000-000000000002', 'big_city', true),
('cl000003-0000-0000-0000-000000000003', 'Pieter', 'Schouten', 'pieter.schouten@example.nl', '+31612350003', 10, 4, false, true, 'a2000003-0000-0000-0000-000000000003', 'standard', true),
('cl000004-0000-0000-0000-000000000004', 'Laura', 'Hoekstra', 'laura.hoekstra@example.nl', '+31612350004', 16, 8, true, false, 'a2000004-0000-0000-0000-000000000004', 'big_city', true),
('cl000005-0000-0000-0000-000000000005', 'Jeroen', 'de Wilde', 'jeroen.dewilde@example.nl', '+31612350005', 6, 0, false, false, 'a2000005-0000-0000-0000-000000000005', 'standard', true),
('cl000006-0000-0000-0000-000000000006', 'Sanne', 'Vermeulen', 'sanne.vermeulen@example.nl', '+31612350006', 14, 10, true, false, 'a2000006-0000-0000-0000-000000000006', 'standard', true),
('cl000007-0000-0000-0000-000000000007', 'Bram', 'van Beek', 'bram.vanbeek@example.nl', '+31612350007', 10, 5, false, false, 'a2000007-0000-0000-0000-000000000007', 'big_city', true),
('cl000008-0000-0000-0000-000000000008', 'Fleur', 'Kuipers', 'fleur.kuipers@example.nl', '+31612350008', 8, 4, true, true, 'a2000008-0000-0000-0000-000000000008', 'standard', true),
('cl000009-0000-0000-0000-000000000009', 'Tim', 'Hermans', 'tim.hermans@example.nl', '+31612350009', 12, 0, false, false, 'a2000009-0000-0000-0000-000000000009', 'countryside', true),
('cl000010-0000-0000-0000-000000000010', 'Isa', 'Vos', 'isa.vos@example.nl', '+31612350010', 6, 2, false, false, 'a2000010-0000-0000-0000-000000000010', 'standard', true),

-- Clients with minimal gap (<2 hours - should not match for permanent)
('cl000011-0000-0000-0000-000000000011', 'Mark', 'Willems', 'mark.willems@example.nl', '+31612350011', 8, 7, false, false, 'a2000011-0000-0000-0000-000000000011', 'standard', true),

-- Clients fully covered (no gap)
('cl000012-0000-0000-0000-000000000012', 'Sara', 'van Dam', 'sara.vandam@example.nl', '+31612350012', 10, 10, false, false, 'a2000012-0000-0000-0000-000000000012', 'big_city', true),

-- Clients with various pets and preferences
('cl000013-0000-0000-0000-000000000013', 'Rob', 'van Dijk', 'rob.vandijk@example.nl', '+31612350013', 8, 0, true, false, 'a2000013-0000-0000-0000-000000000013', 'big_city', true),
('cl000014-0000-0000-0000-000000000014', 'Linda', 'Brouwer', 'linda.brouwer@example.nl', '+31612350014', 12, 4, true, false, 'a2000014-0000-0000-0000-000000000014', 'standard', true),
('cl000015-0000-0000-0000-000000000015', 'Kevin', 'van der Linde', 'kevin.vanderlinde@example.nl', '+31612350015', 10, 3, false, true, 'a2000015-0000-0000-0000-000000000015', 'standard', true),

-- Additional clients for variety
('cl000016-0000-0000-0000-000000000016', 'Michelle', 'Scholten', 'michelle.scholten@example.nl', '+31612350016', 14, 8, false, false, 'a2000016-0000-0000-0000-000000000016', 'big_city', true),
('cl000017-0000-0000-0000-000000000017', 'Patrick', 'Goossens', 'patrick.goossens@example.nl', '+31612350017', 6, 0, true, false, 'a2000017-0000-0000-0000-000000000017', 'standard', true),
('cl000018-0000-0000-0000-000000000018', 'Nicole', 'Koster', 'nicole.koster@example.nl', '+31612350018', 16, 10, false, false, 'a2000018-0000-0000-0000-000000000018', 'standard', true),
('cl000019-0000-0000-0000-000000000019', 'Dennis', 'van Vliet', 'dennis.vanvliet@example.nl', '+31612350019', 8, 3, true, false, 'a2000019-0000-0000-0000-000000000019', 'big_city', true),
('cl000020-0000-0000-0000-000000000020', 'Monique', 'de Haan', 'monique.dehaan@example.nl', '+31612350020', 10, 0, false, false, 'a2000020-0000-0000-0000-000000000020', 'standard', true),

-- Client far away (distance constraint testing)
('cl000021-0000-0000-0000-000000000021', 'Alex', 'Zijlstra', 'alex.zijlstra@example.nl', '+31612350021', 12, 0, false, false, 'a3000002-0000-0000-0000-000000000002', 'countryside', true);

-- ============================================
-- SCHEDULES
-- ============================================

-- Cleaner permanent schedules
INSERT INTO schedules (entity_id, entity_type, day_of_week, start_time, end_time, is_permanent) VALUES
-- Emma (c1) - 24 hours planned out of 32
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'monday', '09:00', '13:00', true),
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'wednesday', '09:00', '13:00', true),
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'friday', '09:00', '13:00', true),
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'tuesday', '14:00', '18:00', true),
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'thursday', '14:00', '18:00', true),
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'friday', '14:00', '18:00', true),

-- Liam (c2) - 30 hours planned out of 40
('c0000002-0000-0000-0000-000000000002', 'cleaner', 'monday', '08:00', '14:00', true),
('c0000002-0000-0000-0000-000000000002', 'cleaner', 'tuesday', '08:00', '14:00', true),
('c0000002-0000-0000-0000-000000000002', 'cleaner', 'wednesday', '08:00', '14:00', true),
('c0000002-0000-0000-0000-000000000002', 'cleaner', 'thursday', '08:00', '14:00', true),
('c0000002-0000-0000-0000-000000000002', 'cleaner', 'friday', '08:00', '14:00', true),

-- Client schedules (current commitments)
INSERT INTO schedules (entity_id, entity_type, day_of_week, start_time, end_time, is_permanent) VALUES
-- Client 2 (Maria) - 6 hours planned out of 12
('cl000002-0000-0000-0000-000000000002', 'client', 'monday', '09:00', '12:00', true),
('cl000002-0000-0000-0000-000000000002', 'client', 'thursday', '09:00', '12:00', true);

-- ============================================
-- ABSENCES
-- ============================================

INSERT INTO absences (cleaner_id, start_date, end_date, reason) VALUES
('c0000009-0000-0000-0000-000000000009', '2025-12-01', '2025-12-07', 'Vacation'),
('c0000010-0000-0000-0000-000000000010', '2025-11-28', '2025-11-29', 'Sick leave');

-- ============================================
-- SKILLS & TASKS
-- ============================================

-- Cleaner skills
INSERT INTO cleaner_skills (cleaner_id, task_type, proficiency_level) VALUES
-- Emma - General cleaning + ironing
('c0000001-0000-0000-0000-000000000001', 'cleaning', 5),
('c0000001-0000-0000-0000-000000000001', 'ironing', 4),

-- Liam - All-rounder
('c0000002-0000-0000-0000-000000000002', 'cleaning', 5),
('c0000002-0000-0000-0000-000000000002', 'ironing', 5),
('c0000002-0000-0000-0000-000000000002', 'window_cleaning', 4),
('c0000002-0000-0000-0000-000000000002', 'deep_cleaning', 5),

-- Sophie - Specialist in deep cleaning
('c0000003-0000-0000-0000-000000000003', 'cleaning', 4),
('c0000003-0000-0000-0000-000000000003', 'deep_cleaning', 5),
('c0000003-0000-0000-0000-000000000003', 'window_cleaning', 5),

-- Noah - Basic cleaning only
('c0000004-0000-0000-0000-000000000004', 'cleaning', 4),
('c0000004-0000-0000-0000-000000000004', 'ironing', 3),

-- Mila - Cleaning + laundry specialist
('c0000005-0000-0000-0000-000000000005', 'cleaning', 5),
('c0000005-0000-0000-0000-000000000005', 'laundry', 5),
('c0000005-0000-0000-0000-000000000005', 'ironing', 4),

-- Lucas - Basic cleaning
('c0000006-0000-0000-0000-000000000006', 'cleaning', 4),

-- Julia - All tasks
('c0000007-0000-0000-0000-000000000007', 'cleaning', 5),
('c0000007-0000-0000-0000-000000000007', 'ironing', 5),
('c0000007-0000-0000-0000-000000000007', 'window_cleaning', 5),
('c0000007-0000-0000-0000-000000000007', 'deep_cleaning', 4),
('c0000007-0000-0000-0000-000000000007', 'laundry', 4),

-- Finn - Limited (foot transport)
('c0000008-0000-0000-0000-000000000008', 'cleaning', 3),

-- Eva, Sem - Various skills
('c0000009-0000-0000-0000-000000000009', 'cleaning', 5),
('c0000009-0000-0000-0000-000000000009', 'window_cleaning', 4),
('c0000010-0000-0000-0000-000000000010', 'cleaning', 4),
('c0000010-0000-0000-0000-000000000010', 'ironing', 5),

-- Cleaners with constraints - various skills
('c0000013-0000-0000-0000-000000000013', 'cleaning', 5),
('c0000013-0000-0000-0000-000000000013', 'ironing', 4),
('c0000014-0000-0000-0000-000000000014', 'cleaning', 4),
('c0000014-0000-0000-0000-000000000014', 'deep_cleaning', 4),
('c0000015-0000-0000-0000-000000000015', 'cleaning', 5),
('c0000015-0000-0000-0000-000000000015', 'window_cleaning', 3);

-- Client task preferences (ordered by priority)
INSERT INTO client_task_preferences (client_id, task_type, priority) VALUES
-- Client 1 (Jan) - Cleaning only
('cl000001-0000-0000-0000-000000000001', 'cleaning', 1),

-- Client 2 (Maria) - Cleaning + ironing
('cl000002-0000-0000-0000-000000000002', 'cleaning', 1),
('cl000002-0000-0000-0000-000000000002', 'ironing', 2),

-- Client 3 (Pieter) - Cleaning + windows
('cl000003-0000-0000-0000-000000000003', 'cleaning', 1),
('cl000003-0000-0000-0000-000000000003', 'window_cleaning', 2),

-- Client 4 (Laura) - All tasks (4 preferences)
('cl000004-0000-0000-0000-000000000004', 'cleaning', 1),
('cl000004-0000-0000-0000-000000000004', 'deep_cleaning', 2),
('cl000004-0000-0000-0000-000000000004', 'ironing', 3),
('cl000004-0000-0000-0000-000000000004', 'window_cleaning', 4),

-- Client 5 (Jeroen) - Cleaning only
('cl000005-0000-0000-0000-000000000005', 'cleaning', 1),

-- Client 6 (Sanne) - 3 preferences
('cl000006-0000-0000-0000-000000000006', 'cleaning', 1),
('cl000006-0000-0000-0000-000000000006', 'ironing', 2),
('cl000006-0000-0000-0000-000000000006', 'laundry', 3),

-- Rest of clients - various combinations
('cl000007-0000-0000-0000-000000000007', 'cleaning', 1),
('cl000007-0000-0000-0000-000000000007', 'window_cleaning', 2),
('cl000008-0000-0000-0000-000000000008', 'cleaning', 1),
('cl000009-0000-0000-0000-000000000009', 'cleaning', 1),
('cl000009-0000-0000-0000-000000000009', 'deep_cleaning', 2),
('cl000010-0000-0000-0000-000000000010', 'cleaning', 1),
('cl000013-0000-0000-0000-000000000013', 'cleaning', 1),
('cl000013-0000-0000-0000-000000000013', 'ironing', 2),
('cl000014-0000-0000-0000-000000000014', 'cleaning', 1),
('cl000015-0000-0000-0000-000000000015', 'cleaning', 1),
('cl000016-0000-0000-0000-000000000016', 'cleaning', 1),
('cl000016-0000-0000-0000-000000000016', 'window_cleaning', 2),
('cl000017-0000-0000-0000-000000000017', 'cleaning', 1),
('cl000018-0000-0000-0000-000000000018', 'cleaning', 1),
('cl000018-0000-0000-0000-000000000018', 'ironing', 2),
('cl000019-0000-0000-0000-000000000019', 'cleaning', 1),
('cl000020-0000-0000-0000-000000000020', 'cleaning', 1);

-- ============================================
-- ANIMALS & CONSTRAINTS
-- ============================================

-- Client animals
INSERT INTO client_animals (client_id, animal_type, notes) VALUES
('cl000002-0000-0000-0000-000000000002', 'dog', 'Golden Retriever - friendly'),
('cl000004-0000-0000-0000-000000000004', 'cat', '2 cats'),
('cl000006-0000-0000-0000-000000000006', 'dog', 'Small terrier'),
('cl000008-0000-0000-0000-000000000008', 'cat', '1 cat - shy'),
('cl000008-0000-0000-0000-000000000008', 'bird', 'Parakeet'),
('cl000013-0000-0000-0000-000000000013', 'dog', 'Large German Shepherd'),
('cl000014-0000-0000-0000-000000000014', 'cat', '3 cats'),
('cl000017-0000-0000-0000-000000000017', 'dog', 'Labrador'),
('cl000019-0000-0000-0000-000000000019', 'rabbit', '2 rabbits');

-- Cleaner constraints
INSERT INTO cleaner_constraints (cleaner_id, constraint_type, animal_type, severity) VALUES
-- Anna (c13) - Dog allergy (severe) - should NOT match with dog-owning clients
('c0000013-0000-0000-0000-000000000013', 'animal_allergy', 'dog', 'severe'),

-- Max (c14) - Cat fear - should NOT match with cat-owning clients
('c0000014-0000-0000-0000-000000000014', 'animal_fear', 'cat', 'moderate'),

-- Lisa (c15) - Asthma + smoking preference - should NOT match with smoking clients
('c0000015-0000-0000-0000-000000000015', 'asthma', NULL, 'moderate'),
('c0000015-0000-0000-0000-000000000015', 'smoking_preference', NULL, 'severe'),

-- Emma (c1) - Mild cat allergy (but can work with cats)
('c0000001-0000-0000-0000-000000000001', 'animal_allergy', 'cat', 'mild');

-- ============================================
-- LANGUAGES
-- ============================================

-- Cleaner languages
INSERT INTO cleaner_languages (cleaner_id, language_code, proficiency) VALUES
('c0000001-0000-0000-0000-000000000001', 'nl', 'native'),
('c0000001-0000-0000-0000-000000000001', 'en', 'conversational'),
('c0000002-0000-0000-0000-000000000002', 'nl', 'native'),
('c0000002-0000-0000-0000-000000000002', 'en', 'fluent'),
('c0000002-0000-0000-0000-000000000002', 'de', 'basic'),
('c0000003-0000-0000-0000-000000000003', 'nl', 'native'),
('c0000003-0000-0000-0000-000000000003', 'pl', 'native'),
('c0000004-0000-0000-0000-000000000004', 'nl', 'fluent'),
('c0000004-0000-0000-0000-000000000004', 'en', 'basic'),
('c0000005-0000-0000-0000-000000000005', 'nl', 'native'),
('c0000005-0000-0000-0000-000000000005', 'en', 'fluent'),
('c0000005-0000-0000-0000-000000000005', 'fr', 'conversational'),
('c0000006-0000-0000-0000-000000000006', 'nl', 'native'),
('c0000007-0000-0000-0000-000000000007', 'nl', 'native'),
('c0000007-0000-0000-0000-000000000007', 'en', 'fluent'),
('c0000007-0000-0000-0000-000000000007', 'de', 'fluent'),
('c0000008-0000-0000-0000-000000000008', 'nl', 'native'),
('c0000009-0000-0000-0000-000000000009', 'nl', 'native'),
('c0000009-0000-0000-0000-000000000009', 'es', 'basic'),
('c0000010-0000-0000-0000-000000000010', 'nl', 'native'),
('c0000010-0000-0000-0000-000000000010', 'en', 'conversational'),
('c0000013-0000-0000-0000-000000000013', 'nl', 'native'),
('c0000014-0000-0000-0000-000000000014', 'nl', 'native'),
('c0000014-0000-0000-0000-000000000014', 'en', 'basic'),
('c0000015-0000-0000-0000-000000000015', 'nl', 'native');

-- Client languages
INSERT INTO client_languages (client_id, language_code) VALUES
('cl000001-0000-0000-0000-000000000001', 'nl'),
('cl000002-0000-0000-0000-000000000002', 'nl'),
('cl000002-0000-0000-0000-000000000002', 'en'),
('cl000003-0000-0000-0000-000000000003', 'nl'),
('cl000004-0000-0000-0000-000000000004', 'nl'),
('cl000004-0000-0000-0000-000000000004', 'en'),
('cl000004-0000-0000-0000-000000000004', 'de'),
('cl000005-0000-0000-0000-000000000005', 'nl'),
('cl000006-0000-0000-0000-000000000006', 'nl'),
('cl000006-0000-0000-0000-000000000006', 'fr'),
('cl000007-0000-0000-0000-000000000007', 'nl'),
('cl000008-0000-0000-0000-000000000008', 'nl'),
('cl000009-0000-0000-0000-000000000009', 'nl'),
('cl000009-0000-0000-0000-000000000009', 'en'),
('cl000010-0000-0000-0000-000000000010', 'nl'),
('cl000013-0000-0000-0000-000000000013', 'nl'),
('cl000013-0000-0000-0000-000000000013', 'en'),
('cl000014-0000-0000-0000-000000000014', 'nl'),
('cl000014-0000-0000-0000-000000000014', 'pl'),
('cl000015-0000-0000-0000-000000000015', 'nl'),
('cl000016-0000-0000-0000-000000000016', 'nl'),
('cl000016-0000-0000-0000-000000000016', 'en'),
('cl000017-0000-0000-0000-000000000017', 'nl'),
('cl000018-0000-0000-0000-000000000018', 'nl'),
('cl000019-0000-0000-0000-000000000019', 'nl'),
('cl000020-0000-0000-0000-000000000020', 'nl');

-- ============================================
-- BLACKLIST (C10 constraint testing)
-- ============================================

INSERT INTO blacklist (cleaner_id, client_id, reason, added_by) VALUES
-- Emma cannot work for Client 3 (conflict history)
('c0000001-0000-0000-0000-000000000001', 'cl000003-0000-0000-0000-000000000003', 'Past conflict - incompatible working styles', 'Admin'),

-- Noah cannot work for Client 7
('c0000004-0000-0000-0000-000000000004', 'cl000007-0000-0000-0000-000000000007', 'Client preference - previous negative experience', 'Consultant'),

-- Max cannot work for Client 14 (separate from his cat fear)
('c0000014-0000-0000-0000-000000000014', 'cl000014-0000-0000-0000-000000000014', 'Reliability issues reported', 'Admin');

-- ============================================
-- PREFERENCES (S2 scoring override)
-- ============================================

INSERT INTO preferences (source_entity_id, source_entity_type, target_entity_id, target_entity_type, is_starred, is_flagged, notes) VALUES
-- Client 1 prefers Liam (starred)
('cl000001-0000-0000-0000-000000000001', 'client', 'c0000002-0000-0000-0000-000000000002', 'cleaner', true, false, 'Excellent work, very reliable'),

-- Client 4 prefers Julia (starred)
('cl000004-0000-0000-0000-000000000004', 'client', 'c0000007-0000-0000-0000-000000000007', 'cleaner', true, false, 'Outstanding service'),

-- Client 9 prefers Sophie (flagged for priority)
('cl000009-0000-0000-0000-000000000009', 'client', 'c0000003-0000-0000-0000-000000000003', 'cleaner', false, true, 'Would like to work with again'),

-- Emma prefers working for Client 5
('c0000001-0000-0000-0000-000000000001', 'cleaner', 'cl000005-0000-0000-0000-000000000005', 'client', true, false, 'Nice location, pleasant client');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Count summary
DO $$
DECLARE
    cleaner_count INT;
    client_count INT;
    address_count INT;
BEGIN
    SELECT COUNT(*) INTO cleaner_count FROM cleaners;
    SELECT COUNT(*) INTO client_count FROM clients;
    SELECT COUNT(*) INTO address_count FROM addresses;
    
    RAISE NOTICE 'Seed data loaded successfully:';
    RAISE NOTICE '  - Cleaners: %', cleaner_count;
    RAISE NOTICE '  - Clients: %', client_count;
    RAISE NOTICE '  - Addresses: %', address_count;
    RAISE NOTICE '  - Cleaners with available hours: %', (SELECT COUNT(*) FROM cleaners WHERE available_hours > 0);
    RAISE NOTICE '  - Clients needing permanent help (>2hr gap): %', (SELECT COUNT(*) FROM clients WHERE (requested_hours_permanent - planned_hours_permanent) >= 2);
END $$;
