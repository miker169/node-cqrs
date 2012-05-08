util = require "util"
couchdb = require("../lib/repository/couchdb").getInstance()
repository = require("../lib/repository").getInstance()
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
    spyOn(repository, "getEventsByName").andCallFake (names, callback) ->
      callback []
    view = new MyView()

  describe "load", ->
    it "should load data from the repository", ->
      view.load()
      expect(repository.getEventsByName).toHaveBeenCalledWith "foo", jasmine.any Function
    it "should call apply, for all events", ->
      event = foo: 'bar'
      spyOn view, "apply"
      repository.getEventsByName.andCallFake (names, callback) ->
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

  


