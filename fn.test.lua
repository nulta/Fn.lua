local fn = require("fn")

local USE_COLOR = pcall(function() require("pretty-print") end)
local COL_RED = USE_COLOR and "\27[91m" or ""
local COL_GREEN = USE_COLOR and "\27[92m" or ""
local COL_CYAN = USE_COLOR and "\27[96m" or ""
local COL_RESET = USE_COLOR and "\27[0m" or ""
local testCount = 0
local subtestCount = 0
local failCount = 0

local function section(name)
    testCount = testCount + 1
    subtestCount = 0
    print("")
    print(COL_CYAN .. ("[Test %d: '%s']"):format(testCount, name) .. COL_RESET)
end

local function test(name)
    print(("  %s:"):format(name))
end

local function pass()
    subtestCount = subtestCount + 1
    print(("    [Test %d-%d] %sPassed!%s"):format(testCount, subtestCount, COL_GREEN, COL_RESET))
end

local function fail(why)
    subtestCount = subtestCount + 1
    failCount = failCount + 1
    print(("    [Test %d-%d] %sFAILED: %s (ln %d)%s"):format(testCount, subtestCount, COL_RED, why or "unknown", debug.getinfo(3, "l").currentline, COL_RESET))
end

local function completeAllTest()
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
        return pass()
    else
        return fail(("%s ~= %s"):format(tostring(a), tostring(b)))
    end
end

local function testTrue(cond)
    if cond == true then
        return pass()
    else
        return fail(("cond ~= true (got %s)"):format(tostring(cond)))
    end
end

local function testTable(tbl1, tbl2)
    local diffs = {}

    for k, _ in pairs(tbl1) do
        if tbl1[k] ~= tbl2[k] then
            diffs[k] = {tostring(tbl1[k]), tostring(tbl2[k])}
        end
    end

    for k, _ in pairs(tbl2) do
        if tbl1[k] ~= tbl2[k] then
            diffs[k] = {tostring(tbl1[k]), tostring(tbl2[k])}
        end
    end

    if not next(diffs) then
        return pass()
    else
        fail("table test failed")
        print("      [Table Diff]")
        for k, v in pairs(diffs) do
            print("      " .. ("[%s] = { %s , %s }"):format(tostring(k), v[1], v[2]))
        end
        return
    end
end

-- Test --
do
    section "fn:bind()"; do
        test "Examples"
        testTrue(fn:bind(math.max, 100)(2, 55, 7) == 100)
        testTrue(fn:bind(table.pack, 1, 2)(3, nil)[4] == nil)

        test "no additional args"
        testEquals(fn:bind(math.max, 0)(), 0)
        testEquals(fn:bind(math.max, 0, 1, 2)(), 2)
        testEquals(fn:bind(math.max, 2, 1, 0)(), 2)
        testEquals(fn:bind(math.max, 2, 1, 0, 10, 20, 30, 100, 200, 300, -1, -2, -3)(), 300)
        testTable(fn:bind(table.pack, "hello", "HELLO", "world")(), {"hello","HELLO","world",n=3})
        testEquals(fn:bind(table.concat, {"hello","HELLO","world"})(), "helloHELLOworld")

        test "non-nil args, additional args"
        testEquals(fn:bind(math.max, 0)(1), 1)
        testEquals(fn:bind(math.max, 0, 1, 2)(3, -1, -2), 3)
        testEquals(fn:bind(math.max, 0, 1, 2)(3, 4, 5), 5)
        testEquals(fn:bind(table.concat, {"hello","HELLO","world"})(" "), "hello HELLO world")
        testEquals(-fn:bind(setmetatable, {x = -10})({__unm = function(t) return t.x end}), -10)
        testEquals(
            fn:bind(fn:bind(math.max, 2, 1, 0), 20, 30, 40)(11, 22, 50),
            50
        )
        testEquals(
            fn:bind(fn:bind(math.max, 30, 20, 40), 10, -10, -40)(),
            40
        )
        testTable(
            fn:bind(table.pack, "hello", "HELLO", "world")("Hello", "hELLO", "WORLD"),
            {n=6, "hello","HELLO","world","Hello","hELLO","WORLD"}
        )
        testEquals(
            fn:bind(fn:bind(select, 6, "a", "b"), "c", "d")("e", "f", "g"),
            "f"
        )

        test "with nil args"
        testEquals(fn:bind(select, "#", nil, nil, nil, nil)(), 4)
        testEquals(fn:bind(select, "#")(nil, nil, nil, nil), 4)
        testEquals(fn:bind(select, "5", nil, nil)(nil, nil, 10), 10)
        testEquals(fn:bind(select, "5", "A", nil)("B", nil, "C", nil), "C")
        testTable(
            fn:bind(fn:bind(table.pack, nil, "A", nil), "B", nil, "C")("D", nil),
            {n=8, nil, "A", nil, "B", nil, "C", "D", nil}
        )
    end

    section "fn:bindSeal()"; do
        test "Examples"
        testTrue(fn:bindSeal(math.random, 0, 4)() <= 4)

        test "no nil args"
        testEquals(fn:bindSeal(math.max, 0)(), 0)
        testEquals(fn:bindSeal(math.max, 0, 1, 2)(), 2)
        testEquals(fn:bindSeal(math.max, 2, 1, 0)(), 2)
        ---@diagnostic disable-next-line: redundant-parameter
        testEquals(fn:bindSeal(math.max, 1, 2, 0)(10, 20, 30), 2)
        testEquals(fn:bindSeal(math.max, 2, 1, 0, 10, 20, 30, 100, 200, 300, -1, -2, -3)(), 300)
        testTable(fn:bindSeal(table.pack, "hello", "HELLO", "world")(), {"hello","HELLO","world",n=3})
        testEquals(-fn:bind(setmetatable, {x = -10}, {__unm = function(t) return t.x end})(), -10)

        test "with nil args"
        testEquals(fn:bindSeal(select, "#", nil, nil, nil, nil)(), 4)
        ---@diagnostic disable-next-line: redundant-parameter
        testEquals(fn:bindSeal(select, "#", nil, nil, nil, nil)(1, 2, 3, 100), 4)
        testEquals(fn:bindSeal(select, "4", nil, nil, nil, "A")(), "A")
        testTable(
            fn:bindSeal(table.pack, nil, "A", nil)(),
            {n=3, nil, "A", nil}
        )
    end

    section "fn:op()"; do
        test "Examples"
        testTrue(fn:op("+")(1, 1) == 2)
        testTrue(fn:op("+", 10)(1) == 11)

        test "parameter handling"
        testEquals(fn:op("+")(10, 20), 30)
        testEquals(fn:op("+", 10)(20), 30)
        testEquals(fn:op("+", 10, 20)(), 30)
        testEquals(fn:op("+", 10, 20)(100), 30)
        testEquals(fn:op("+", 10, 20)(100, 200), 30)
        testEquals(fn:op("+", 10, 20)(100, 200), 30)

        test "operators"
        testEquals(fn:op("+")(20, 7), 27)
        testEquals(fn:op("-")(20, 7), 13)
        testEquals(fn:op("*")(20, 7), 140)
        testEquals(fn:op("/")(70, 7), 10)
        testEquals(fn:op("%")(20, 7), 6)
        testEquals(fn:op("..")("hello", "world"), "helloworld")
        testEquals(fn:op("^")(2, 8), 256)
        testEquals(fn:op("==")("a", "a"), true)
        testEquals(fn:op("~=")("a", "a"), false)
        testEquals(fn:op("<=")(10, 20), true)
        testEquals(fn:op(">=")(10, 20), false)
        testEquals(fn:op("<=")(10, 10), true)
        testEquals(fn:op(">=")(10, 10), true)
        testEquals(fn:op("<")(10, 20), true)
        testEquals(fn:op(">")(10, 20), false)
        testEquals(fn:op("and")(true, false), false)
        testEquals(fn:op("or")(true, false), true)
        testEquals(fn:op(".")({11,22}, 1), 11)
        testEquals(fn:op(".")({11,22}, 3), nil)
        testEquals(fn:op(".")({a="AA"}, "a"), "AA")
    end

    completeAllTest()
end
