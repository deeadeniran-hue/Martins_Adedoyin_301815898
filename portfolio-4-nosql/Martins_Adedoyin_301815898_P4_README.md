# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection reservation_events for reservation_created and seat_assigned events. These are fictional event examples based on reservation, passenger, flight.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related passenger, flight details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "reservation_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "reservation",
        "key": {
            "reservation_id": 201
        },
        "snapshot": {
            "reservation_id": 201,
            "passenger_id": 1,
            "flight_id": 101,
            "booked_at": "2026-04-01T12:30:00Z",
            "status": "confirmed",
            "seat_number": "12A",
            "fare_amount": 189.5
        }
    },
    "embedded": {
        "passenger": [
            {
                "key": {
                    "passenger_id": 1
                },
                "snapshot": {
                    "passenger_id": 1,
                    "full_name": "Avery Chen",
                    "email": "avery.chen@example.test",
                    "created_at": "2026-01-10T09:00:00Z"
                },
                "via": [
                    "reservation.passenger_id → passenger"
                ]
            }
        ],
        "flight": [
            {
                "key": {
                    "flight_id": 101
                },
                "snapshot": {
                    "flight_id": 101,
                    "flight_number": "AX204",
                    "origin": "SEA",
                    "destination": "SFO",
                    "departure_at": "2026-05-10T15:00:00Z",
                    "arrival_at": "2026-05-10T17:15:00Z",
                    "capacity": 120
                },
                "via": [
                    "reservation.flight_id → flight"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("reservation_events").find({"eventType":"reservation_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "reservation_id": 201
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("reservation_events").find({"source.key.reservation_id":201}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "reservation_id": 201
    }
  },
  {
    "_id": "event_000002",
    "eventType": "seat_assigned",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "reservation_id": 201
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("reservation_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "reservation_id": 201
    }
  },
  {
    "_id": "event_000002",
    "eventType": "seat_assigned",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "reservation_id": 201
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("reservation_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| reservation_created | 1 |
| seat_assigned | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Martins_Adedoyin_301815898_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Martins_Adedoyin_301815898_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

