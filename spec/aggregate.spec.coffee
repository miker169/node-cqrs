Aggregate = require "../lib/aggregate"
EventBus = require "../lib/eventBus"
jasmine = require "jasmine-node"

describe 'Aggregate', ->
  beforeEach ->
    EventBus.storeSnapshot = ->

  describe "constructor", ->
    it "should load data from the event bus", ->
      spyOn EventBus, "loadData"
      aggregate = new Aggregate(1)
      expect(EventBus.loadData).toHaveBeenCalledWith 1, jasmine.any(Function)
    describe "load data callback", ->
      aggregate = null
      foo = foo: "bar"
      it "should not call init if no snapshot is ready", ->
        runs ->
          EventBus.loadData = (id, callback) ->
            setTimeout (->
              callback null, [], null
            ), 10
          @aggregate = new Aggregate(1)
          spyOn @aggregate, "init"
        waits 15
        runs ->
          expect(@aggregate.init).not.toHaveBeenCalled()

      it "should call init, if snapshot is ready",  ->
        runs ->
          EventBus.loadData = (id, callback) ->
            setTimeout (->
              callback foo, [], null
            ), 10
          @aggregate = new Aggregate 1
          spyOn @aggregate, "init"
        waits 15
        runs ->
          expect(@aggregate.init).toHaveBeenCalledWith foo
      it "should call apply, for all events", ->
        runs ->
          EventBus.loadData = (id, callback) ->
            setTimeout (->
              callback null, [foo], null
            ), 10
          @aggregate = new Aggregate 1
          spyOn @aggregate, "apply"
        waits 15
        runs ->
          expect(@aggregate.apply).toHaveBeenCalledWith foo
      it "should call store snapshot", ->
        runs ->
          EventBus.loadData = (id, callback) ->
            setTimeout (->
              callback null, [foo], 1
            ), 10
          @aggregate = new Aggregate 1
          spyOn EventBus, "storeSnapshot"
          spyOn(@aggregate, "snapshot").andReturn foo
        waits 15
        runs ->
          expect(EventBus.storeSnapshot).toHaveBeenCalledWith 1, 1, foo
      it "should call callback if one is specified", ->
        @handler = ->
        EventBus.loadData = (id, callback) ->
          callback null, [foo], 1
        spyOn this, "handler"
        @aggregate = new Aggregate 1, @handler
        expect(@handler).toHaveBeenCalled()



