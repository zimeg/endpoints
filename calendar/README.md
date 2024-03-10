# 📆 calendar

Measurements of dates and days for the present moment.

## Endpoints

Various methods provide different information about different times:

- [`GET /today`](#get-today) - recall the current calendar date

### `GET /today`

Recall the current calendar date, aligned to [coordinated universal time][utc]
(UTC).

```sh
$ curl https://api.o526.net/v1/calendar/today
```

#### Expected output

##### `ok`

Boolean. If the response completed with success. Tends to be `true`.

##### `dates.gregorian`

String. The date according to the [proleptic Gregorian calendar][gregorian] in
[ISO 8601][8601] format.

#### Example usage

On the 305th day of 2024 this endpoint should return the following response:

```sh
$ curl https://api.o526.net/v1/calendar/today
```

```json
{
    "ok": true,
    "dates": {
        "gregorian": "2024-10-31"
    }
}
```

[8601]: https://en.wikipedia.org/wiki/ISO_8601
[gregorian]: https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar
[utc]: https://en.wikipedia.org/wiki/Coordinated_Universal_Time
