const assert = require("assert");

describe("Project Phoenix", () => {
    it("should perform a basic sanity check", () => {
        assert.strictEqual(1 + 1, 2);
    });

    it("should verify string equality", () => {
        assert.strictEqual("Phoenix", "Phoenix");
    });

    it("should verify array length", () => {
        const arr = [1, 2, 3];
        assert.strictEqual(arr.length, 3);
    });

    it("should verify object properties", () => {
        const app = {
            name: "Phoenix",
            version: "1.0.0"
        };

        assert.strictEqual(app.name, "Phoenix");
        assert.strictEqual(app.version, "1.0.0");
    });
});