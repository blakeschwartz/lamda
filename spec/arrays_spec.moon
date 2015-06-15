
l = require "src/lamda"


describe "#array,", ->

    list = {"a", "b", "c", "d", "e", "f"}
    nums = {1, 2, 3, 4, 5}

    describe "head,", ->

        it "get head from nil list", ->
            assert.are.equal nil, l.head(nil)

        it "get head from empty list", ->
            assert.are.equal nil, l.head({})

        it "get head from short list", ->
            assert.are.equal "a", l.head({"a"})

        it "get head", ->
            assert.are.equal "a", l.head(list)

        it "get head 2", ->
            a, b = l.head(list, 2)
            assert.are.same "a", a
            assert.are.same "b", b

        it "test aliases", ->
            assert.are.equal l.head(list), l.first(list)
            assert.are.equal l.head(list), l.take(list)

    describe "tail,", ->

        it "get tail from nil list", ->
            assert.are.same nil, l.tail(nil)

        it "get tail from empty list", ->
            assert.are.same nil, l.tail({})

        it "get tail from short list", ->
            assert.are.same nil, l.tail({'a'})

        it "get tail", ->
            assert.are.same {"b", "c", "d", "e", "f"}, l.tail(list)

        it "get tail 2", ->
            assert.are.same {"c", "d", "e", "f"}, l.tail(list, 2)

        it "get drop 4", ->
            assert.are.same {"e", "f"}, l.drop(list, 4)

        it "get rest", ->
            assert.are.same {"b", "c", "d", "e", "f"}, l.rest(list)

        it "get last", ->
            assert.are.same "f", l.last(list)

        it "get last 2", ->
            e, f = l.last(list, 2)
            assert.are.same "e", e 
            assert.are.same "f", f


