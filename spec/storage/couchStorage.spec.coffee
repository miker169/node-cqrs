CouchStorage = require "../../lib/storage/couch"

describe "CouchStorage", ->
  it "should be defined", ->
    expect(typeof CouchStorage).toEqual 'function'
