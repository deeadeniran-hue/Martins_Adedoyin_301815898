-- Airline Reservation System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."passenger" (
  "passenger_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_passenger" PRIMARY KEY ("passenger_id"),
  CONSTRAINT "uq_passenger_0" UNIQUE ("email")
);
CREATE TABLE portfolio."flight" (
  "flight_id" bigint NOT NULL,
  "flight_number" text NOT NULL,
  "origin" text NOT NULL,
  "destination" text NOT NULL,
  "departure_at" timestamptz NOT NULL,
  "arrival_at" timestamptz NOT NULL,
  "capacity" bigint NOT NULL,
  CONSTRAINT "pk_flight" PRIMARY KEY ("flight_id"),
  CONSTRAINT "uq_flight_0" UNIQUE ("flight_number", "departure_at")
);
CREATE TABLE portfolio."reservation" (
  "reservation_id" bigint NOT NULL,
  "passenger_id" bigint NOT NULL,
  "flight_id" bigint NOT NULL,
  "booked_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "seat_number" text,
  "fare_amount" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_reservation" PRIMARY KEY ("reservation_id")
);
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_0" FOREIGN KEY ("passenger_id") REFERENCES portfolio."passenger" ("passenger_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_1" FOREIGN KEY ("flight_id") REFERENCES portfolio."flight" ("flight_id");
ALTER TABLE portfolio."flight" ADD CONSTRAINT "flight_time_order" CHECK ("arrival_at" > "departure_at");
ALTER TABLE portfolio."flight" ADD CONSTRAINT "flight_capacity_positive" CHECK ("capacity" > 0);
CREATE UNIQUE INDEX "confirmed_seat_unique" ON portfolio."reservation" ("flight_id", "seat_number") WHERE (("status" = 'confirmed') AND ("seat_number" IS NOT NULL));
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "reservation_status_check" CHECK (("status" = 'held') OR ("status" = 'confirmed') OR ("status" = 'cancelled'));
COMMIT;
