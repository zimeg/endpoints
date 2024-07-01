import { epoch } from "./epoch.js";

describe("respond in times of the computer", () => {
  it("returns the current epoch time in seconds", () => {
    const response = epoch();
    const now = new Date();
    const expected = {
      epoch: Date.parse(now) / 1000,
    };
    assert.equal(response.status, 200);
    assert.equal(response.body.ok, true);
    assert.equal(response.body.epoch, expected.epoch);
  });
});
