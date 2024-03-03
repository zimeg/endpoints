import { handler } from "./index.js";

describe("expected object for lambda invocations", () => {
    it("returns required values for any response", () => {
        const event = {
            httpMethod: "GET",
            path: "/v1/calendar/today",
            pathParameters: {
                path: "today",
            },
        };
        const response = handler(event, undefined);
        assert.equal(typeof response.statusCode, "number");
        assert.equal(response.headers["Access-Control-Allow-Origin"], "*");
        assert.equal(response.headers["Content-Type"], "application/json");
        assert.equal(typeof response.body, "string");
    });

    it("returns meaningful values in the response body", () => {
        const event = {
            httpMethod: "GET",
            path: "/v1/calendar/today",
            pathParameters: {
                path: "today",
            },
        };
        const response = handler(event, undefined);
        const values = JSON.parse(response.body);
        assert.equal(typeof values.ok, "boolean");
    });
});

describe("known paths have an okay return", () => {
    it("signifies unfound methods for unknown paths", () => {
        const event = {
            httpMethod: "GET",
            path: "/v1/calendar/unknown",
            pathParameters: {
                path: "unknown",
            },
        };
        const response = handler(event, undefined);
        const values = JSON.parse(response.body);
        assert.equal(response.statusCode, 404);
        assert.equal(values.ok, false);
        assert.equal(values.error.code, "method_not_found");
        assert.equal(
            values.error.message,
            "The provided path has no GET method: /v1/calendar/unknown",
        );
    });
});
