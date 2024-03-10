# 📆 calendar

Measurements of dates and days for the present moment.

## Endpoints

Various methods provide different information about different times:

- [`GET /leapyear`](#get-leapyear) - determine if a leap day exists
- [`GET /today`](#get-today) - recall the current calendar date

### `GET /leapyear`

Determine if a [leap day][leapyear] exists in the provided year according to the
[proleptic Gregorian calendar][gregorian].

```sh
$ curl https://api.o526.net/v1/calendar/leapyear/:year
```

#### Request parameters

##### `:year`

Integer. The calendar year to check for a leap day.

#### Expected output

##### `ok`

Boolean. If the response completed with success. [Errors cause `false`][errors].

##### `leapyear`

Boolean. If the provided calendar year contains a leap day.

#### Example usage

For the year 2024 this endpoint should return the following response:

```sh
$ curl https://api.o526.net/v1/calendar/leapyear/2024
```

```json
{
    "ok": true,
    "leapyear": true
}
```

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

## Errors

Invalid or unexpected requests can cause responses to return with an error:

```json
{
    "ok": false,
    "error": {
        "code": "calendar_error_code",
        "message": "Something strange happened",
        "remediation": "Try changing this"
    }
}
```

### Expected output

#### `ok`

Boolean. If the response completed with success. With errors this is `false`.

#### `error.code`

String. System representation of the error value. [Possible codes are listed
below][error-codes].

#### `error.message`

String. Meaningful cause for returning the error.

#### `error.remediation`

String. Possible suggestion to prevent the error.

### Error codes

#### `calendar_path_unexpected`

Unexpected path information was provided. Remove additional request details.

#### `calendar_year_invalid`

The provided year has an invalid format. Use an integer.

#### `calendar_year_missing`

No year was provided. Include a year with the request.

[8601]: https://en.wikipedia.org/wiki/ISO_8601
[error-codes]: #error-codes
[errors]: #errors
[gregorian]: https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar
[leapyear]: https://en.wikipedia.org/wiki/Leap_year
[utc]: https://en.wikipedia.org/wiki/Coordinated_Universal_Time
