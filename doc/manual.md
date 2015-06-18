# <a name='TOC'>Table of Contents</a>

* [Introduction](#introduction)
* [lamda API](#api)
	* [Collection Functions](#collection)
		* [all](#all)
		* [any](#any)
		* [each](#each)
		* [filter](#filter)
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
Lamda is a function library written in [Moonscript](http://http://moonscript.org/)/[Lua](http://lua.org) 
that is much like [Underscore](http://http://underscorejs.org/) or [Ramda](http://ramdajs.com) in JavaScript.
It provide utility functions that would be expected in functional programming.

The straigt library is provided by the package ```lamda```.
```lua
l = require 'lamda'
```

The curried library subset is provided by the package ```lamdac```. In this document, functions that have a 
curried version are marked as such.
```lua
c = require 'lamdac'
```

# <a name='api'>lamda API</a>

## <a name='collection'>Collection Functions</a>

### <a name='all'>all(func, coll) -> boolean</a>
*Curried*<br/>

```lua
arr = {1, 2, 3, 4}
gtZero = (x) -> x > 0

l.all gtZero, arr 
assert.are.same( true, res )
```

### <a name='any'>any(func, coll) -> boolean</a>
*Curried*<br/>

```lua
arr = {0, 1, 2, 3, 4}
ltZero = (x) -> x < 0

res = l.any ltZero, arr
assert.are.same( false, res )
```

### <a name='each'>each(func, coll)</a>
*Curried*<br/>
*Alias: forEach*

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

### <a name='filter'>filter(func, coll)</a>
*Curried*<br/>
*Alias: select*

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

### <a name='map'>map(func, coll) -> coll</a>
*Curried*<br/>
*Alias: collect*
```lua
coll = {1, 2, 3, 4, 5}
times2 = (x) -> x * 2
res = l.map times2, coll
assert.are.same( {2, 4, 6, 8, 10}, res )
```

### <a name='reduce'>reduce(func, memo, coll) -> value</a>
*Curried*<br/>
```lua

```

### <a name='reduceRight'>reduceRight(func, memo, coll) -> value</a>
*Curried*<br/>
```lua

```

### <a name='reject'>reject(func, coll) -> coll</a>
*Curried*<br/>
```lua

```

### <a name='select'>select(func, coll) -> coll</a>
*Curried*<br/>
```lua

```


## <a name='array'>Array Functions</a>

### <a name='head'>head(list, count = 1)</a>

```head``` returns the head of a list. The head is typically the first element, however the 
head could be the first count elements.

```lua
arr = {1, 2, 3, 4, 5}
a = l.head arr
assert.are.same 1, a

a, b = l.head arr, 2
assert.are.same 1, a
assert.are.same 2, b
```

### <a name='tail'>tail(list, count = 1)</a>

```tail``` returns the tail of the list. The tail is defined as all elements beyond the head. 
The parameter count determines the size of the head. See [head](#head)

```lua
arr = {1, 2, 3, 4, 5}
a = l.tail arr
assert.are.same {2, 3, 4, 5}, a

a = l.tail arr, 2
assert.are.same {3, 4, 5}, a
```

## <a name='functional'>Functional</a>
Funtions in this section typically create a new function by adding some trait to an existing function.

### <a name='compose'>compose(...) -> func</a>
Composes a list of functions into a single function. The functions will be executed from right to 
left, so composing ```newf = l.compose(f, g, h)``` results in ```newf = f(g(h()))```. 
```lua
times2 = (x) -> x * 2
times3 = (x) -> x * 3
square = (x) -> x * x 

f = l.compose times3, times2, square
assert.are.equal 150, f(5)
```

### <a name='curry'>curry</a>
[Currying](https://en.wikipedia.org/wiki/Currying) is the process of taking a function that 
takes multiple arguments and returning a set of functions that take one argument.

In the following ```curry``` example, a map that is curried has a function ```times2``` applied. 
Then it can be used on several sets of data.
```lua
c = require "lamdac"

times2 = (x) -> x * 2
mapTimes2 = c.map times2 

res = mapTimes2 {1, 2, 3, 4, 5}
assert.are.same( {2, 4, 6, 8, 10}, res )

res = mapTimes2 {10, 20, 30, 40, 50}
assert.are.same( {20, 40, 60, 80, 100}, res )
```

In addition, a function that is not curried can be curried:
```lua
l = require "lamda"

times2 = (x) -> x * 2
curriedMap = l.curry l.map 
mapTimes2 = curriedMap times2 
res = mapTimes2 {1, 2, 3, 4, 5}
```

### <a name='memoize'>memoize(func, coll) -> coll</a>
```lua

```

### <a name='partial'>partial(func, coll) -> coll</a>
```lua

```

### <a name='wrap'>wrap(func, coll) -> coll</a>
```lua

```


## <a name='object'>Object Functions</a>

### <a name='identity'>identity(obj) -> obj</a>
```lua

```

### <a name='isArray'>isArray(obj) -> boolean</a>
```lua

```

### <a name='isBoolean'>isBoolean(obj) -> boolean</a>
```lua

```

### <a name='isEmpty'>isEmpty(obj) -> boolean</a>
```lua

```

### <a name='isFinite'>isFinite(obj) -> boolean</a>
```lua

```

### <a name='isFunction'>isFunction(obj) -> boolean</a>
```lua

```

### <a name='isNaN'>isNaN(obj) -> boolean</a>
```lua

```

### <a name='isNil'>isNil(obj) -> boolean</a>
```lua

```

### <a name='isNumber'>isNumber(obj) -> boolean</a>
```lua

```

### <a name='isObject'>isObject(obj) -> boolean</a>
```lua

```

### <a name='isString'>isString(obj) -> boolean</a>
```lua

```

### <a name='isEmpty'>isEmpty</a>

## <a name='utility'>Utility Functions</a>


## <a name='chaining'>Chaining Functions</a>

### <a name='chain'>chain(obj) -> boolean</a>
```lua

```

### <a name='value'>value(obj) -> boolean</a>
```lua

```

