---@meta

---@module "Fn"
local Fn

---@generic T
---@class Fn.Iterator<T>
---@overload fun(): any?
Fn.Iterator = {}


---@class Fn.FiniteIterator: Fn.Iterator
Fn.FiniteIterator = {}

--- Maps iterator with given function.
---@generic T, U
---@param func fun(val: T): U
---@return Fn.FiniteIterator
---@nodiscard
function Fn.FiniteIterator:map(func) end

--- Filters out values from iterator which given filter function returns false.
---@generic T
---@param filter fun(val: T): boolean
---@return Fn.FiniteIterator
---@nodiscard
function Fn.FiniteIterator:filter(filter) end

--- Filters out duplicate values from iterator.
---@return Fn.FiniteIterator
---@nodiscard
function Fn.FiniteIterator:unique() end

--- Iterate on the item while given function returns true.
---@generic T
---@param test fun(T): boolean
---@return Fn.FiniteIterator
---@nodiscard
function Fn.FiniteIterator:limitWhile(test) end

--- Skips first n items from iterator.
---@generic T
---@param amount integer
---@return Fn.FiniteIterator
---@nodiscard
function Fn.FiniteIterator:skip(amount) end

--- Skips item while given function returns true with item.
---@generic T
---@param test fun(T): boolean
---@return Fn.FiniteIterator
---@nodiscard
function Fn.FiniteIterator:skipWhile(test) end


---@class Fn.InfiniteIterator: Fn.Iterator
Fn.InfiniteIterator = {}

--- Maps iterator with given function.
---@generic T, U
---@param func fun(val: T): U
---@return Fn.InfiniteIterator
---@nodiscard
function Fn.InfiniteIterator:map(func) end

--- Filters out values from iterator which given filter function returns false.
---@generic T
---@param filter fun(val: T): boolean
---@return Fn.InfiniteIterator
---@nodiscard
function Fn.InfiniteIterator:filter(filter) end

--- Filters out duplicate values from iterator.
---@return Fn.InfiniteIterator
---@nodiscard
function Fn.InfiniteIterator:unique() end

--- Iterate on the item while given function returns true.
---@generic T
---@param test fun(T): boolean
---@return Fn.InfiniteIterator
---@nodiscard
function Fn.InfiniteIterator:limitWhile(test) end

--- Skips first n items from iterator.
---@generic T
---@param amount integer
---@return Fn.InfiniteIterator
---@nodiscard
function Fn.InfiniteIterator:skip(amount) end

--- Skips item while given function returns true with item.
---@generic T
---@param test fun(T): boolean
---@return Fn.InfiniteIterator
---@nodiscard
function Fn.InfiniteIterator:skipWhile(test) end
