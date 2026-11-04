-- Show related reservation, passenger, flight records (up to 20).
SELECT t0."reservation_id" AS "reservation_reservation_id",
       t0."booked_at" AS "reservation_booked_at",
       t1."passenger_id" AS "passenger_passenger_id",
       t1."full_name" AS "passenger_full_name",
       t2."flight_id" AS "flight_flight_id",
       t2."flight_number" AS "flight_flight_number"
FROM portfolio."reservation" t0
JOIN portfolio."passenger" t1 ON t0."passenger_id" = t1."passenger_id"
JOIN portfolio."flight" t2 ON t0."flight_id" = t2."flight_id"
ORDER BY t0."reservation_id", t1."passenger_id", t2."flight_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."reservation_id" AS "reservation_reservation_id",
       t0."booked_at" AS "reservation_booked_at",
       t1."passenger_id" AS "passenger_passenger_id",
       t1."full_name" AS "passenger_full_name",
       t2."flight_id" AS "flight_flight_id",
       t2."flight_number" AS "flight_flight_number"
FROM portfolio."reservation" t0
JOIN portfolio."passenger" t1 ON t0."passenger_id" = t1."passenger_id"
JOIN portfolio."flight" t2 ON t0."flight_id" = t2."flight_id"
ORDER BY t0."reservation_id", t1."passenger_id", t2."flight_id"
LIMIT 20;

-- Find flight records where flight_number matches "AX204" (up to 20).
SELECT * FROM portfolio."flight"
WHERE "flight_number" IS NOT DISTINCT FROM 'AX204'
ORDER BY "flight_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."flight"
WHERE "flight_number" IS NOT DISTINCT FROM 'AX204'
ORDER BY "flight_id"
LIMIT 20;

-- Count reservation records for each passenger_id (up to 20 groups).
SELECT "passenger_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "passenger_id"
ORDER BY record_count DESC, "passenger_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "passenger_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "passenger_id"
ORDER BY record_count DESC, "passenger_id" NULLS LAST
LIMIT 20;
