# <a name='TOC'>Table of Contents</a>

* [Introduction](#introduction)
* [lamda API](#api)
	* [Collection Functions](#collection)
		* [all](#all)
		* [any](#any)
		* [each](#each)
		* [map](#map)
		* [reduce](#reduce)
		* [reduceRight](#reduceRight)
		* [reject](#reject)
		* [select](#select)
	* [Array Functions](#array)
		* [head](#head)
		* [tail](#tail)
	* [Functional](#functional)
		* [compose](#compose)
		* [curry](#curry)
		* [memoize](#memoize)
		* [partial](#partial)
		* [wrap](#wrap)
	* [Object Functions](#object)
		* [identity](#identity)
		* [isArray](#isArray)
		* [isBoolean](#isBoolean)
		* [isEmpty](#isEmpty)
		* [isFinite](#isFinite)
		* [isFunction](#isFunction)
		* [isNaN](#isNaN)
		* [isNil](#isNil)
		* [isNumber](#isNumber)
		* [isObject](#isObject)
		* [isString](#isString)
	* [Utiltity Functions](#utility)
	* [Chaining Functions](#chaining)
		* [chain](#chain)
		* [value](#value)


# <a name='introduction'>Introduction</a>

```lua
l = require 'lamda'
```
# <a name='api'>lamda API</a>

## <a name='collection'>Collection Functions</a>

### <a name='all'>all(func, coll)</a>

```lua
arr = {1, 2, 3, 4}
gtZero = (x) -> x > 0

l.all gtZero, arr 
assert.are.same( true, res )
```

### <a name='any'>any(func, coll)</a>

```lua
arr = {0, 1, 2, 3, 4}
ltZero = (x) -> x < 0

res = l.any ltZero, arr
assert.are.same( false, res )
```

### <a name='each'>each(func, coll)</a>
*Alias:* forEach

Iterates over ```coll``` calling ```func```.

```lua
arr = {1, 2, 3, 4}
printit = (x) -> print x

l.each printit, arr 
-- => 1
-- => 2
-- => 3
-- => 4
```

## <a name='array'>Array Functions</a>


## <a name='functional'>Functional</a>

### <a name='curry'>Curry</a>
The ```curry``` function creates a curryable function so that parameters can be 
applied one at a time. This is handy when you want to apply an algorithm to a function
that can then be used for multiple sets of data.

In the following example a map is curried so that a function (times2) can be applied to 
it. Then it can be used on several sets of data.
```lua
times2 = (x) -> x * 2

curryableMap = l.curry l.map
mapTimes2 = curryableMap times2 

res = mapTimes2 {1, 2, 3, 4, 5}
assert.are.same( {2, 4, 6, 8, 10}, res )

res = mapTimes2 {10, 20, 30, 40, 50}
assert.are.same( {20, 40, 60, 80, 100}, res )
```

## <a name='object'>Object Functions</a>


## <a name='utility'>Utility Functions</a>


## <a name='chaining'>Chaining Functions</a>
