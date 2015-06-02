
l = require "src/lamda"


describe "lamda tests", ->

    it "isArrayLike", ->

        array = {}

        array = "hello"

        assert.is_true l.isArrayLike {1,2,3}


describe "lamda tests 2", ->

    it "map", ->

        array = {2, 4, 6, 8}
        times2 = (x) ->
            x * 2

        array2 = l.map( times2, array )

        assert.are.same( {4, 8, 12, 16}, array2 )


describe "lamda tests 3", ->

    it "forEachIndexed", ->

        array = {2, 4, 6, 8}
        times2 = (x, index, list) ->
            list[index] = x * 2

        l.forEachIndexed( times2, array )

        assert.are.same( {4, 8, 12, 16}, array )


describe "lamda tests 4", ->

    it "compose", ->

        times2 = (x) -> x * 2
        times3 = (x) -> x * 3
        square = (x) -> x * x 

        f = l.compose times3, times2, square

        assert.are.equal f(5), 150


describe "lamda tests 5", ->

    it "isEmpty", ->

        assert.is_true l.isEmpty ""
        assert.is_true l.isEmpty {}
        assert.is_true l.isEmpty nil

        assert.is_not_true l.isEmpty "Hello"
        assert.is_not_true l.isEmpty {1,2,3}


describe "#memoize", ->
    fib = (n) ->
        if n < 2 then
            return n
        else
            return fib(n - 1) + fib(n - 2)

    it "returns a value of fib", ->
        fast_fib = l.memoize(fib)
        assert.are.equal fib(10), 55 
        assert.are.equal fast_fib(10), 55


describe "#wrap", ->
    it "passes arguments ", ->
        greet = (name) -> return "hi: " .. name
        backwards = l.wrap greet, (func, name) ->
            return func(name) .. " " ..  string.reverse(name)

        assert.are.equal backwards("moe"), "hi: moe eom"


describe "#Lists", ->
    list = {"a", "b", "c", "d", "e", "f"}
    nums = {1, 2, 3, 4, 5}

    it "get head", ->
        assert.are.equal "a", l.head(list)

    it "get tail", ->
        assert.are.same {"b", "c", "d", "e", "f"}, l.tail(list)

    it "select", ->
        f = (x) -> x > "b" and x < "f"
        assert.are.same {"c", "d", "e"}, l.select(f, list)

    it "reject", ->
        f = (x) -> x > "b" and x < "f"
        assert.are.same {"a", "b", "f"}, l.reject(f, list)

    it "reduce numeric", ->
        add = (a, b) -> a + b
        assert.are.equal 15, l.reduce(add, nums)

    it "reduce strings", ->
        concat = (a, b) -> a .. b
        assert.are.equal "abcdef", l.reduce(concat, list)

    it "reduceRight", ->
        add = (a, b) -> a + b
        assert.are.equal 15, l.reduceRight(add, nums)

    it "reduceRight strings", ->
        concat = (a, b) -> a .. b
        assert.are.equal "fedcba", l.reduceRight(concat, list)

    it "join", ->
        assert.are.equal "abcdef", l.join(list)

    it "any", ->
        f = (x) -> x > 'a' and x < 'd'
        assert.is_true l.any(f, list)

    it "all", ->
        f = (x) -> x >= 'a' and x <= 'f'
        assert.is_true l.all(f, list)

        f = (x) -> x >= 'a' and x <= 'd'
        assert.is_not_true l.all(f, list)


describe "curry", ->
    it "curry 1", ->
        add4 = (a, b, c, d) -> a + b + c + d

        curried1 = l.curry add4, 4

        curried2 = curried1(5)
        curried3 = curried2(11)
        curried4 = curried3(14)
        assert.are.equal 50, curried4(20)

    it "curry 2", ->
        add4 = (a, b, c, d) -> a + b + c + d

        curried1 = l.curry add4, 4

        curried2 = curried1(5)
        curried4 = curried2(11)(14)
        assert.are.equal 50, curried4(20)


describe "partial", ->
    it "partial 1", ->
        add4 = (a, b, c, d) -> a + b + c + d

        f = l.partial add4, 5, 11, 14

        assert.are.equal 50, f(20)

    it "partial 2", ->
        add4 = (a, b, c, d) -> a + b + c + d

        f = l.partial add4, 5, 11
        g = l.partial f, 14

        assert.are.equal 50, g(20)

