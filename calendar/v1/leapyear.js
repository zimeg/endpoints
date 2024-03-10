import { error } from "./_errors.js";

export function leapyear(path) {
    const parts = path.split("/");
    if (parts.length === 1) {
        return error("calendar_year_missing");
    } else if (parts.length !== 2) {
        return error("calendar_path_unexpected");
    }
    if (!/^[+-]?\d+$/.test(parts[1])) {
        return error("calendar_year_invalid");
    }
    const year = parseInt(parts[1], 10);
    const leap = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    return {
        status: 200,
        body: {
            ok: true,
            leapyear: leap,
        },
    }
}
