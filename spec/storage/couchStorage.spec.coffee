CouchStorage = require "../../lib/storage/couchStorage"
jasmine = require 'jasmine-node'

describe "CouchStorage", ->
  couchStorage = undefined
  beforeEach ->
    couchStorage = new CouchStorage()
  describe "instance", ->
    it "should get instance of CouchStorage", ->
      couchStorage = CouchStorage.getInstance()
      expect(typeof couchStorage.request).toEqual 'function'
    it "should return just one instance", ->
      expect(CouchStorage.getInstance()).toEqual CouchStorage.getInstance()
  describe "storeView", ->
    it "should call createDocument", ->
      view = 
        uid: 1
        lastEvent: 12
        data: 'foo'
      spyOn couchStorage, 'createDocument'
      spyOn(Date::,'getTime').andCallFake ->
        return 123456

      couchStorage.storeView view

      expect(couchStorage.createDocument).toHaveBeenCalledWith '{"viewId":1,"type":"view","lastEvent":12,"time":123456,"data":"foo"}'
  describe "loadView", ->
    it "should call request", ->
      spyOn couchStorage, "request"
      couchStorage.loadView 'f456575jhg'
      expect(couchStorage.request).toHaveBeenCalledWith {method: 'GET', path: '/cqrs/_design/cqrs/_view/viewSnapshot?startkey=["f456575jhg",9999999999999]&endkey=["f456575jhg",0]&limit=1&descending=true'}, jasmine.any Function
    #xit "should parse the returned data", ->
    #  data = '{"total_rows":40,"offset":2,"rows":[{"id":"e9f59b5f8c965ebce700eeec1baf7a60","key":["1j0ddsesdfsfdo0m7",1326500825084],"value":{"id":"e9f59b5f8c965ebce700eeec1baf7a60","rev":"1-0145acc24d7c96db4d8ef260ad4afec4","viewId":"1j0ddsesdfsfdo0m7","type":"view","lastEvent":1326500821237,"time":1326500825084,"data":{"total":1054078}}}]}'
    #  foo = f: ->
#
#      spyOn foo, "f"
#      spyOn(couchStorage, "request").andCallFake (id, callback) ->
#        callback data
#
#      couchStorage.loadView 'f8s7hh5dggs', foo.f
#      
#
#      expect(foo.f).toHaveBeenCalledWith
#        viewid: '1j0ddsesdfsfdo0m7'
#        lastEvent: 1326500821237
#        time: 1326500825084
#        data:
#          total: 1054078
