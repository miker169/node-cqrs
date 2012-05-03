#Command bus is responsible for hooking the right command handler object
#based on the object we have submitted
class CommandBus
  constructor: () ->
    @handlers = []
  registerHandler: (commandName, handler) ->
    @handlers[commandName] = handler
  execute: (commandName, attributes) ->
    handler = @handlers[commandName]
    throw new Error("Handler for " + commandName + " doesnt exist") unless handler
    handler.execute attributes
module.exports = CommandBus 
  
