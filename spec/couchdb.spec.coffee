http = require "http"
jasmine = require "jasmine-node"
CouchDb = require "../lib/couchdb"
describe "couchdb", ->
  couchdb = undefined
  beforeEach ->
    couchdb = new CouchDb()
  it "host should default to the localhost", ->
    expect(couchdb.options.host).toEqual "localhost"
  it "port should default to 5984", ->
    expect(couchdb.options.port).toEqual 5984
  describe "request", ->
    req = undefined
    beforeEach ->
      req = Object.create(end: ->
      )
      spyOn(http, "request").andReturn req
    it "should call http.request with valid params", ->
      couchdb.request()
      expect(http.request).toHaveBeenCalledWith couchdb.options, jasmine.any(Function)

    it "should setup with the correct default options", ->
      couchdb.options = {}
      couchdb.request()
      expect(http.request).toHaveBeenCalledWith
        method: "GET"
        path: "/"
      , jasmine.any(Function)
    it "should call post", ->
      couchdb.options = {}
      couchdb.request method: "POST"
      expect(http.request).toHaveBeenCalledWith
        method: 'POST'
        path: "/"
      , jasmine.any(Function)
    it "should call proper url", ->
      couchdb.options = {}
      couchdb.request path: "/foo"
      expect(http.request).toHaveBeenCalledWith
        method: "GET"
        path: "/foo"
      , jasmine.any(Function)
    it "should write data to the request and end it", ->
      spyOn req, "end"
      couchdb.request()
      expect(req.end).toHaveBeenCalled()
