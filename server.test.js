import { describe, it } from "node:test";
import assert from "node:assert";
import { route } from "./server.js";

describe("known paths have an okay return", () => {
  it("returns a true ok for epoch", () => {
    const response = route("/v1/calendar/epoch");
    assert.equal(response.status, 200);
    assert.equal(response.body.ok, true);
    assert.ok(response.body.epoch > 0);
  });

  it("returns a true ok for leapyear", () => {
    const response = route("/v1/calendar/leapyear/2024");
    assert.equal(response.status, 200);
    assert.equal(response.body.ok, true);
    assert.equal(response.body.leapyear, true);
  });

  it("returns a true ok for today", () => {
    const response = route("/v1/calendar/today");
    assert.equal(response.status, 200);
    assert.equal(response.body.ok, true);
    assert.ok(response.body.offset > 0);
  });
});

describe("unknown paths return errors", () => {
  it("returns not found for outside paths", () => {
    const response = route("/v1/outside");
    assert.equal(response.status, 404);
    assert.equal(response.body.ok, false);
  });
});
