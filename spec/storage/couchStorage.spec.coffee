CouchStorage = require "../../lib/storage/couchStorage"
jasmine = require 'jasmine-node'

describe "CouchStorage", ->
  couchStorage = undefined
  beforeEach ->
    couchStorage = new CouchStorage
  describe "instance", ->
    it "should get instance of CouchStorage", ->
      couchStorage = CouchStorage.getInstance()
      expect(typeof couchStorage.request).toEqual 'function'
    it "should return just one instance", ->
      expect(CouchStorage.getInstance()).toEqual CouchStorage.getInstance()
  describe "storeView", ->
    it "should call createDocument", ->
      view = {uid: 1, lastEvent: 12, data: 'foo'}
      spyOn couchStorage, 'createDocument'

      couchStorage.storeView view

      expect(couchStorage.createDocument).toHaveBeenCalledWith '{"viewId":1,"type":"view","lastEvent":12,"data":"foo"}'
  describe "loadView", ->
    it "should call request", ->
      spyOn couchStorage, "request"
      couchStorage.loadView 'f456575jhg'
      expect(couchStorage.request).toHaveBeenCalledWith {method: 'GET', path: '/cqrs/f456575jhg'}, jasmine.any Function
    it "should parse the returned data", ->
      data =  '{"id":"123","rev":"123","uid":"123","type":"view","lastEvent":"123","data":{"foo":"bar"}}'
      foo = f: ->

      spyOn foo, 'f'
      spyOn(couchStorage, 'request').andCallFake (id, callback) ->
        callback data

      couchStorage.loadView '123', foo.f

      expect(foo.f).toHaveBeenCalledWith
        uid: '123'
        lastEvent: '123'
        data: foo: 'bar'

