import { today } from "./today.js";

describe("formatted recollections of today", () => {
    it("returns the current coordinated universal time", () => {
        const response = today();
        const now = new Date();
        const expected = {
            gregorian: now.toISOString().split("T")[0],
        };
        assert.equal(response.status, 200);
        assert.equal(response.body.ok, true);
        assert.equal(response.body.dates.gregorian, expected.gregorian);
    });
});
