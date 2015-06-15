
l = require "src/lamda"


describe "lamda tests 3,", ->

    it "forEachIndexed", ->
        array = {2, 4, 6, 8}
        times2 = (x, index, list) -> list[index] = x * 2

        l.forEachIndexed( times2, array )

        assert.are.same( {4, 8, 12, 16}, array )



