export function today() {
  const now = new Date();
  const gregorian = now.toISOString().split("T")[0];
  return {
    status: 200,
    body: {
      ok: true,
      dates: {
        gregorian,
      },
    },
  };
}
