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
  return {
    status: 200,
    body: {
      ok: true,
      offset: Math.trunc(offset),
      dates: {
        gregorian,
      },
    },
  };
}
