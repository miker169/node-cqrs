util = require "util"
couchdb = require("../lib/repository/couchRepository").getInstance()
repository = require("../lib/repository").getInstance()
storage = require("../lib/storage/couchStorage").getInstance()
jasmine = require("jasmine-node")
View = require("../lib/view")

describe "View", ->
  view = undefined
  MyView = undefined
  beforeEach ->
    repository.strategy = couchdb
    MyView = (callback) ->
      View.call this, "foo", callback

    util.inherits MyView, View
    spyOn(repository, "getEventsByName").andCallFake (names,from, callback) ->
      callback []
    view = new MyView()

  describe "load", ->
    it "should load data from storage", ->
      spyOn storage, 'loadView'
      view.uid = '45hj12'
      view.load()
      expect(storage.loadView).toHaveBeenCalledWith "45hj12", jasmine.any Function
    describe "callback", ->
      beforeEach ->
        spyOn(storage, 'loadView').andCallFake (uid, callback) ->
          callback
            uid: 'q12345'
            lastEvent: 12345
            data:
              foo: 'bar'
          
      it "should loads the events increment data from the repository", ->
        view.load()
        expect(repository.getEventsByName).toHaveBeenCalledWith 'foo', 12345, jasmine.any Function
      it "should call apply, for all events", ->
        event = foo: 'bar'
        spyOn view, "apply"
        repository.getEventsByName.andCallFake (names,from, callback) ->
          callback [event]
        view.load()
        expect(view.apply).toHaveBeenCalledWith event
      it "should call callback if specified", ->
        @handler = ->
        spyOn this, "handler"
        view.load @handler
        expect(@handler).toHaveBeenCalled()
    
    describe "apply", ->
      it "should call raise error if handler is missing", ->
        event = name: "myEvent"
        expect(->
          view.apply event
        ).toThrow "There is no handler for 'MyEvent' event!"
      it "should call appropriata handler", ->
        event=name: "myEvent"
        MyView::onMyEvent =->

        spyOn view, "onMyEvent"
        view.apply event
        expect(view.onMyEvent).toHaveBeenCalledWith event

  


