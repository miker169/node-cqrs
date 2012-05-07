Repository = require "../lib/repository"

describe "Repository", ->
  it "should exist", ->
    expect(Repository).toBeDefined()
    expect(typeof Repository).toEqual 'function'
