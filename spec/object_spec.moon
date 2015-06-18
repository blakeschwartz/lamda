
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

    it "isNumber", ->
        assert.is_true l.isNumber 0
        assert.is_false l.isNumber 'a'
        assert.is_false l.isNumber nil
        assert.is_false l.isNumber {}

    it "isString", ->
        assert.is_true l.isString 'a'
        assert.is_false l.isString 5
        assert.is_false l.isString nil
        assert.is_false l.isString {}

    it "isNil", ->
        assert.is_true l.isNil nil
        assert.is_false l.isNil 'a'
        assert.is_false l.isNil 5
        assert.is_false l.isNil {}

    it "isFunction", ->
        assert.is_true l.isFunction () ->
        assert.is_false l.isFunction 'a'
        assert.is_false l.isFunction 5
        assert.is_false l.isFunction {}

    it "isBoolean", ->
        assert.is_true l.isBoolean true
        assert.is_true l.isBoolean false
        assert.is_false l.isBoolean 'a'
        assert.is_false l.isBoolean 5
        assert.is_false l.isBoolean {}

