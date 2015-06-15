
l = require "src/lamda"


describe "#collection,", ->

    list = {"a", "b", "c", "d", "e", "f"}
    nums = {1, 2, 3, 4, 5}

    describe "select/reject,", ->

        it "select", ->
            f = (x) -> x > "b" and x < "f"
            assert.are.same {"c", "d", "e"}, l.select(f, list)

        it "test aliases", ->
            f = (x) -> x > "b" and x < "f"
            assert.are.same l.select(f, list), l.filter(f, list)

        it "reject", ->
            f = (x) -> x > "b" and x < "f"
            assert.are.same {"a", "b", "f"}, l.reject(f, list)

    describe "map,", ->
        arrayn = {2, 4, 6, 8}
        arraya = {"A", "B", "C", "D"}
        times2 = (x) -> x * 2
        prefixi = (x) -> "i"..x

        it "map numbers", ->
            assert.are.same( {4, 8, 12, 16}, l.map( times2, arrayn ) )

        it "map strings", ->
            assert.are.same( {"iA", "iB", "iC", "iD"}, l.map( prefixi, arraya ) )

        it "collect", ->
            assert.are.same( l.map( times2, arrayn ), l.collect( times2, arrayn ) )

    describe "reduce,", ->

        it "reduce numeric", ->
            add = (a, b) -> a + b
            assert.are.equal 15, l.reduce(add, 0, nums)

        it "reduce strings", ->
            concat = (a, b) -> a .. b
            assert.are.equal "abcdef", l.reduce(concat, "", list)

        it "reduceRight numeric", ->
            add = (a, b) -> a + b
            assert.are.equal 15, l.reduceRight(add, 0, nums)

        it "reduceRight strings", ->
            concat = (a, b) -> a .. b
            assert.are.equal "fedcba", l.reduceRight(concat, "", list)

        it "curry/reduce strings", ->
            concat = (a, b) -> a .. b
            f = l.curry l.reduce, 3
            g = f(concat)
            h = g("")
            assert.are.same "abcdef", h(list)

    describe "other,", ->

        it "#flatten", ->
            arr1 = {1, 2, 3, 4}
            assert.are.same {1, 2, 3, 4}, l.flatten(arr1)
            assert.are.same {1, 2, 3, 4}, l.flatten(arr1, true)

            arr2 = {5, {6, 7}, 8}
            assert.are.same {5, 6, 7, 8}, l.flatten(arr2)


        it "#concat", ->
            arr1 = {1, 2, 3, 4}
            arr2 = {5, {6, 7}, 8}
            assert.are.same {1, 2, 3, 4, 5, {6, 7}, 8}, l.concat(arr1, arr2)


        it "join", ->
            assert.are.equal "abcdef", l.join(list)

        it "any", ->
            f = (x) -> x > 'a' and x < 'd'
            assert.is_true l.any(f, list)

        it "not any", ->
            f = (x) -> x > 'g'
            assert.is_false l.any(f, list)

        it "all", ->
            f = (x) -> x >= 'a' and x <= 'f'
            assert.is_true l.all(f, list)

            f = (x) -> x >= 'a' and x <= 'd'
            assert.is_not_true l.all(f, list)

        it "not all", ->
            f = (x) -> x >= 'a' and x <= 'e'
            assert.is_false l.all(f, list)

        it "eachIndexed", ->
            array = {2, 4, 6, 8}
            times2 = (x, index, list) -> list[index] = x * 2

            l.eachIndexed( times2, array )
            assert.are.same( {4, 8, 12, 16}, array )

