local l = { }
l.slice = function(list, start, stop)
  local array = { }
  stop = stop or #list
  for index = start, stop, 1 do
    table.insert(array, list[index])
  end
  return array
end
l.join = function(list, separator)
  separator = separator or ""
  return table.concat(list, separator)
end
l.head = function(list, count)
  if count == nil then
    count = 1
  end
  if not list or #list < 1 then
    return nil
  end
  if count == 1 then
    return list[1]
  else
    return unpack(l.slice(list, 1, count))
  end
end
l.first = l.head
l.take = l.head
l.tail = function(list, count)
  if not list or #list < 2 then
    return nil
  end
  if not count then
    count = 1
  end
  local start, stop, array = count + 1, #list, { }
  return l.slice(list, start, stop)
end
l.drop = l.tail
l.rest = l.tail
l.last = function(list, count)
  if count == nil then
    count = 1
  end
  if not list then
    return nil
  end
  if count == 1 then
    return list[#list]
  else
    local start, stop, array = #list - count + 1, #list, { }
    return unpack(l.slice(list, start, stop))
  end
end
l.reverse = function(list)
  local length = #list
  local newList = { }
  for i = 1, length / 2, 1 do
    newList[i], newList[length - i + 1] = list[length - i + 1], list[i]
  end
  if #list % 2 > 0 then
    local center = math.floor(#list / 2 + 1)
    newList[center] = list[center]
  end
  return newList
end
l.map = function(func, list)
  local pairing = pairs
  if l.isArray(list) then
    pairing = ipairs
  end
  local newList = { }
  for index, value in pairing(list) do
    table.insert(newList, func(value))
  end
  return newList
end
l.collect = l.map
l.filter = function(func, coll)
  local found = { }
  local f
  f = function(value, key, object)
    if func(value, key, object) then
      return table.insert(found, value)
    end
  end
  l.each(f, coll)
  return found
end
l.select = l.filter
l.reject = function(func, coll)
  local found = { }
  local f
  f = function(value, key, object)
    if not func(value, key, object) then
      return table.insert(found, value)
    end
  end
  l.each(f, coll)
  return found
end
l.reduce = function(func, memo, coll)
  local f
  f = function(value)
    memo = func(memo, value)
  end
  l.each(f, coll)
  if init then
    error("Reduce of empty array with no initial value")
  end
  return memo
end
l.inject = l.reduce
l.fold = l.reduce
l.foldl = l.reduce
l.reduceRight = function(func, memo, coll)
  return l.reduce(func, memo, l.reverse(coll))
end
l.foldr = l.reduceRight
l.each = function(func, coll)
  local pairing = pairs
  if l.isArray(coll) then
    pairing = ipairs
  end
  for index, value in pairing(coll) do
    func(value)
  end
end
l.forEach = l.each
l.eachIndexed = function(func, coll)
  local pairing = pairs
  if l.isArray(coll) then
    pairing = ipairs
  end
  for index, value in pairing(coll) do
    func(value, index, coll)
  end
end
l.forEachIndexed = l.eachIndexed
l.any = function(func, coll)
  if l.isEmpty(coll) then
    return false
  end
  func = func or l.identity
  local found = false
  local f
  f = function(value, index, object)
    if not found and func(value, index, object) then
      found = true
    end
  end
  l.each(f, coll)
  return found
end
l.all = function(func, coll)
  if l.isEmpty(coll) then
    return false
  end
  func = func or _.identity
  local found = true
  local f
  f = function(value, index, object)
    if found and not func(value, index, object) then
      found = false
    end
  end
  l.each(f, coll)
  return found
end
l.flatten = function(coll, shallow, output)
  output = output or { }
  local f
  f = function(value)
    if l.isArray(value) then
      if shallow then
        return l.forEach((function(v)
          return table.insert(output, v)
        end), value)
      else
        return l.flatten(value, false, output)
      end
    else
      return table.insert(output, value)
    end
  end
  l.each(f, coll)
  return output
end
l.concat = function(...)
  local values = l.flatten({
    ...
  }, true)
  local cloned = { }
  local f
  f = function(value)
    return table.insert(cloned, value)
  end
  l.each(f, values)
  return cloned
end
l.partial = function(func, ...)
  local args = {
    ...
  }
  return function(...)
    return func(unpack(l.concat(args, {
      ...
    })))
  end
end
l.curry = function(func, num_args)
  num_args = num_args or debug.getinfo(func, "u").nparams
  local curry_h
  curry_h = function(argtrace, n)
    if 0 == n then
      return func(l.reverseArgs(argtrace()))
    else
      return function(onearg)
        return curry_h((function()
          return onearg, argtrace()
        end), n - 1)
      end
    end
  end
  if num_args > 1 then
    return curry_h((function() end), num_args)
  else
    return func
  end
end
l.reverseArgs = function(...)
  local reverse_h
  reverse_h = function(acc, v, ...)
    if 0 == select('#', ...) then
      return v, acc()
    else
      return reverse_h((function()
        return v, acc()
      end), ...)
    end
  end
  return reverse_h((function() end), ...)
end
l.compose = function(...)
  local funcs = {
    ...
  }
  if #funcs < 1 then
    return nil
  end
  return function(...)
    local args = {
      ...
    }
    if #args == 0 then
      return function() end
    end
    local reversed = { }
    for i = #funcs, 1, -1 do
      table.insert(reversed, funcs[i])
    end
    local f
    f = function(func)
      args = {
        func(unpack(args))
      }
    end
    l.forEach(f, reversed)
    return args[1]
  end
end
l.memoize = function(func)
  local list = { }
  return function(...)
    if not list[...] then
      list[...] = func(...)
    end
    return list[...]
  end
end
l.wrap = function(func, wrapper)
  return function(...)
    return wrapper(func, ...)
  end
end
l.identity = function(value)
  return value
end
l.isObject = function(value)
  return type(value) == "table"
end
l.isString = function(value)
  return type(value) == "string"
end
l.isArray = function(value)
  if type(value) == "table" and (value[1] or next(value) == nil) then
    return true
  else
    return false
  end
end
l.isEmpty = function(value)
  if not value then
    return true
  elseif l.isArray(value) or l.isObject(value) then
    return next(value) == nil
  elseif l.isString(value) then
    return string.len(value) == 0
  else
    return false
  end
end
return l
