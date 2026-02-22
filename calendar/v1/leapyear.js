export function leapyear(path) {
  const parts = path.split("/");
  if (parts.length === 1) {
    return {
      status: 400,
      body: {
        ok: false,
        error: {
          code: "calendar_year_missing",
          message: "No year was provided",
          remediation: "Include a year with the request",
        },
      },
    };
  } else if (parts.length !== 2) {
    return {
      status: 400,
      body: {
        ok: false,
        error: {
          code: "calendar_path_unexpected",
          message: "Unexpected path information was provided",
          remediation: "Remove additional request details",
        },
      },
    };
  }
  if (!/^[+-]?\d+$/.test(parts[1])) {
    return {
      status: 400,
      body: {
        ok: false,
        error: {
          code: "calendar_year_invalid",
          message: "The provided year has an invalid format",
          remediation: "Use an integer",
        },
      },
    };
  }
  const year = parseInt(parts[1], 10);
  const leap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  return {
    status: 200,
    body: {
      ok: true,
      leapyear: leap,
    },
  };
}
