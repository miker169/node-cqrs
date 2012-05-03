#A command handler should just handle very simple CRUD operations, should be
#very little validation going on here.
class CommandHandler
  execute: ->
    throw new Error "Not Yet Implementted"
  #CommandHandler::execute = ->
  #throw new Error("Not yet implemented")
exports.CommandHandler = CommandHandler
