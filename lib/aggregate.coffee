EventBus = require './eventBus'

###
  The Aggregate is the system entities and value obejcts which we use to
  maintain transactional consistency throughout the application. It should
  encapsulate a set of objects which it should keep consistent and also kep
  business driven set of invariants
###
class Aggregate
  constructor: (id, callback) ->
    @_id = id
    self = this
    #Load some data from the evnt storage
    EventBus.loadData @_id, (snapshot, events, lastEventId) ->
      self.init snapshot if snapshot
      i = 0
      while i < events.length
        self.apply events[i]
        i++
      callback.call self if callback
  @snapshot = ->
    {}
  @init: (data) ->

  @apply: (event) ->

  @emit: (event) ->
     EventBus.store event, @_id, attributes

console.log Aggregate
module.exports = Aggregate
