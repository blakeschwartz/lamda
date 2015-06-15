
l = require "src/lamda"

describe "#object,", ->

    it "isArray", ->
        array = "hello"
        assert.is_false l.isArray array
        assert.is_true l.isArray {1,2,3}

        array = {}
        assert.is_true l.isArray array

    it "isEmpty", ->

        assert.is_true l.isEmpty ""
        assert.is_true l.isEmpty {}
        assert.is_true l.isEmpty nil

        assert.is_not_true l.isEmpty "Hello"
        assert.is_not_true l.isEmpty {1,2,3}



