-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. passenger pk. Expected: pk_passenger, SQLSTATE 23505.
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at")
VALUES (1, 'Morgan Lee', 'morgan.lee@example.test', '2026-02-01T10:00:00Z');

-- 2. passenger email unique. Expected: uq_passenger_0, SQLSTATE 23505.
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at")
VALUES (2, 'Morgan Lee', 'avery.chen@example.test', '2026-02-01T10:00:00Z');

-- 3. passenger id required. Expected: passenger_id, SQLSTATE 23502.
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at")
VALUES (NULL, 'Morgan Lee', 'morgan.lee@example.test', '2026-02-01T10:00:00Z');

-- 4. passenger name required. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at")
VALUES (2, NULL, 'morgan.lee@example.test', '2026-02-01T10:00:00Z');

-- 5. passenger email required. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at")
VALUES (2, 'Morgan Lee', NULL, '2026-02-01T10:00:00Z');

-- 6. passenger created required. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."passenger" ("passenger_id", "full_name", "email", "created_at")
VALUES (2, 'Morgan Lee', 'morgan.lee@example.test', NULL);

-- 7. flight pk. Expected: pk_flight, SQLSTATE 23505.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (101, 'AX205', 'SEA', 'LAX', '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', 100);

-- 8. flight schedule unique. Expected: uq_flight_0, SQLSTATE 23505.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX204', 'PDX', 'SFO', '2026-05-10T15:00:00Z', '2026-05-10T18:00:00Z', 100);

-- 9. flight id required. Expected: flight_id, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (NULL, 'AX205', 'SEA', 'LAX', '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', 100);

-- 10. flight number required. Expected: flight_number, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, NULL, 'SEA', 'LAX', '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', 100);

-- 11. flight origin required. Expected: origin, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', NULL, 'LAX', '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', 100);

-- 12. flight destination required. Expected: destination, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', 'SEA', NULL, '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', 100);

-- 13. flight departure required. Expected: departure_at, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', 'SEA', 'LAX', NULL, '2026-05-11T17:15:00Z', 100);

-- 14. flight arrival required. Expected: arrival_at, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', 'SEA', 'LAX', '2026-05-11T15:00:00Z', NULL, 100);

-- 15. flight capacity required. Expected: capacity, SQLSTATE 23502.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', 'SEA', 'LAX', '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', NULL);

-- 16. reservation pk. Expected: pk_reservation, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (201, 1, 101, '2026-04-02T12:30:00Z', 'held', NULL, 150);

-- 17. reservation passenger fk. Expected: fk_reservation_0, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 999, 101, '2026-04-02T12:30:00Z', 'held', NULL, 150);

-- 18. reservation flight fk. Expected: fk_reservation_1, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, 999, '2026-04-02T12:30:00Z', 'held', NULL, 150);

-- 19. reservation id required. Expected: reservation_id, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (NULL, 1, 101, '2026-04-02T12:30:00Z', 'held', NULL, 150);

-- 20. reservation passenger required. Expected: passenger_id, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, NULL, 101, '2026-04-02T12:30:00Z', 'held', NULL, 150);

-- 21. reservation flight required. Expected: flight_id, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, NULL, '2026-04-02T12:30:00Z', 'held', NULL, 150);

-- 22. reservation booked required. Expected: booked_at, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, 101, NULL, 'held', NULL, 150);

-- 23. reservation status required. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, 101, '2026-04-02T12:30:00Z', NULL, NULL, 150);

-- 24. reservation fare required. Expected: fare_amount, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, 101, '2026-04-02T12:30:00Z', 'held', NULL, NULL);

-- 25. flight time order violation. Expected: flight_time_order, SQLSTATE 23514.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', 'SEA', 'LAX', '2026-05-11T17:15:00Z', '2026-05-11T15:00:00Z', 100);

-- 26. flight capacity violation. Expected: flight_capacity_positive, SQLSTATE 23514.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "origin", "destination", "departure_at", "arrival_at", "capacity")
VALUES (102, 'AX205', 'SEA', 'LAX', '2026-05-11T15:00:00Z', '2026-05-11T17:15:00Z', 0);

-- 27. confirmed seat duplicate. Expected: confirmed_seat_unique, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, 101, '2026-04-02T12:30:00Z', 'confirmed', '12A', 150);

-- 28. reservation status violation. Expected: reservation_status_check, SQLSTATE 23514.
INSERT INTO portfolio."reservation" ("reservation_id", "passenger_id", "flight_id", "booked_at", "status", "seat_number", "fare_amount")
VALUES (202, 1, 101, '2026-04-02T12:30:00Z', 'pending', NULL, 150);
