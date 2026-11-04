# Airline Reservation System — database design

My case study records passenger, flight, reservation.

## Users

- Passengers searching for flights and managing their reservations
- Reservation agents reviewing bookings and seat assignments

## Main operations

- Search scheduled flights by origin and departure time
- Create and confirm a passenger reservation
- Report confirmed reservation counts by flight

## Entities

| Entity | Information stored |
| --- | --- |
| passenger | Stores a passenger's identifying contact details. |
| flight | Stores a scheduled flight instance and its route, times, and seat capacity. |
| reservation | Records a passenger's booking for one scheduled flight. |

## passenger

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| passenger_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## flight

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| flight_id | BIGINT | PK | Yes |
| flight_number | TEXT |  | Yes |
| origin | TEXT |  | Yes |
| destination | TEXT |  | Yes |
| departure_at | TIMESTAMPTZ |  | Yes |
| arrival_at | TIMESTAMPTZ |  | Yes |
| capacity | INTEGER |  | Yes |
- Unique key: (flight_number, departure_at).

## reservation

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reservation_id | BIGINT | PK | Yes |
| passenger_id | BIGINT | FK | Yes |
| flight_id | BIGINT | FK | Yes |
| booked_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| seat_number | TEXT |  | No |
| fare_amount | NUMERIC(18,2) |  | Yes |
- passenger_id → passenger.passenger_id
- flight_id → flight.flight_id

## Relationships and business rules

- Each passenger email identifies at most one passenger.
- A flight number and departure timestamp identify one scheduled flight instance.
- A flight's arrival time must be later than its departure time.
- Flight capacity must be greater than zero.
- Every reservation references an existing passenger through passenger_id.
- Every reservation references an existing flight through flight_id.
- A partial unique constraint on flight_id and seat_number applies only when status is confirmed and seat_number is not null, preventing two confirmed reservations from occupying the same seat on one flight.
- Reservation status must be one of held, confirmed, or cancelled.

## Assumptions

- Each Flight row represents one scheduled departure; a flight number may recur at different departure times.
- Each Reservation references exactly one Passenger and one Flight. A seat is optional until assigned.
- Only confirmed reservations with a non-null seat number occupy a seat; uniqueness applies per flight.
- Departure and arrival timestamps use the airport's local time zone; time-zone conversion is outside this exercise.
- Worked normalization example: use Reservation, which references Passenger and Flight, as the root. Passenger contact data belongs to Passenger, schedule and capacity data belongs to Flight, and booking time, status, seat, and fare belong to Reservation. Do not copy Passenger or Flight attributes into Reservation.
- Separate benchmark plan: generate 20000 synthetic Reservation rows with varied statuses, then run the same status filter before and after adding a B-tree index on Reservation.status. Record each query plan and elapsed time under identical conditions, and verify both runs return the same rows.

