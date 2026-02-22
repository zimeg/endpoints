import { createServer } from "node:http";
import { handler } from "./calendar/v1/index.js";

const port = process.env.PORT || 8083;
const prefix = "/v1/calendar/";

const server = createServer((req, res) => {
  if (!req.url.startsWith(prefix)) {
    res.writeHead(404, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: false, error: { code: "not_found" } }));
    return;
  }
  const path = req.url.slice(prefix.length);
  const event = {
    httpMethod: req.method,
    path: req.url,
    pathParameters: { path },
  };
  const result = handler(event, undefined);
  res.writeHead(result.statusCode, result.headers);
  res.end(result.body);
});

server.listen(port, () => {
  console.log(`endpoints listening on port ${port}`);
});
