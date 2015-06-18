
l = require "src/lamda"
c = require "src/lamdac"


describe "Collection,", ->

    it "all", ->
		arr = {1, 2, 3, 4}
		gtZero = (x) -> x > 0

		res = l.all gtZero, arr 
        assert.are.same( true, res )

    it "any", ->
		arr = {0, 1, 2, 3, 4}
		ltZero = (x) -> x < 0

		res = l.any ltZero, arr
        assert.are.same( false, res )

    it "each", ->
		arr = {1, 2, 3, 4}
		printit = (x) -> --print x

		l.each printit, arr 

    it "map", ->
		coll = {1, 2, 3, 4, 5}
		times2 = (x) -> x * 2
		res = c.map(times2)(coll)
		assert.are.same( {2, 4, 6, 8, 10}, res )


describe "Array,", ->

    it "head", ->
		arr = {1, 2, 3, 4, 5}
		a = l.head arr
		assert.are.same 1, a

		a, b = l.head arr, 2
		assert.are.same 1, a
		assert.are.same 2, b

    it "tail", ->
		arr = {1, 2, 3, 4, 5}
		a = l.tail arr
		assert.are.same {2, 3, 4, 5}, a

		a = l.tail arr, 2
		assert.are.same {3, 4, 5}, a


describe "Functional,", ->

    it "compose 3 functions", ->
        times2 = (x) -> x * 2
        times3 = (x) -> x * 3
        square = (x) -> x * x 

        f = l.compose times3, times2, square
        assert.are.equal 150, f(5)

    it "curry", ->
		times2 = (x) -> x * 2
		mapTimes2 = c.map times2 

		res = mapTimes2 {1, 2, 3, 4, 5}
        assert.are.same( {2, 4, 6, 8, 10}, res )

		res = mapTimes2 {10, 20, 30, 40, 50}
        assert.are.same( {20, 40, 60, 80, 100}, res )


describe "Object,", ->


describe "Utility,", ->


describe "Chaining,", ->
