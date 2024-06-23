local Fn = require("fn")

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
    section "Fn:bind()"; do
        test "Examples"
        testTrue(Fn:bind(math.max, 100)(2, 55, 7) == 100)
        testTrue(Fn:bind(table.pack, 1, 2)(3, nil)[4] == nil)

        test "no additional args"
        testEquals(Fn:bind(math.max, 0)(), 0)
        testEquals(Fn:bind(math.max, 0, 1, 2)(), 2)
        testEquals(Fn:bind(math.max, 2, 1, 0)(), 2)
        testEquals(Fn:bind(math.max, 2, 1, 0, 10, 20, 30, 100, 200, 300, -1, -2, -3)(), 300)
        testTable(Fn:bind(table.pack, "hello", "HELLO", "world")(), {"hello","HELLO","world",n=3})
        testEquals(Fn:bind(table.concat, {"hello","HELLO","world"})(), "helloHELLOworld")

        test "non-nil args, additional args"
        testEquals(Fn:bind(math.max, 0)(1), 1)
        testEquals(Fn:bind(math.max, 0, 1, 2)(3, -1, -2), 3)
        testEquals(Fn:bind(math.max, 0, 1, 2)(3, 4, 5), 5)
        testEquals(Fn:bind(table.concat, {"hello","HELLO","world"})(" "), "hello HELLO world")
        testEquals(-Fn:bind(setmetatable, {x = -10})({__unm = function(t) return t.x end}), -10)
        testEquals(
            Fn:bind(Fn:bind(math.max, 2, 1, 0), 20, 30, 40)(11, 22, 50),
            50
        )
        testEquals(
            Fn:bind(Fn:bind(math.max, 30, 20, 40), 10, -10, -40)(),
            40
        )
        testTable(
            Fn:bind(table.pack, "hello", "HELLO", "world")("Hello", "hELLO", "WORLD"),
            {n=6, "hello","HELLO","world","Hello","hELLO","WORLD"}
        )
        testEquals(
            Fn:bind(Fn:bind(select, 6, "a", "b"), "c", "d")("e", "f", "g"),
            "f"
        )

        test "with nil args"
        testEquals(Fn:bind(select, "#", nil, nil, nil, nil)(), 4)
        testEquals(Fn:bind(select, "#")(nil, nil, nil, nil), 4)
        testEquals(Fn:bind(select, "5", nil, nil)(nil, nil, 10), 10)
        testEquals(Fn:bind(select, "5", "A", nil)("B", nil, "C", nil), "C")
        testTable(
            Fn:bind(Fn:bind(table.pack, nil, "A", nil), "B", nil, "C")("D", nil),
            {n=8, nil, "A", nil, "B", nil, "C", "D", nil}
        )
    end

    section "Fn:bindSeal()"; do
        test "Examples"
        testTrue(Fn:bindSeal(math.random, 0, 4)() <= 4)

        test "no nil args"
        testEquals(Fn:bindSeal(math.max, 0)(), 0)
        testEquals(Fn:bindSeal(math.max, 0, 1, 2)(), 2)
        testEquals(Fn:bindSeal(math.max, 2, 1, 0)(), 2)
        ---@diagnostic disable-next-line: redundant-parameter
        testEquals(Fn:bindSeal(math.max, 1, 2, 0)(10, 20, 30), 2)
        testEquals(Fn:bindSeal(math.max, 2, 1, 0, 10, 20, 30, 100, 200, 300, -1, -2, -3)(), 300)
        testTable(Fn:bindSeal(table.pack, "hello", "HELLO", "world")(), {"hello","HELLO","world",n=3})
        testEquals(-Fn:bind(setmetatable, {x = -10}, {__unm = function(t) return t.x end})(), -10)

        test "with nil args"
        testEquals(Fn:bindSeal(select, "#", nil, nil, nil, nil)(), 4)
        ---@diagnostic disable-next-line: redundant-parameter
        testEquals(Fn:bindSeal(select, "#", nil, nil, nil, nil)(1, 2, 3, 100), 4)
        testEquals(Fn:bindSeal(select, "4", nil, nil, nil, "A")(), "A")
        testTable(
            Fn:bindSeal(table.pack, nil, "A", nil)(),
            {n=3, nil, "A", nil}
        )
    end

    section "Fn:op()"; do
        test "Examples"
        testTrue(Fn:op("+")(1, 1) == 2)
        testTrue(Fn:op("+", 10)(1) == 11)

        test "parameter handling"
        testEquals(Fn:op("+")(10, 20), 30)
        testEquals(Fn:op("+", 10)(20), 30)
        testEquals(Fn:op("+", 10, 20)(), 30)
        testEquals(Fn:op("+", 10, 20)(100), 30)
        testEquals(Fn:op("+", 10, 20)(100, 200), 30)
        testEquals(Fn:op("+", 10, 20)(100, 200), 30)

        test "operators"
        testEquals(Fn:op("+")(20, 7), 27)
        testEquals(Fn:op("-")(20, 7), 13)
        testEquals(Fn:op("*")(20, 7), 140)
        testEquals(Fn:op("/")(70, 7), 10)
        testEquals(Fn:op("%")(20, 7), 6)
        testEquals(Fn:op("..")("hello", "world"), "helloworld")
        testEquals(Fn:op("^")(2, 8), 256)
        testEquals(Fn:op("==")("a", "a"), true)
        testEquals(Fn:op("~=")("a", "a"), false)
        testEquals(Fn:op("<=")(10, 20), true)
        testEquals(Fn:op(">=")(10, 20), false)
        testEquals(Fn:op("<=")(10, 10), true)
        testEquals(Fn:op(">=")(10, 10), true)
        testEquals(Fn:op("<")(10, 20), true)
        testEquals(Fn:op(">")(10, 20), false)
        testEquals(Fn:op("and")(true, false), false)
        testEquals(Fn:op("or")(true, false), true)
        testEquals(Fn:op(".")({11,22}, 1), 11)
        testEquals(Fn:op(".")({11,22}, 3), nil)
        testEquals(Fn:op(".")({a="AA"}, "a"), "AA")
    end

    section "Fn.Iterator"; do
        test "initializers"
        testEquals(Fn.Iterator.null():count(), 0)
        testEquals(Fn:range(100):count(), 100)
        testEquals(Fn:range(-10, 10):sum(), 0)
        testEquals(Fn:counter():stopIf(Fn:op("<=", nil, 100)):limit(1000):count(), 100)
        testEquals(Fn:repeater({"A","B","C"}):limit(9):concat(), "ABCABCABC")
        -- testEquals(Fn:urandom():limit(100):count(), 100)
        testTrue(Fn:urandom(100, 101):limit(100):sum() >= 100*100)

        test "methods"
        testEquals(Fn:range(5):concat(", "), "1, 2, 3, 4, 5")
        testEquals(Fn:range(100):count(), 100)
        testEquals(Fn:range(100):every(), true)
        testEquals(Fn:range(10):filter(function(x) return x % 2 == 0 end):sum(), 2+4+6+8+10)
        testEquals(Fn:range(100):find(Fn:op(">", nil, 50)), 51)

        local foreachSum = 0
        Fn:range(10):forEach(function(x) foreachSum = foreachSum + x end)
        testEquals(foreachSum, 55)

        foreachSum = 0
        for i, v in Fn:range(100):ipairs() do
            foreachSum = foreachSum + v
        end
        testEquals(foreachSum, 5050)

        test "methods (2)"
        testEquals(Fn:range(100):limit(10):count(), 10)
        testEquals(Fn:range(100):map(Fn:op("*", 2)):sum(), 10100)
        testEquals(Fn:range(100):map(Fn:op("%", nil, 5)):unique():count(), 5)
        testEquals(Fn:range(4):reduce(Fn:op("*")), 24)
        testEquals(Fn:range(5):reversed():concat(", "), "5, 4, 3, 2, 1")
        testEquals(Fn:range(100):skip(10):count(), 90)

        test "methods (3)"
        testEquals(Fn:range(100):skipWhile(Fn:op("<=", nil, 10)):count(), 90)
        testEquals(Fn:range(100):map(function(x) return false end):some(), false)
        testEquals(Fn:range(100):map(Fn:op("==", 50)):some(), true)
        testEquals(Fn:range(100):reversed():sorted():concat(), Fn:range(100):concat())
        testEquals(Fn:range(100):stopIf(Fn:op("<", nil, 10)):count(), 9)
        testEquals(Fn:range(100):skip(10):count(), 90)
    end

    completeAllTest()
end
