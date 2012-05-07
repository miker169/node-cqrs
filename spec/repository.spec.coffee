Repository = require "../lib/repository"

describe "Repository", ->
  strategy = undefined
  repository = undefined
  beforeEach ->
    strategy = 
      storeEvent: ->
      getEventsByAggregate: ->
    repository = new Repository strategy 
  it "should exist", ->
    expect(Repository).toBeDefined()
    expect(typeof Repository).toEqual 'function'
  it "should store thr strategy object", ->
    expect(repository.strategy).toEqual strategy
  it "should be a singleton", ->
    expect(typeof Repository.getInstance).toBe 'function'
  it "should delegate storeEvent method to strategy", ->
    spyOn repository.strategy, 'storeEvent'
    repository.storeEvent()
    expect(repository.strategy.storeEvent).toHaveBeenCalled()

  it "should delegate getEventsByAggregate method to strategy", ->
    spyOn repository.strategy, 'getEventsByAggregate'
    repository.getEventsByAggregate()
    expect(repository.strategy.getEventsByAggregate).toHaveBeenCalled()
  describe "Handlers", ->
    it "should have an empty handler to start", ->
      expect(repository.handlers).toEqual {}
    it "should add event to handlers", ->
      f = ->
      repository.on('foo', f);
      expect(repository.handlers['foo']).toEqual [f]
    it "should allow multiple handlers for the same event", ->
      f = ->
      f2 = ->
      repository.on('foo', f);
      repository.on('foo', f2);
      expect(repository.handlers['foo']).toEqual [f, f2]
    it "should not allow you to add the same handler twice for the same event", ->
      f = ->

      repository.on 'foo', f
      repository.on 'foo', f
      expect(repository.handlers['foo']).toEqual [f]
    it "should not allow you to add the same handler for different events", ->
      f = ->

      repository.on 'foo', f
      repository.on 'foobar', f
      expect(repository.handlers['foo']).toEqual [f]
      expect(repository.handlers['foobar']).toEqual [f]


