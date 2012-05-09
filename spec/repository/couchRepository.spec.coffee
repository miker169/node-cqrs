http = require "http"
jasmine = require "jasmine-node"
CouchDb = require "../../lib/repository/couchRepository"
EventEmitter = require("events").EventEmitter
describe "CouchRepository", ->
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
      couchdb.getEventsByName 'foo', 1000, ->

      expect(couchdb.request).toHaveBeenCalledWith
        method: 'GET'
        path: '/cqrs/_design/cqrs/_view/name?startkey=["foo",1000]&endkey=["foo",9999999999999]'
      , jasmine.any(Function)
    describe "with event list", ->
      it "should call request for each event", ->
        couchdb.getEventsByName [ "foo", "bar"],0, ->
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
        couchdb.getEventsByName ['foo', 'bar'],0, foo.f
        expect(foo.f.callCount).toEqual 1

    it "should call parseEvents", ->
      f = ->

      spyOn couchdb, 'parseEvents'
      couchdb.getEventsByName 'foo',0, f
      expect(couchdb.parseEvents).toHaveBeenCalledWith "{\"rows\": [{\"_id\":1, \"_ref\":1, \"value\": {\"foo\": \"bar\"}}]}", f
