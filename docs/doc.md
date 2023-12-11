# Fn

## FiniteIterator


```lua
table|Fn.Iterator
```

## InfiniteIterator


```lua
table|Fn.Iterator
```

## Iterator


```lua
Fn.Iterator
```

## bind


```lua
(method) Fn:bind(func: fun(a: <T1>, ...<T2>):<R>, a: <T1>, ...<T2>?)
  -> fun(...<T2>):<R>
```

 Returns function with prefilled arguments.

## bindSeal


```lua
(method) Fn:bindSeal(func: fun(...<T>):<R>, ...<T>)
  -> fun():<R>
```

 Returns new function with prefilled arguments, which accepts no other arguments.

## counter


```lua
(method) Fn:counter(from?: number, step?: number)
  -> Fn.InfiniteIterator
```

 Returns new InfiniteIterator which creates numbers.

@*param* `from` — Default to 1.

@*param* `step` — Default to 1.

## op


```lua
(method) Fn:op(symbol: Fn.opSymbol, a: any, b: any)
  -> function
```

 Returns operator as a function, with filled parameter

## range


```lua
(method) Fn:range(from: number, to: number, step?: number)
  -> Fn.FiniteIterator
```

 Returns new FiniteIterator which creates numbers. Default value for `from` is 1.

@*param* `from` — Default is 1. Inclusive.

@*param* `to` — Required. Inclusive.

@*param* `step` — Default is 1.

## repeater


```lua
(method) Fn:repeater(list: table<integer, any>)
  -> Fn.InfiniteIterator
```

 Returns new InfiniteIterator which repeats through given list.
 Return a null iterator if `#list == 0`.

## urandom


```lua
(method) Fn:urandom(m?: integer, n?: integer, randFunc?: fun(m?: integer, n?: integer):number)
  -> Fn.InfiniteIterator
```

 Returns new InfiniteIterator which creates random numbers.
 - `fn:urandom()`: Returns random float iterator within the range `[0, 1)`.
 - `fn:urandom(m)`: Returns random integer iterator within the range `[1, m]`.
 - `fn:urandom(m, n)`: Returns random integer iterator within the range `[m, n]`.

@*param* `randFunc` — RNG function to use instead of math.random.


---

# Fn.FiniteIterator

## concat


```lua
(method) Fn.FiniteIterator:concat(seperator?: string)
  -> string
```

 Cast the iterator to a string.

## count


```lua
(method) Fn.FiniteIterator:count()
  -> integer
```

 Returns count of the iterations.

## every


```lua
(method) Fn.FiniteIterator:every()
  -> boolean
```

 Returns true if every items that the iterator produces are not false, **or if the iterator is empty.**

## filter


```lua
(method) Fn.FiniteIterator:filter(filter: fun(val: <T>):boolean)
  -> Fn.FiniteIterator
```

 Filters out values from iterator which given filter function returns false.

## find


```lua
(method) Fn.Iterator:find(filter: fun(val: <T>):boolean)
  -> <T>?
```

 Returns first item on iterator which passes given filter function.

## forEach


```lua
(method) Fn.FiniteIterator:forEach(func: function)
  -> nil
```

Executes given function once for each elements of iterator, in order.

## ipairs


```lua
(method) Fn.Iterator:ipairs()
  -> function
  2. Fn.Iterator
  3. integer
```

 Returns iterator and some data which can be used in place of ipairs().

## limit


```lua
(method) Fn.Iterator:limit(limit: integer)
  -> Fn.FiniteIterator
```

 Limits the count of items to be a maximum of given integer.

## limitWhile


```lua
(method) Fn.FiniteIterator:limitWhile(test: fun(T: any):boolean)
  -> Fn.FiniteIterator
```

 Iterate on the item while given function returns true.

## map


```lua
(method) Fn.FiniteIterator:map(func: fun(val: <T>):<U>)
  -> Fn.FiniteIterator
```

 Maps iterator with given function.

## new


```lua
function Fn.FiniteIterator.new(next: fun(self: Fn.FiniteIterator<<T>>):<T>)
  -> Fn.FiniteIterator
```

 Initialize new FiniteIterator.

## null


```lua
function Fn.Iterator.null()
  -> Fn.FiniteIterator
```

 Returns null iterator. null iterator always returns nil.

## reduce


```lua
(method) Fn.FiniteIterator:reduce(func: fun(accumulated: <T>, current: <T>):<T>, initialValue?: <T>)
  -> <T>?
```

 Reduces an array to a single value, iterating through elements and accumulating a result.

## reversed


```lua
(method) Fn.FiniteIterator:reversed()
  -> Fn.FiniteIterator
```

 Returns reversed iterator. It uses self:table() under the hood.

## skip


```lua
(method) Fn.FiniteIterator:skip(amount: integer)
  -> Fn.FiniteIterator
```

 Skips first n items from iterator.

## skipWhile


```lua
(method) Fn.FiniteIterator:skipWhile(test: fun(T: any):boolean)
  -> Fn.FiniteIterator
```

 Skips item while given function returns true with item.

## some


```lua
(method) Fn.Iterator:some()
  -> boolean
```

 Returns true if the iterator produces at least one item which is not false.

## sorted


```lua
(method) Fn.FiniteIterator:sorted(func: any)
  -> Fn.FiniteIterator
```

 Returns sorted iterator. It uses self:table() under the hood.

## sum


```lua
(method) Fn.FiniteIterator:sum()
  -> number?
```

 Returns the sum of items.

## table


```lua
(method) Fn.FiniteIterator:table()
  -> { [integer]: <T> }
```

 Cast the iterator to a table.

## unique


```lua
(method) Fn.FiniteIterator:unique()
  -> Fn.FiniteIterator
```

 Filters out duplicate values from iterator.


---

# Fn.InfiniteIterator

## filter


```lua
(method) Fn.InfiniteIterator:filter(filter: fun(val: <T>):boolean)
  -> Fn.InfiniteIterator
```

 Filters out values from iterator which given filter function returns false.

## find


```lua
(method) Fn.Iterator:find(filter: fun(val: <T>):boolean)
  -> <T>?
```

 Returns first item on iterator which passes given filter function.

## ipairs


```lua
(method) Fn.Iterator:ipairs()
  -> function
  2. Fn.Iterator
  3. integer
```

 Returns iterator and some data which can be used in place of ipairs().

## limit


```lua
(method) Fn.Iterator:limit(limit: integer)
  -> Fn.FiniteIterator
```

 Limits the count of items to be a maximum of given integer.

## limitWhile


```lua
(method) Fn.InfiniteIterator:limitWhile(test: fun(T: any):boolean)
  -> Fn.InfiniteIterator
```

 Iterate on the item while given function returns true.

## map


```lua
(method) Fn.InfiniteIterator:map(func: fun(val: <T>):<U>)
  -> Fn.InfiniteIterator
```

 Maps iterator with given function.

## new


```lua
function Fn.InfiniteIterator.new(next: fun(self: Fn.InfiniteIterator<<T>>):<T>)
  -> Fn.InfiniteIterator
```

 Initialize new InfiniteIterator.

## null


```lua
function Fn.Iterator.null()
  -> Fn.FiniteIterator
```

 Returns null iterator. null iterator always returns nil.

## skip


```lua
(method) Fn.InfiniteIterator:skip(amount: integer)
  -> Fn.InfiniteIterator
```

 Skips first n items from iterator.

## skipWhile


```lua
(method) Fn.InfiniteIterator:skipWhile(test: fun(T: any):boolean)
  -> Fn.InfiniteIterator
```

 Skips item while given function returns true with item.

## some


```lua
(method) Fn.Iterator:some()
  -> boolean
```

 Returns true if the iterator produces at least one item which is not false.

## unique


```lua
(method) Fn.InfiniteIterator:unique()
  -> Fn.InfiniteIterator
```

 Filters out duplicate values from iterator.


---

# Fn.Iterator

## filter


```lua
(method) Fn.Iterator:filter(filter: fun(val: <T>):boolean)
  -> Fn.Iterator
```

 Filters out values from iterator which given filter function returns false.

## find


```lua
(method) Fn.Iterator:find(filter: fun(val: <T>):boolean)
  -> <T>?
```

 Returns first item on iterator which passes given filter function.

## ipairs


```lua
(method) Fn.Iterator:ipairs()
  -> function
  2. Fn.Iterator
  3. integer
```

 Returns iterator and some data which can be used in place of ipairs().

## limit


```lua
(method) Fn.Iterator:limit(limit: integer)
  -> Fn.FiniteIterator
```

 Limits the count of items to be a maximum of given integer.

## limitWhile


```lua
(method) Fn.Iterator:limitWhile(test: fun(T: any):boolean)
  -> Fn.Iterator
```

 Iterate on the item while given function returns true.

## map


```lua
(method) Fn.Iterator:map(func: fun(val: <T>):<U>)
  -> Fn.Iterator
```

 Maps iterator with given function.

## new


```lua
function Fn.Iterator.new(next: fun(self: Fn.Iterator<<T>>):<T>)
  -> Fn.Iterator
```

 Initialize new Iterator.

## null


```lua
function Fn.Iterator.null()
  -> Fn.FiniteIterator
```

 Returns null iterator. null iterator always returns nil.

## skip


```lua
(method) Fn.Iterator:skip(amount: integer)
  -> Fn.Iterator
```

 Skips first n items from iterator.

## skipWhile


```lua
(method) Fn.Iterator:skipWhile(test: fun(T: any):boolean)
  -> Fn.Iterator
```

 Skips item while given function returns true with item.

## some


```lua
(method) Fn.Iterator:some()
  -> boolean
```

 Returns true if the iterator produces at least one item which is not false.

## unique


```lua
(method) Fn.Iterator:unique()
  -> Fn.Iterator
```

 Filters out duplicate values from iterator.


---

# Fn.opSymbol

```lua
Fn.opSymbol:
    | "+"
    | "-"
    | "*"
    | "/"
    | "%"
    | ".."
    | "^"
    | "=="
    | "~="
    | "<="
    | ">="
    | "<"
    | ">"
    | "and"
    | "or"
    | "."
```


```lua
"%"|"*"|"+"|"-"|"."...(+11)
```
