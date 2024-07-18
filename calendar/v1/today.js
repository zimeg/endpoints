function quintal(now, offset) {
  const year = now.getUTCFullYear();
  const month = Math.ceil(offset / 30)
    .toString()
    .padStart(2, "0");
  const day = (offset - (month - 1) * 30).toString().padStart(2, "0");
  return year + "-" + month + "-" + day;
}

export function today() {
  const now = new Date();
  const start = Date.UTC(now.getFullYear(), 0, 0);
  const utc = Date.UTC(
    now.getUTCFullYear(),
    now.getUTCMonth(),
    now.getUTCDate(),
  );
  const offset = (utc - start) / 24 / 60 / 60 / 1000;
  const gregorian = now.toISOString().split("T")[0];
  const quintus = quintal(now, offset);
  return {
    status: 200,
    body: {
      ok: true,
      offset: Math.trunc(offset),
      dates: {
        gregorian,
        quintus,
      },
    },
  };
}
