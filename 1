util = require "util"
db = require("../lib/couchdb").getInstance()
Aggregate = require "../lib/aggregate"
jasmine = require "jasmine-node"

describe "Aggregate", ->
  Foo = undefined
  foo = undefined
  dbGetEventsByAggregateSpy = undefined
  beforeEach ->
    Foo = (id, callback) ->
      Aggregate.call this, id, callback

    util.inherits Foo, Aggregate
    dbGetEventsByAggregateSpy =  spyOn(db, "getEventsByAggregate").andCallFake (id, callback) ->
      callback []
    foo = new Foo 1
  describe "constructor", ->
    it "should load data from the event bus", ->
      foo = new Foo 1
      expect(db.getEventsByAggregate).toHaveBeenCalledWith(1, jasmine.any(Function))
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
      spyOn db , "storeEvent"
      foo.emit 'foo', foo: 'bar'
      expect(db.storeEvent).toHaveBeenCalledWith 1, 'foo', foo: 'bar'

