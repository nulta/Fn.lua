
---@type metatable
local fnMeta = {}

---@class Fn
---@overload fun(tbl: table): Fn.FiniteIterator
local fn = setmetatable({}, fnMeta)


-- Fn.Iterator
do
    ---@generic T
    ---@class Fn.Iterator<T>
    ---@overload fun(): any?
    fn.Iterator = {}

    --- Initialize new Iterator.
    ---@generic T
    ---@param next fun(self: Fn.Iterator<T>): T
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator.new(next)
        local meta = {
            __call = next,
            __index = fn.Iterator
        }

        return setmetatable({}, meta)
    end

    --- Returns null iterator. null iterator always returns nil.
    ---@return Fn.Iterator
    function fn.Iterator:null()
        return self.new(function() return nil end)
    end

    --- Return the shallow copied instance of iterator.
    function fn.Iterator:copy()
        -- TODO: how??
    end

    --- Maps iterator with given function.
    ---@generic T, U
    ---@param func fun(val: T): U
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator:map(func)
        return self.new(function()
            local x = self()
            if x == nil then return nil end
            return func(x)
        end)
    end

    --- Returns first item on iterator which passes given filter function.
    ---@generic T
    ---@param filter fun(val: T): boolean
    ---@return T?
    ---@nodiscard
    function fn.Iterator:find(filter)
        for val in self do
            if filter(val) then return val end
        end
        return nil
    end

    --- Filters out values from iterator which given filter function returns false.
    ---@generic T
    ---@param filter fun(val: T): boolean
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator:filter(filter)
        return self.new(function()
            return self:find(filter)
        end)
    end

    --- Filters out duplicate values from iterator.
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator:unique()
        local values = {}
        return self:filter(function(x)
            if values[x] then return false end
            values[x] = true
            return true
        end)
    end

    --- Limits the count of items to be a maximum of given integer.
    ---@generic T
    ---@param limit integer
    ---@return Fn.FiniteIterator
    ---@nodiscard
    function fn.Iterator:limit(limit)
        local count = 0
        return fn.FiniteIterator.new(function()
            if count >= limit then return nil end
            count = count + 1
            return self()
        end)
    end

    --- Iterate on the item while given function returns true.
    ---@generic T
    ---@param test fun(T): boolean
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator:limitWhile(test)
        return self.new(function()
            local val = self()
            if not test(val) then return nil end
            return val
        end)
    end

    --- Skips first n items from iterator.
    ---@generic T
    ---@param amount integer
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator:skip(amount)
        for _=1, amount do
            local x = self()
            if x == nil then
                return self:null()
            end
        end
        return self
    end

    --- Skips item while given function returns true with item.
    ---@generic T
    ---@param test fun(T): boolean
    ---@return Fn.Iterator
    ---@nodiscard
    function fn.Iterator:skipWhile(test)
        local item = self:find(function(x) return not test(x) end)
        local first = true

        return self.new(function()
            if first then
                return item
            else
                return self()
            end
        end)
    end

    --- Returns true if the iterator produces at least one item which is not false.
    ---@return boolean
    ---@nodiscard
    function fn.Iterator:some()
        for x in self do
            if x ~= false then return true end
        end
        return false
    end

    --- Returns iterator and some data which can be used in place of ipairs().
    ---@return function
    ---@return Fn.Iterator
    ---@return integer
    function fn.Iterator:ipairs()
        return function(next, count)
            return count + 1, next()
        end, self, 0
    end
end


-- Fn.FiniteIterator
do
    ---@class Fn.FiniteIterator<T>: Fn.Iterator<T>
    fn.FiniteIterator = setmetatable({}, {__index = fn.Iterator})

    --- Initialize new FiniteIterator.
    ---@generic T
    ---@param next fun(self: Fn.FiniteIterator<T>): T
    ---@return Fn.FiniteIterator
    ---@nodiscard
    function fn.FiniteIterator.new(next)
        local meta = {
            __call = next,
            __index = fn.FiniteIterator
        }

        return setmetatable({}, meta)
    end

    --- Returns count of the iterations.
    ---@return integer
    ---@nodiscard
    function fn.FiniteIterator:count()
        local count = 0
        for _ in self do
            count = count + 1
        end
        return count
    end

    --- Reduces an array to a single value, iterating through elements and accumulating a result.
    ---@generic T
    ---@param func fun(accumulated: T, current: T): T
    ---@param initialValue T?
    ---@return T?
    ---@nodiscard
    function fn.FiniteIterator:reduce(func, initialValue)
        local accumulated = initialValue                     -- initialValue
        if accumulated == nil then accumulated = self() end  -- no initialValue?
        if accumulated == nil then return nil end            -- and iterator immediately died?

        for current in self do
            accumulated = func(accumulated, current)
        end

        return accumulated
    end

    --- Returns true if every items that the iterator produces are not false, **or if the iterator is empty.**
    ---@return boolean
    ---@nodiscard
    function fn.FiniteIterator:every()
        for x in self do
            if x == false then return false end
        end
        return true
    end

    --- Returns the sum of items.
    ---@return number?
    ---@nodiscard
    function fn.FiniteIterator:sum()
        return self:reduce(function(x, y) return x + y end)
    end

    --- Cast the iterator to a table.
    ---@generic T
    ---@return {[integer]: T}
    ---@nodiscard
    function fn.FiniteIterator:table()
        local tbl = {}
        for x in self do
            table.insert(tbl, x)
        end
        return tbl
    end

    --- Cast the iterator to a string.
    ---@generic T
    ---@param seperator string?
    ---@return string
    ---@nodiscard
    function fn.FiniteIterator:concat(seperator)
        return table.concat(self:table(), seperator)
    end

    ---Executes given function once for each elements of iterator, in order.
    ---@param func function
    ---@return nil
    function fn.FiniteIterator:forEach(func)
        for x in self do
            func(x)
        end
    end


    ---@class Fn.InfiniteIterator<T>: Fn.Iterator<T>
    fn.InfiniteIterator = setmetatable({}, {__index = fn.Iterator})

    --- Initialize new InfiniteIterator.
    ---@generic T
    ---@param next fun(self: Fn.InfiniteIterator<T>): T
    ---@return Fn.InfiniteIterator
    ---@nodiscard
    function fn.InfiniteIterator.new(next)
        local meta = {
            __call = next,
            __index = fn.InfiniteIterator
        }

        return setmetatable({}, meta)
    end
end

-- fn:range, fn:counter
do
    --- Returns new FiniteIterator which creates numbers. Default value for `from` is 1.
    ---@param from number Default is 1. Inclusive.
    ---@param to number Required. Inclusive.
    ---@param step number? Default is 1.
    ---@return Fn.FiniteIterator
    ---@overload fun(self, to: number, _: nil, step: number): Fn.FiniteIterator
    ---@overload fun(self, to: number): Fn.FiniteIterator
    function fn:range(from, to, step)
        if not from then
            error("bad argument #2 to fn.range (number expected, got nil or false)")
        end
        step = step or 1
        if not to then
            to = from
            from = 1
        end

        local current = from
        return fn.FiniteIterator.new(function()
            if from < to then
                if to < current then
                    return nil
                end
            else
                if current < to then
                    return nil
                end
            end

            local val = current
            current = current + step
            return val
        end)
    end

    --- Returns new InfiniteIterator which creates numbers.
    ---@param from number? Default to 1.
    ---@param step number? Default to 1.
    ---@return Fn.InfiniteIterator
    function fn:counter(from, step)
        from = from or 1
        step = step or 1

        local current = from
        return fn.InfiniteIterator.new(function()
            local val = current
            current = current + step
            return val
        end)
    end

end

-- fn:op("+")
do
    ---@alias Fn.opSymbol
    ---| "+"
    ---| "-"
    ---| "*"
    ---| "/"
    ---| "%"
    ---| ".."
    ---| "^"
    ---| "=="
    ---| "~="
    ---| "<="
    ---| ">="
    ---| "<"
    ---| ">"
    ---| "and"
    ---| "or"

    local operators = {
        ["+"]  = function(a, b) return a + b end,
        ["-"]  = function(a, b) return a - b end,
        ["*"]  = function(a, b) return a * b end,
        ["/"]  = function(a, b) return a / b end,
        ["%"]  = function(a, b) return a % b end,
        [".."] = function(a, b) return a .. b end,
        ["^"]  = function(a, b) return a ^ b end,
        ["=="] = function(a, b) return a == b end,
        ["~="] = function(a, b) return a ~= b end,
        ["<="] = function(a, b) return a <= b end,
        [">="] = function(a, b) return a >= b end,
        ["<"]  = function(a, b) return a < b end,
        [">"]  = function(a, b) return a > b end,
        ["and"] = function(a, b) return a and b end,
        ["or"] = function(a, b) return a or b end,
    }

    --- Returns operator as a function, with filled parameter
    ---@overload fun(self, symbol: Fn.opSymbol                ): fun(a: any, b: any): any
    ---@overload fun(self, _: nil, symbol: Fn.opSymbol, b: any): fun(a: any): any
    ---@overload fun(self, a: any, symbol: Fn.opSymbol, _: nil): fun(b: any): any
    ---@overload fun(self, a: any, symbol: Fn.opSymbol, b: nil): fun(): any
    function fn:op(x, y, z)
        if y == nil and z == nil then
            return operators[x]
        end

        if operators[y] then
            if x == nil then
                return function(a) return operators[y](a, z) end
            elseif z == nil then
                return function(b) return operators[y](x, b) end
            else
                -- constant?
                local c = operators[y](x, z)
                return function() return c end
            end
        else
            error("bad argument #2 to fn.op (opSymbol expected)")
        end
    end

end

-- fn(arg)
do
    --- Cast the given argument into matching fn type.
    --- - table -> Fn.FiniteIterator
    --- - string -> Fn.Utf8String
    ---@param arg table
    function fnMeta:__call(arg)
        if type(arg) == "table" then
            return fn:counter(1):map(function(i) return arg[i] end)
        end

        error("bad argument #2 to fnMeta.__call (table expected)")
    end
end

return fn