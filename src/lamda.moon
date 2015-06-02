--
-- lamda.moon
--
-- Inspired by Ramda. (ramdajs.com)
--

-- ========== Ramda Functions ==========

l = {}


l.compose = (...) ->
    funcs = {...}

    (...) ->
        args = {...}

        reversed = {}
        for i = #funcs, 1, -1
            table.insert reversed, funcs[i]

        f = (func) ->
            args = {func(unpack(args))}

        l.forEach f, reversed

        args[1]

-- aka 'each'
l.forEach = (func, list) ->
    pairing = pairs
    if l.isArrayLike(list) then pairing = ipairs

    for index, value in pairing(list)
        func(value)


l.forEachIndexed = (func, list) ->
    pairing = pairs
    if l.isArrayLike(list) then pairing = ipairs

    for index, value in pairing(list)
        func(value, index, list)


l.identity = (value) ->
    value


l.isArrayLike = (value) ->
    if type(value) == "table" and (value[1] or next(value) == nil)
        true
    else
        false


l.isEmpty = (value) ->
    if not value 
        return true
    elseif l.isArrayLike(value) or l.isObject(value)
        return next(value) == nil
    elseif l.isString(value)
        return string.len(value) == 0
    else
        return false

-- aka 'collect'
l.map = (func, list) ->
    pairing = pairs
    if l.isArrayLike(list) then pairing = ipairs

    newList = {}
    for index, value in pairing(list)
        table.insert newList, func(value)

    newList


l.memoize = (func) ->
    list = {}

    return (...) ->
        if not list[...]
            list[...] = func(...)

        return list[...]


l.wrap = (func, wrapper) ->
    return (...) ->
        return wrapper(func, ...)


-- ========== List Functions ==========

l.slice = (list, start, stop) ->
    array = {}
    stop = stop or #list

    for index = start, stop, 1 do
        table.insert(array, list[index])

    return array


l.join = (list, separator) ->
    separator = separator or ""
    table.concat(list,separator) 


-- aka 'first'
l.head = (list, count) ->
    if not list then return nil

    if not count then
        list[1]
    else
        l.slice(list, 1, count)


l.tail = (list, start) ->
    start = start or 2

    return l.slice(list, start, #list)

-- aka 'filter'
l.select = (func, list) ->
    found = {}
    f = (value, key, object) ->
        if func(value, key, object)
            table.insert(found, value)

    l.forEach f, list
    found


l.reject = (func, list) ->
    found = {}
    f = (value, key, object) ->
        if not func(value, key, object)
            table.insert(found, value)

    l.forEach f, list
    found


-- aka 'inject', 'foldl'
l.reduce = (func, list, memo) ->
    init = memo == nil
    f = (value, key, object) ->
        if init
            memo = value
            init = false
        else
            memo = func(memo, value, key, object)
    
    l.forEach f, list

    if init then
        error("Reduce of empty array with no initial value")

    memo


-- aka 'foldr'
l.reduceRight = (func, list, memo) ->
    l.reduce func, l.reverse(list), memo


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



l.any = (func, list) ->
    if l.isEmpty(list) 
        return false

    func = func or l.identity
    found = false
    f = (value, index, object) ->
        if not found and func(value, index, object)
            found = true
    l.forEach f, list

    found


l.all = (func, list) ->
    if l.isEmpty list
        return false

    func = func or _.identity

    found = true
    f = (value, index, object) ->
        if found and not func(value, index, object)
            found = false
    l.forEach f, list

    found


l.flatten = (list, shallow, output) ->
    output = output or {}

    f = (value) ->
        if l.isArrayLike(value) then
            if shallow then
                l.forEach ((v) -> table.insert(output, v)), value
            else
                l.flatten(value, false, output)
        else
            table.insert(output, value)

    l.forEach f, list
    return output


l.concat = (...) ->
    values = l.flatten({...}, true)
    cloned = {}

    f = (v) ->
        table.insert(cloned, v)
    l.forEach f, values 

    return cloned


l.partial = (func, ...) ->
    args = {...}
    return (self, ...) ->
        return func(self, unpack(l.concat(args, {...})))



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
    num_args = num_args or 2
  
    -- helper
    curry_h = (argtrace, n) ->
        if 0 == n then
            -- reverse argument list and call function
            return func(l.__reverse(argtrace()))
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
l.__reverse = (...) ->
   
    --reverse args by building a function to do it, similar to the unpack() example
    reverse_h = (acc, v, ...) ->
        if 0 == select('#', ...) then
            return v, acc()
        else
            return reverse_h((-> return v, acc()), ...)
   
    -- initial acc is the end of the list
    return reverse_h((-> return), ...)


-- ========== Non-Ramda Functions ==========

l.isObject = (value) ->
    type(value) == "table"


l.isString = (value) ->
    type(value) == "string"


l.last = (list, count) ->
    if not list then return nil

    if not count then
        return list[#list]
    else
        start, stop, array = #list - count + 1, #list, {}
        return l.slice(list, start, stop)





-- ===========================================

-- ========== In Process Functions ==========




l.createCompose = (...) ->

    va = {...}

    fn = va[#va]
    --for i = #va, 2, -1
    --    fn = va[i](va[i-1], )

    fn





l
