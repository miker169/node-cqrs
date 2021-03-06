util = require "util"
couchdb = require("../lib/repository/couchRepository").getInstance()
repository = require("../lib/repository").getInstance()
Aggregate = require "../lib/aggregate"
jasmine = require "jasmine-node"

describe "Aggregate", ->
  Foo = undefined
  foo = undefined
  dbGetEventsByAggregateSpy = undefined
  beforeEach ->
    repository.strategy = couchdb
    Foo = (id, callback) ->
      Aggregate.call this, id, callback

    util.inherits Foo, Aggregate
    dbGetEventsByAggregateSpy =  spyOn(repository, "getEventsByAggregate").andCallFake (id, callback) ->
      callback []
    foo = new Foo 1
  describe "constructor", ->
    it "should load data from the event bus", ->
      foo = new Foo 1
    it "should be extendable", ->
      expect(typeof Aggregate.extend).toEqual 'function'
      expect(repository.getEventsByAggregate).toHaveBeenCalledWith(1, jasmine.any(Function))
    it "should call apply for all events", ->
      event = undefined
      runs ->
        event = name: "myEvent"
        dbGetEventsByAggregateSpy.andCallFake (id, callback) ->
          setTimeout (->
            callback [event]
          ), 10
        foo = new Foo 1
        spyOn foo, "apply"
      waits 15
      runs ->
        expect(foo.apply).toHaveBeenCalledWith event
    it "should call callback if require", ->
      @handler = ->

      spyOn this, 'handler'
      foo = new Foo 1, @handler
      expect(@handler).toHaveBeenCalled()
  describe "apply", ->
    it "should raise error if handler is missing", ->
      event = name: "myEvent"
      expect(->
        foo.apply event
      ).toThrow "There is no handler for 'MyEvent' event!"
    it "should call appropriate handler", ->
      event = name: "myEvent"
      Foo::onMyEvent = ->

      spyOn foo, "onMyEvent"
      foo.apply event
      expect(foo.onMyEvent).toHaveBeenCalledWith event
  describe "emit", ->
    it "should store event", ->
      spyOn repository , "storeEvent"
      foo.emit 'foo', foo: 'bar'
      expect(repository.storeEvent).toHaveBeenCalledWith 1, 'foo', foo: 'bar'

