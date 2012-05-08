CouchStorage = require "../../lib/storage/couch"
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

