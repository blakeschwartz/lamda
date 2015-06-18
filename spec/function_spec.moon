
l = require "src/lamda"
c = require "src/lamdac"


describe "#function,", ->

    describe "curry,", ->

        it "curry single", ->
            add4 = (a, b, c, d) -> a + b + c + d

            curried1 = l.curry add4

            curried2 = curried1(5)
            curried3 = curried2(11)
            curried4 = curried3(14)
            assert.are.equal 50, curried4(20)

        it "curry multiple", ->
            add4 = (a, b, c, d) -> a + b + c + d

            curried1 = l.curry add4

            curried2 = curried1(5)
            curried4 = curried2(11)(14)
            assert.are.equal 50, curried4(20)

        it "curry map/reduce", ->
            times2 = (x) -> x * 2

            f = c.map(times2)

            arr = {1, 2, 3, 4, 5}
            assert.are.same {2, 4, 6, 8, 10}, f(arr) 


    describe "auto curry test,", ->

        it "curry map/reduce", ->
            arr = {1, 2, 3, 4, 5}
            res = c.map((x) -> x * 2)(arr)
            assert.are.same {2, 4, 6, 8, 10}, res

        it "curry map/reduce", ->
            f = c.map((x) -> x * 2)
            arr = {1, 2, 3, 4, 5}
            assert.are.same {2, 4, 6, 8, 10}, f(arr) 

        it "curry map/reduce string", ->

            -- prefix 'i' to string
            map = c.map (x) -> "i"..x

            -- join array elements with '_'
            reduce = c.reduce ((x, y) -> x.."_"..y)
            reduce = reduce("")

            f = l.compose reduce, map

            arr = {"A", "B", "C", "D"}
            assert.are.same "_iA_iB_iC_iD", f(arr) 


    describe "partial,", ->

        it "partial 1", ->
            add4 = (a, b, c, d) -> a + b + c + d

            f = l.partial add4, 5, 11, 14

            assert.are.equal 50, f(20)

        it "partial 2", ->
            add4 = (a, b, c, d) -> a + b + c + d

            f = l.partial add4, 5, 11
            g = l.partial f, 14

            assert.are.equal 50, g(20)

        it "partial map/func", ->
            times2 = (x) -> x * 2

            f = c.map(times2)

            arr = {1, 2, 3, 4, 5}
            assert.are.same {2, 4, 6, 8, 10}, f(arr) 


    describe "memoize,", ->

        fib = (n) ->
            if n < 2 then
                return n
            else
                return fib(n - 1) + fib(n - 2)

        it "returns a value of fib", ->
            fast_fib = l.memoize(fib)
            assert.are.equal fib(10), 55 
            assert.are.equal fib(10), fast_fib(10)


    describe "compose,", ->

        it "compose 0 function", ->
            times2 = (x) -> x * 2

            f = l.compose()
            assert.are.equal nil, f

        it "compose 1 function", ->
            times2 = (x) -> x * 2

            f = l.compose times2
            assert.are.equal f(5), 10

        it "compose 3 functions", ->
            times2 = (x) -> x * 2
            times3 = (x) -> x * 3
            square = (x) -> x * x 

            f = l.compose times3, times2, square
            assert.are.equal 150, f(5)


    describe "#wrap,", ->

        it "passes arguments ", ->
            greet = (name) -> return "hi: " .. name
            backwards = l.wrap greet, (func, name) ->
                return func(name) .. " " ..  string.reverse(name)

            assert.are.equal backwards("mike"), "hi: mike ekim"


    describe "combination,", ->

        it "curry map/reduce number", ->

            times2 = (x) -> x * 2
            m = l.curry l.map
            m = m(times2)

            sum = (x, y) -> x + y
            r = l.curry l.reduce
            r = r(sum)(0)

            f = l.compose r, m

            arr = {1, 2, 3, 4, 5}
            assert.are.same 30, f(arr) 

        it "curry map/reduce string", ->

            -- prefix 'i' to string
            map = l.curry(l.map)((x) -> "i"..x)

            -- join array elements with '_'
            reduce = l.curry(l.reduce)((x, y) -> x.."_"..y)("")

            f = l.compose reduce, map

            arr = {"A", "B", "C", "D"}
            assert.are.same "_iA_iB_iC_iD", f(arr) 



