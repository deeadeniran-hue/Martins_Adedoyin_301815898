# Airline Reservation System — SQL queries

## 1. Show related reservation, passenger, flight records (up to 20).

```sql
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
```

| reservation_reservation_id | reservation_booked_at | passenger_passenger_id | passenger_full_name | flight_flight_id | flight_flight_number |
| --- | --- | --- | --- | --- | --- |
| 201 | 2026-04-01T12:30:00+00:00 | 1 | Avery Chen | 101 | AX204 |

## 2. Find flight records where flight_number matches "AX204" (up to 20).

```sql
SELECT * FROM portfolio."flight"
WHERE "flight_number" IS NOT DISTINCT FROM 'AX204'
ORDER BY "flight_id"
LIMIT 20;
```

| flight_id | flight_number | origin | destination | departure_at | arrival_at | capacity |
| --- | --- | --- | --- | --- | --- | --- |
| 101 | AX204 | SEA | SFO | 2026-05-10T15:00:00+00:00 | 2026-05-10T17:15:00+00:00 | 120 |

## 3. Count reservation records for each passenger_id (up to 20 groups).

```sql
SELECT "passenger_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "passenger_id"
ORDER BY record_count DESC, "passenger_id" NULLS LAST
LIMIT 20;
```

| passenger_id | record_count |
| --- | --- |
| 1 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.186 | 2.208, 1.186, 1.172 | Sort → Seq Scan | 131 |
| After index | 0.199 | 0.223, 0.198, 0.199 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.186 ms to 0.199 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.166..2.169 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.025..2.116 rows=20 loops=1)
Planning Time: 0.56 ms
Execution Time: 2.208 ms
```

### Before index, run 2

```text
Sort (actual time=1.156..1.158 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.018..1.119 rows=20 loops=1)
Planning Time: 0.405 ms
Execution Time: 1.186 ms
```

### Before index, run 3

```text
Sort (actual time=1.14..1.142 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.031..1.105 rows=20 loops=1)
Planning Time: 0.404 ms
Execution Time: 1.172 ms
```

### After index, run 1

```text
Sort (actual time=0.17..0.172 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.03..0.131 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.663 ms
Execution Time: 0.223 ms
```

### After index, run 2

```text
Sort (actual time=0.148..0.15 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.032..0.11 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.018 rows=20 loops=1)
Planning Time: 0.632 ms
Execution Time: 0.198 ms
```

### After index, run 3

```text
Sort (actual time=0.148..0.149 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.031..0.111 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.607 ms
Execution Time: 0.199 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Martins_Adedoyin_301815898_P2_Queries.sql, then Martins_Adedoyin_301815898_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Martins_Adedoyin_301815898_P2_QueryResults.png) · [Index comparison](screenshots/Martins_Adedoyin_301815898_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

