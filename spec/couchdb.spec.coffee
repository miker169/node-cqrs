http = require "http"
jasmine = require "jasmine-node"
CouchDb = require "../lib/couchdb"
EventEmitter = require("events").EventEmitter
describe "couchdb", ->
  couchdb = undefined
  beforeEach ->
    couchdb = new CouchDb('cqrs')
  it "should store database name", ->
    expect(couchdb.database).toEqual 'cqrs'
  it "host should default to the localhost", ->
    expect(couchdb.options.host).toEqual "localhost"
  it "port should default to 5984", ->
    expect(couchdb.options.port).toEqual 5984
  describe "createDocument", ->
    it "should call proper request", ->
      data = JSON.stringify foo: "bar"
      options =
        method: "PUT"
        path: "/cqrs/1234"
        data: data
      spyOn couchdb, "request"
      spyOn(couchdb, 'getUuid').andReturn '1234'
      couchdb.createDocument data
      expect(couchdb.request).toHaveBeenCalledWith options

  describe "getUuid", ->
    it "should call proper request", ->
      options =
        path: '/_uuids'
        method: 'GET'
      spyOn couchdb, 'request'
      couchdb.getUuid()
      expect(couchdb.request).toHaveBeenCalledWith options

  describe "request", ->
    req = undefined
    beforeEach ->
      req = Object.create(
        end: ->

        write: ->
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
    it "should end request", ->
      spyOn req, "end"
      couchdb.request()
      expect(req.end).toHaveBeenCalled()
    it "should write data to request if specified", ->
      spyOn req, "write"
      couchdb.request data: "foo"
      expect(req.write).toHaveBeenCalledWith "foo"
    describe "response", ->
      res = undefined
      httpRequest = undefined
      beforeEach ->
        res = new EventEmitter()
        httpRequest = http.request
        http.request = (params, callback) ->
          callback res
          req
      afterEach ->
        http.request = httpRequest
      it "should register handler for data event", ->
        spyOn res, "on"
        couchdb.request()
        expect(res.on).toHaveBeenCalledWith "data", jasmine.any(Function)
        expect(res.on).toHaveBeenCalledWith "end", jasmine.any(Function)
      it "should call callback if response ends", ->
          foo = callback: ->

          spyOn foo, "callback"
          couchdb.request {}, foo.callback
          res.emit "end", "foo"
          expect(foo.callback).toHaveBeenCalledWith "foo"
      it "should call store data into buffer", ->
        foo = callback: ->

        spyOn foo, 'callback'
        couchdb.request {}, foo.callback
        res.emit "data", "foo"
        res.emit "end", ""
        expect(foo.callback).toHaveBeenCalledWith "foo"


