local fn = require("fn")

local testCount = 0
local failCount = 0
local function pass()
    testCount = testCount + 1
    print(("[Test %d] Passed!"):format(testCount))
end

local function fail(why)
    testCount = testCount + 1
    failCount = failCount + 1
    print(("[Test %d] FAIL!! (%s)"):format(testCount, why or "unknown"))
    print("", debug.traceback())
end

local function endTest()
    print("")
    print("=== Test Completed ===")
    if failCount > 0 then
        print(failCount .. " test(s) failed!")
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


testEquals(fn:counter()(), 1)
testEquals(fn:range(10)(), 1)

testEquals(fn:counter():limit(10):count(), 10)
testEquals(fn:range(10):count(), 10)

testEquals(fn:range(10):sum(), 1+2+3+4+5+6+7+8+9+10)

testEquals(
    fn:range(6)
        :map( fn:op(nil, "^", 2) )
        :sum(),
    1+4+9+16+25+36
)

testEquals(
    fn:range(6)
        :map( fn:op(10, "+", nil) )
        :sum(),
    11+12+13+14+15+16
)

testEquals(
    fn:range(6)
        :map( fn:op(5, "-", 3) )
        :map( fn:op(1, "+", nil) )
        :sum(),
    3*6
)

testEquals(
    fn({10,23,42,55,10})
)

endTest()