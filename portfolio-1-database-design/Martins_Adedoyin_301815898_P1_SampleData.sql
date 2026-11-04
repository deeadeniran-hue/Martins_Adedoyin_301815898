-- Fictional sample records for Airline Reservation System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at") VALUES (1, 'Avery Chen', 'avery.chen@example.test', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity") VALUES (101, 'AX204', 'SEA', 'SFO', '2026-05-10T15:00:00Z', '2026-05-10T17:15:00Z', 120);
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount") VALUES (201, 1, 101, '2026-04-01T12:30:00Z', 'confirmed', '12A', 189.5);
COMMIT;
