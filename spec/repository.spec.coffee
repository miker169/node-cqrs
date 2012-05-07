Repository = require "../lib/repository"

describe "Repository", ->
  strategy = undefined
  repository = undefined
  beforeEach ->
    strategy = 
      storeEvent: ->

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
