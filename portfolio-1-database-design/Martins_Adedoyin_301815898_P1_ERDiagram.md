# Airline Reservation System — ER diagram

```mermaid
erDiagram
    direction LR
    passenger {
        bigint passenger_id PK
        text full_name
        text email UK
        timestamptz created_at
    }
    flight {
        bigint flight_id PK
        text flight_number
        text origin
        text destination
        timestamptz departure_at
        timestamptz arrival_at
        integer capacity
    }
    reservation {
        bigint reservation_id PK
        bigint passenger_id FK
        bigint flight_id FK
        timestamptz booked_at
        text status
        text seat_number "Optional"
        numeric fare_amount
    }
    passenger ||--o{ reservation : "passenger_id"
    flight ||--o{ reservation : "flight_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Martins_Adedoyin_301815898_ERDiagram.png)
