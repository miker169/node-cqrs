Repository = require "../lib/repository"

describe "Repository", ->
  repository = undefined
  beforeEach ->
    repository = new Repository 'foo' 
  it "should exist", ->
    expect(Repository).toBeDefined()
    expect(typeof Repository).toEqual 'function'
  it "should store thr strategy object", ->
    expect(repository.strategy).toEqual 'foo'
