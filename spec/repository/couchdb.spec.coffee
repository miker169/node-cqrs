http = require "http"
jasmine = require "jasmine-node"
CouchDb = require "../../lib/repository/couchdb"
EventEmitter = require("events").EventEmitter
describe "couchdb", ->
  couchdb = undefined
  beforeEach ->
    couchdb = new CouchDb('cqrs')
  describe "instance", ->
    it "should get instance of couchdb", ->
      couchdb = CouchDb.getInstance()
      expect(typeof couchdb.request).toEqual "function"
    it "should return just one instance", ->
      couch1 = CouchDb.getInstance()
      couch2 = CouchDb.getInstance()
      couch1.database = "TestDb"
      expect(couch2.database).toEqual "TestDb"

  describe "constructor", ->
    it "should store database name", ->
      expect(couchdb.database).toEqual 'cqrs'
    it "host should default to the localhost", ->
      expect(couchdb.options.host).toEqual "localhost"
    it "port should default to 5984", ->
      expect(couchdb.options.port).toEqual 5984
  describe "storeEvent", ->
    it "should call create Document", ->
      spyOn couchdb, 'createDocument'
      spyOn(Date::, "getTime").andCallFake ->
        123456
      couchdb.storeEvent 1, 'user:created',
        foo: "bar"
      expect(couchdb.createDocument).toHaveBeenCalledWith JSON.stringify(
        aggregateId: 1
        name: "user:created"
        type: "event"
        time: 123456
        attrs:
          foo: "bar"
      )
  describe "getEventsByAggregate", ->
    it "should call request", ->
      spyOn couchdb, 'request'
      couchdb.getEventsByAggregate 1, ->

      expect(couchdb.request).toHaveBeenCalledWith
        method: "GET"
        path: "/cqrs/_design/cqrs/_view/aggregate?startKey=[1,0]&endkey=[1,9999999999999]"
      , jasmine.any Function

    it "should call parseEvents", ->
      f = ->

      spyOn couchdb, "parseEvents"
      spyOn(couchdb, "request").andCallFake (data, callback) ->
        callback "data"

      couchdb.getEventsByAggregate 1, f
      expect(couchdb.parseEvents).toHaveBeenCalledWith "data", f

  describe "getEventsByType", ->
    beforeEach ->
      spyOn(couchdb, 'request').andCallFake (data, callback) ->
       callback "{\"rows\": [{\"_id\":1, \"_ref\":1, \"value\": {\"foo\": \"bar\"}}]}"
    it "should call request", ->
      couchdb.getEventsByName 'foo', ->

      expect(couchdb.request).toHaveBeenCalledWith
        method: 'GET'
        path: '/cqrs/_design/cqrs/_view/name?startkey=["foo",0]&endkey=["foo",9999999999999]'
      , jasmine.any(Function)
    describe "with event list", ->
      it "should call request for each event", ->
        couchdb.getEventsByName [ "foo", "bar"], ->
        expect(couchdb.request).toHaveBeenCalledWith
          method: "GET"
          path: "/cqrs/_design/cqrs/_view/name?startkey=[\"foo\",0]&endkey=[\"foo\",9999999999999]"
        , jasmine.any Function
        expect(couchdb.request).toHaveBeenCalledWith
          method: "GET"
          path: "/cqrs/_design/cqrs/_view/name?startkey=[\"bar\",0]&endkey=[\"bar\",9999999999999]"
        , jasmine.any Function
      it "should call callback just once", ->
        foo = f: ->

        spyOn foo, 'f'
        couchdb.getEventsByName ['foo', 'bar'], foo.f
        expect(foo.f.callCount).toEqual 1

    it "should call parseEvents", ->
      f = ->
      spyOn couchdb, 'parseEvents'
      couchdb.getEventsByName 'foo', f
      expect(couchdb.parseEvents).toHaveBeenCalledWith "{\"rows\": [{\"_id\":1, \"_ref\":1, \"value\": {\"foo\": \"bar\"}}]}", f



  describe "createDocument", ->
    it "should call proper request", ->
      callback = ->

      data = JSON.stringify foo: "bar"
      options =
        path: "/cqrs/1234"
        method: "PUT"
        data: data
      spyOn couchdb, "request"
      spyOn(couchdb, "getUuid").andCallFake (callback) ->
        callback "1234"
      couchdb.createDocument data, callback
      expect(couchdb.request).toHaveBeenCalledWith options, callback

  describe "getUuid", ->
    it "should call proper request", ->
      options =
        method: 'GET'
        path: '/_uuids'
      spyOn couchdb, 'request'
      couchdb.getUuid()
      expect(couchdb.request).toHaveBeenCalledWith options, jasmine.any(Function)
    it "should parse value and call callback", ->
      foo = callback: ->
      
      couchdbRequest = couchdb.request
      couchdb.request = (options, callback) ->
        callback "{\"uuids\":[\"somerandomtokenwithnumbers12345\"]}"

      spyOn foo, "callback"
      couchdb.getUuid foo.callback
      expect(foo.callback).toHaveBeenCalledWith "somerandomtokenwithnumbers12345"

  describe "request", ->
    req = undefined
    res = undefined
    beforeEach ->
      req = Object.create(
        end: ->

        write: ->
      )
      res = new EventEmitter()
      s = spyOn(http, "request").andReturn req
      s.andCallFake (params, callback) ->
        callback res
        req
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
      it "doesnt require callbaxk to be specified", ->
        couchdb.request {}
        res.emit "end", "foo"
      it "should call store data into buffer", ->
        foo = callback: ->

        spyOn foo, 'callback'
        couchdb.request {}, foo.callback
        res.emit "data", "foo"
        res.emit "end", undefined
        expect(foo.callback).toHaveBeenCalledWith "foo"


