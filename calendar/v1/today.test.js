import { describe, it } from "node:test";
import assert from "node:assert";
import { today } from "./today.js";

describe("formatted recollections of today", () => {
  it("returns the current coordinated universal time", () => {
    const response = today();
    const now = new Date();
    assert.equal(response.status, 200);
    assert.equal(response.body.ok, true);
    assert.equal(
      response.body.dates.gregorian,
      now.toISOString().split("T")[0],
    );
  });

  it("returns the current offset for this calendar", () => {
    const response = today();
    const now = new Date();
    assert.equal(
      new Date(now.getUTCFullYear(), 0, response.body.offset)
        .toISOString()
        .split("T")[0],
      now.toISOString().split("T")[0],
    );
  });

  it("returns the current date according to quintus", () => {
    const response = today();
    const now = new Date();
    const [year, month, day] = response.body.dates.quintus.split("-");
    assert.equal(year, now.getUTCFullYear());
    assert.equal((+month - 1) * 30 + +day, response.body.offset);
  });
});
