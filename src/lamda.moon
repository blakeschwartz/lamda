--
-- lamda.moon
--
-- Inspired by Ramda. (ramdajs.com)
--

-- ========== Ramda Functions ==========

l = {}



-- ==============================
-- === Array 
-- ==============================

l.slice = (list, start, stop) ->
    array = {}
    stop = stop or #list

    for index = start, stop, 1
        table.insert(array, list[index])

    return array


l.join = (list, separator = "") ->
    table.concat(list, separator) 


l.head = (list, count = 1) ->
    if not list or #list < 1
        return nil

    if count == 1 -- optimization
        list[1]
    else
        unpack l.slice(list, 1, count)

-- head aka:
l.first = l.head
l.take = l.head


-- count represents the size of the head.
l.tail = (list, count = 1) ->
    if not list or #list < 2 then return nil

    start, stop, array = count + 1, #list, {}
    l.slice(list, start, stop)

-- head aka:
l.drop = l.tail
l.rest = l.tail


l.last = (list, count = 1) ->
    if not list then return nil

    if count == 1
        return list[#list]
    else
        start, stop, array = #list - count + 1, #list, {}
        unpack l.slice(list, start, stop)


l.reverse = (list) ->
    --if _.isString(list)
    --    return _(list).chain():split():reverse():join():value()
    --else
    length = #list
    newList = {}
    for i = 1, length / 2, 1
        newList[i], newList[length-i+1] = list[length-i+1], list[i]

    if #list % 2 > 0
        center = math.floor(#list / 2 + 1)
        newList[center] = list[center] 

    newList


-- ==============================
-- === Collection 
-- ==============================

l.map = (func, coll) ->
    pairing = pairs
    if l.isArray(coll) then pairing = ipairs

    newList = {}
    for index, value in pairing(coll)
        table.insert newList, func(value)

    newList

-- collect aka:
l.collect = l.map



l.filter = (func, coll) ->
    found = {}
    f = (value, key, object) ->
        if func(value, key, object)
            table.insert(found, value)

    l.each f, coll
    found

-- filter aka:
l.select = l.filter



l.reject = (func, coll) ->
    found = {}
    f = (value, key, object) ->
        if not func(value, key, object)
            table.insert(found, value)

    l.each f, coll
    found


l.reduce = (func, memo, coll) ->
    --init = memo == nil
    --f = (value, key, object) ->
    --    if init
    --        memo = value
    --        init = false
    --    else
    --        memo = func(memo, value, key, object)
    
    f = (value) ->
        memo = func(memo, value)

    l.each f, coll

    --if init then
    --    error("Reduce of empty array with no initial value")

    memo

-- reduce aka:
l.inject = l.reduce
l.fold = l.reduce
l.foldl = l.reduce


l.reduceRight = (func, memo, coll) ->
    l.reduce func, memo, l.reverse(coll)

-- reduceRight aka:
l.foldr = l.reduceRight


l.each = (func, coll) ->
    pairing = pairs
    if l.isArray(coll) then pairing = ipairs

    for index, value in pairing(coll)
        --print value
        func(value)

l.forEach = l.each


l.eachIndexed = (func, coll) ->
    pairing = pairs
    if l.isArray(coll) then pairing = ipairs

    for index, value in pairing(coll)
        func(value, index, coll)

l.forEachIndexed = l.eachIndexed


l.any = (func, coll) ->
    if l.isEmpty(coll) 
        return false

    func = func or l.identity
    found = false
    f = (value, index, object) ->
        if not found and func(value, index, object)
            found = true
    l.each f, coll

    found


l.all = (func, coll) ->
    if l.isEmpty coll
        return false

    func = func or _.identity

    found = true
    f = (value, index, object) ->
        if found and not func(value, index, object)
            found = false
    l.each f, coll

    found


l.flatten = (coll, shallow, output) ->
    output = output or {}

    f = (value) ->
        if l.isArray(value) then
            if shallow then
                l.each ((v) -> table.insert(output, v)), value
            else
                l.flatten(value, false, output)
        else
            table.insert(output, value)

    l.each f, coll
    return output


l.concat = (...) ->
    values = l.flatten({...}, true)
    --print values
    cloned = {}

    f = (value) ->
        table.insert(cloned, value)
    l.each f, values 

    return cloned


-- ==============================
-- === Functional 
-- ==============================

l.partial = (func, ...) ->
    args = {...}
    return (...) ->
        return func(unpack(l.concat(args, {...})))



-- ========== Curry Function ==========

-- Lua implementation of the curry function
-- Developed by tinylittlelife.org
-- released under the WTFPL (http://sam.zoy.org/wtfpl/)
 
-- curry(func, num_args) : take a function requiring a tuple for num_args arguments
--              and turn it into a series of 1-argument functions
-- e.g.: you have a function dosomething(a, b, c)
--       curried_dosomething = curry(dosomething, 3) -- we want to curry 3 arguments
--       curried_dosomething (a1) (b1) (c1)  -- returns the result of dosomething(a1, b1, c1)
--       partial_dosomething1 = curried_dosomething (a_value) -- returns a function
--       partial_dosomething2 = partial_dosomething1 (b_value) -- returns a function
--       partial_dosomething2 (c_value) -- returns the result of dosomething(a_value, b_value, c_value)
l.curry = (func, num_args) ->
  
    -- currying 2-argument functions seems to be the most popular application
    --num_args = num_args or 2
    num_args = num_args or debug.getinfo(func, "u").nparams
  
    -- helper
    curry_h = (argtrace, n) ->
        if 0 == n then
            -- reverse argument list and call function
            return func(l.reverseArgs(argtrace()))
        else
            -- "push" argument (by building a wrapper function) and decrement n
            return (onearg) ->
                return curry_h((-> return onearg, argtrace()), n - 1)
   
    -- no sense currying for 1 arg or less
    if num_args > 1 then
        return curry_h((-> return), num_args)
    else
        return func
   
-- reverse(...) : take some tuple and return a tuple of elements in reverse order
--
-- e.g. "reverse(1,2,3)" returns 3,2,1
l.reverseArgs = (...) ->
   
    --reverse args by building a function to do it, similar to the unpack() example
    reverse_h = (acc, v, ...) ->
        if 0 == select('#', ...) then
            return v, acc()
        else
            return reverse_h((-> return v, acc()), ...)
   
    -- initial acc is the end of the list
    return reverse_h((-> return), ...)



l.compose = (...) ->
    funcs = {...}

    if #funcs < 1
        return nil

    (...) ->
        args = {...}

        if #args == 0 then return ->

        reversed = {}
        for i = #funcs, 1, -1
            table.insert reversed, funcs[i]

        f = (func) ->
            args = {func(unpack(args))}

        l.forEach f, reversed

        args[1]


l.memoize = (func) ->
    list = {}

    return (...) ->
        if not list[...]
            list[...] = func(...)

        return list[...]


l.wrap = (func, wrapper) ->
    return (...) ->
        return wrapper(func, ...)


-- ==============================
-- === Objects
-- ==============================

l.identity = (value) ->
    value


l.isBoolean = (value) ->
    type(value) == "boolean"


l.isFinite = (value) ->
    l.isNumber(value) and -math.huge < value and value < math.huge


l.isObject = (value) ->
    type(value) == "table"


l.isString = (value) ->
    type(value) == "string"


l.isNaN = (value) ->
    l.isNumber(value) and value ~= value


l.isNil = (value) ->
    value == nil


l.isNumber = (value) ->
    type(value) == "number"


l.isFunction = (value) ->
    type(value) == "function"


l.isArray = (value) ->
    if type(value) == "table" and (value[1] or next(value) == nil)
        true
    else
        false


l.isEmpty = (value) ->
    if not value 
        return true
    elseif l.isArray(value) or l.isObject(value)
        return next(value) == nil
    elseif l.isString(value)
        return string.len(value) == 0
    else
        return false


-- ==============================
-- === Experimental / Pending
-- ==============================

l.cmap = l.curry(l.map)

l.creduce = l.curry(l.reduce, 3)


-- ==============================
-- === End 
-- ==============================

l
