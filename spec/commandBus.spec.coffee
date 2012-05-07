CommandBus = require "../lib/commandBus"

describe "CommandBus", ->
  commandBus = undefined
  beforeEach ->
    commandBus = new CommandBus()

  it "should initialize empty handlers list", ->
    expect(commandBus.handlers).toEqual {}
  describe "registerHandler", ->
    it "should register handler function", ->
      f = ->

      commandBus.registerHandler "event", f
      expect(commandBus.handlers["event"]).toEqual f
    it "should accept only function as a handler", ->
      expect(->
        commandBus.registerHandler 'event', 'handler'
      ).toThrow 'Handler has to be a function!'

      
  describe "execute", ->
    it "should thrown an error in the case where handler doesnt exist", ->
      expect(->
        commandBus.execute "command"
      ).toThrow "Handler for 'command' doesn't exist!"
    it "should throw handler if available", ->
      commandBus.handlers["foo"] = ->

      spyOn commandBus.handlers, "foo"
      commandBus.execute "foo", foo: "bar"
      expect(commandBus.handlers["foo"]).toHaveBeenCalledWith foo: "bar"

