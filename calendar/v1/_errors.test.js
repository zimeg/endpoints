import { error } from "./_errors.js";

describe("response shapes indicate errors", () => {
  it("returns errors with an error status", () => {
    const response = error("example_code");
    assert.equal(response.status, 400);
    assert.equal(response.body.ok, false);
  });
});

describe("expected codes provide information", () => {
  it("includes a message and remediation", () => {
    const errors = [
      "calendar_path_unexpected",
      "calendar_year_invalid",
      "calendar_year_missing",
    ];
    for (const code of errors) {
      const response = error(code);
      assert.equal(response.status, 400);
      assert.equal(response.body.ok, false);
      assert.equal(response.body.error.code, code);
      assert.equal(typeof response.body.error.message, "string");
      assert.equal(typeof response.body.error.remediation, "string");
    }
  });
});
