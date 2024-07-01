export function epoch() {
  const now = new Date();
  const epoch = Date.parse(now) / 1000;
  return {
    status: 200,
    body: {
      ok: true,
      epoch,
    },
  };
}
