# Airline Reservation System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| passenger_id | reservation records (list) |
| --- | --- |
| 1 | [201] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| reservation.reservation_id | reservation.passenger_id | reservation.flight_id | reservation.status | passenger.passenger_id | passenger.full_name | flight.flight_id | flight.flight_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | 1 | 101 | confirmed | 1 | Avery Chen | 101 | AX204 |

Key: reservation_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## reservation_example

| reservation.reservation_id | reservation.passenger_id | reservation.flight_id | reservation.status | passenger.passenger_id | passenger.full_name | flight.flight_id | flight.flight_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | 1 | 101 | confirmed | 1 | Avery Chen | 101 | AX204 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## passenger

| passenger_id | full_name | email | created_at |
| --- | --- | --- | --- |
| 1 | Avery Chen | avery.chen@example.test | 2026-01-10T09:00:00+00:00 |

## flight

| flight_id | flight_number | origin | destination | departure_at | arrival_at | capacity |
| --- | --- | --- | --- | --- | --- | --- |
| 101 | AX204 | SEA | SFO | 2026-05-10T15:00:00+00:00 | 2026-05-10T17:15:00+00:00 | 120 |

## reservation

| reservation_id | passenger_id | flight_id | booked_at | status | seat_number | fare_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 201 | 1 | 101 | 2026-04-01T12:30:00+00:00 | confirmed | 12A | 189.5 |

## Dependencies

- passenger: (passenger_id) → full_name, email, created_at
- flight: (flight_id) → flight_number, origin, destination, departure_at, arrival_at, capacity
- reservation: (reservation_id) → passenger_id, flight_id, booked_at, status, seat_number, fare_amount

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
