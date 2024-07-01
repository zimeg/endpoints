const errors = {
  calendar_path_unexpected: {
    message: "Unexpected path information was provided",
    remediation: "Remove additional request details",
  },
  calendar_year_invalid: {
    message: "The provided year has an invalid format",
    remediation: "Use an integer",
  },
  calendar_year_missing: {
    message: "No year was provided",
    remediation: "Include a year with the request",
  },
};

export function error(code) {
  const error = errors[code] ?? {};
  error.code = code;
  return {
    status: 400,
    body: {
      ok: false,
      error,
    },
  };
}
