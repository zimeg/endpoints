export function leapyear(year) {
  if (!year) {
    return {
      status: 400,
      body: {
        ok: false,
        error: {
          code: "calendar_year_missing",
          message: "No year was provided",
          remediation: "Include a year with request path",
        },
      },
    };
  }
  if (!/^[+-]?\d+$/.test(year)) {
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
  const num = parseInt(year, 10);
  const leap = (num % 4 == 0 && num % 100 != 0) || num % 400 == 0;
  return {
    status: 200,
    body: {
      ok: true,
      leapyear: leap,
    },
  };
}
