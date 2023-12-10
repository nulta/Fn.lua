---@meta

---@module "fn"
local fn

---@generic T
---@class Fn.Iterator<T>
---@overload fun(): any?
fn.Iterator = {}


---@class Fn.FiniteIterator: Fn.Iterator
fn.FiniteIterator = {}

--- Maps iterator with given function.
---@generic T, U
---@param func fun(val: T): U
---@return Fn.FiniteIterator
---@nodiscard
function fn.FiniteIterator:map(func) end

--- Filters out values from iterator which given filter function returns false.
---@generic T
---@param filter fun(val: T): boolean
---@return Fn.FiniteIterator
---@nodiscard
function fn.FiniteIterator:filter(filter) end

--- Filters out duplicate values from iterator.
---@return Fn.FiniteIterator
---@nodiscard
function fn.FiniteIterator:unique() end

--- Iterate on the item while given function returns true.
---@generic T
---@param test fun(T): boolean
---@return Fn.FiniteIterator
---@nodiscard
function fn.FiniteIterator:limitWhile(test) end

--- Skips first n items from iterator.
---@generic T
---@param amount integer
---@return Fn.FiniteIterator
---@nodiscard
function fn.FiniteIterator:skip(amount) end

--- Skips item while given function returns true with item.
---@generic T
---@param test fun(T): boolean
---@return Fn.FiniteIterator
---@nodiscard
function fn.FiniteIterator:skipWhile(test) end


---@class Fn.InfiniteIterator: Fn.Iterator
fn.InfiniteIterator = {}

--- Maps iterator with given function.
---@generic T, U
---@param func fun(val: T): U
---@return Fn.InfiniteIterator
---@nodiscard
function fn.InfiniteIterator:map(func) end

--- Filters out values from iterator which given filter function returns false.
---@generic T
---@param filter fun(val: T): boolean
---@return Fn.InfiniteIterator
---@nodiscard
function fn.InfiniteIterator:filter(filter) end

--- Filters out duplicate values from iterator.
---@return Fn.InfiniteIterator
---@nodiscard
function fn.InfiniteIterator:unique() end

--- Iterate on the item while given function returns true.
---@generic T
---@param test fun(T): boolean
---@return Fn.InfiniteIterator
---@nodiscard
function fn.InfiniteIterator:limitWhile(test) end

--- Skips first n items from iterator.
---@generic T
---@param amount integer
---@return Fn.InfiniteIterator
---@nodiscard
function fn.InfiniteIterator:skip(amount) end

--- Skips item while given function returns true with item.
---@generic T
---@param test fun(T): boolean
---@return Fn.InfiniteIterator
---@nodiscard
function fn.InfiniteIterator:skipWhile(test) end
