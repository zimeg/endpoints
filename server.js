import { createServer } from "node:http";
import { epoch } from "./calendar/v1/epoch.js";
import { leapyear } from "./calendar/v1/leapyear.js";
import { today } from "./calendar/v1/today.js";

const port = process.env.PORT || 8083;

export function route(url) {
  if (url === "/v1/calendar/epoch") {
    return epoch();
  } else if (url.startsWith("/v1/calendar/leapyear")) {
    return leapyear(url.slice("/v1/calendar/".length));
  } else if (url === "/v1/calendar/today") {
    return today();
  }
  return {
    status: 404,
    body: {
      ok: false,
      error: {
        code: "method_not_found",
        message: `No method found for the provided path: ${url}`,
      },
    },
  };
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const server = createServer((req, res) => {
    const response = route(req.url);
    res.writeHead(response.status, {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/json",
    });
    res.end(JSON.stringify(response.body));
  });

  server.listen(port, () => {
    console.log(`endpoints listening on port ${port}`);
  });
}
