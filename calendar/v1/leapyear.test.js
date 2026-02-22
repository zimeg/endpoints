import { describe, it } from "node:test";
import assert from "node:assert";
import { leapyear } from "./leapyear.js";

describe("extra days in a year are counted", () => {
  it("returns true for proper leap years", () => {
    const years = ["-0004", "0000", "4", "+2000", "2024", "12024"];
    for (const year of years) {
      const response = leapyear(year);
      assert.equal(response.status, 200);
      assert.equal(response.body.ok, true);
      assert.equal(response.body.leapyear, true);
    }
  });

  it("returns false for all other years", () => {
    const years = ["-0003", "0001", "1900", "2025", "+2182"];
    for (const year of years) {
      const response = leapyear(year);
      assert.equal(response.status, 200);
      assert.equal(response.body.ok, true);
      assert.equal(response.body.leapyear, false);
    }
  });
});

describe("erroneous requests are handled well", () => {
  it("fails when a calendar year is missing", () => {
    const response = leapyear(undefined);
    assert.equal(response.status, 400);
    assert.equal(response.body.ok, false);
    assert.equal(response.body.error?.code, "calendar_year_missing");
  });

  it("fails when years are not numeric", () => {
    const years = ["now", "year"];
    for (const year of years) {
      const response = leapyear(year);
      assert.equal(response.status, 400);
      assert.equal(response.body.ok, false);
      assert.equal(response.body.error?.code, "calendar_year_invalid");
    }
  });

});
