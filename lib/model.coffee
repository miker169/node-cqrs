storage = require "./storage"
eventBus = require "./eventBus"
class Model
  apply:(event) ->

  emit:(event) ->
    eventBus.store event

module.exports = Model
