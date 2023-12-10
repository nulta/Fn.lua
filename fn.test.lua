local fn = require("fn")

local testCount = 0
local subtestCount = 0
local failCount = 0

local function section(name)
    testCount = testCount + 1
    subtestCount = 0
    print(("[Test %d: '%s']"):format(testCount, name))
end

local function pass()
    subtestCount = subtestCount + 1
    print(("    [Test %d-%d] Passed!"):format(testCount, subtestCount))
end

local function fail(why)
    subtestCount = subtestCount + 1
    failCount = failCount + 1
    print(("    [Test %d-%d] FAIL!! (%s) (ln %d)"):format(testCount, subtestCount, why or "unknown", debug.getinfo(3, "l").currentline))
end

local function endTest()
    print("")
    print("=== Test Completed ===")
    if failCount > 0 then
        print(failCount .. " subtest(s) failed!")
    else
        print("All test passed! (^.^)")
    end
end

local function testEquals(a, b)
    if a == b then
        pass()
    else
        fail(("%s ~= %s"):format(tostring(a), tostring(b)))
    end
end


section "fn.counter and fn.range"

testEquals(fn:counter()(), 1)
testEquals(fn:range(10)(), 1)
testEquals(fn:counter():limit(100):count(), 100)
testEquals(fn:range(100):count(), 100)
testEquals(fn:counter():limit(100):sum(), 5050)
testEquals(fn:counter():limit(100):sum(), fn:range(100):sum())
testEquals(fn:counter():limit(10000):sum(), fn:range(10000):sum())


section "fn.range - edge case"

testEquals(fn:range(1):count(), 1)
testEquals(fn:range(1):sum(), 1)
testEquals(fn:range(0):count(), 0)
testEquals(fn:range(0):sum(), nil)
testEquals(fn:range(10, 10):count(), 1)
testEquals(fn:range(10, 10):sum(), 10)
testEquals(fn:range(-100):count(), 0)
testEquals(fn:range(-100):sum(), nil)
testEquals(fn:range(1000):sum(), fn:range(1, 1000):sum())
testEquals(fn:range(0, 1000, 100):sum(), fn:range(1, 10):sum() * 100)
testEquals(fn:range(100, 1, -1):sum(), fn:range(1, 100):sum())
testEquals(fn:range(1000, 0, -100):sum(), fn:range(1, 10):sum() * 100)
testEquals(fn:range(1000, 10, -100):sum(), fn:range(1000, 1, -100):sum())
testEquals(fn:range(1000, -1000, -1):sum(), 0)

section "Fn.Iterator:map()"
testEquals(
    fn:range(6)
        :map( fn:op("^", nil, 2) )
        :sum(),
    1+4+9+16+25+36
)

testEquals(
    fn:range(6)
        :map( fn:op("+", 10) )
        :sum(),
    11+12+13+14+15+16
)

testEquals(
    fn:range(6)
        :map( fn:op("-", 5, 3) )
        :map( fn:op("+", 1) )
        :sum(),
    3*6
)

testEquals(
    fn({10, 20, 20, 30, 10, 20, 30}):filter( fn:op("==", 10) ):count(),
    2
)

testEquals(
    fn({10, 20, 20, 30, 10, 20, 30}):unique():count(),
    3
)

testEquals(
    fn:range(4):map( fn:bind(string.rep, "*") ):concat("\n"),
    [[
*
**
***
****]]
)


section "fn:bind"
testEquals(fn:bind(math.min, 0)(123, -100), -100)
testEquals(fn:bind(math.min, 0)(123, 100), 0)
testEquals(fn:bind(math.min, 0, -10, -20)(100), -20)
testEquals(fn:bind(math.min, 0, -10, -20)(-100), -100)
testEquals(fn:bind(math.min, 0, -10, -20)(200, 300, -100), -100)
testEquals(fn:bind(math.min, 0, -10, -20)(), -20)
testEquals(fn:bind(math.min, 0)(), 0)

endTest()