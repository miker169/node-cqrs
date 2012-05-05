EventBus = require './eventBus'

class Aggregate
  constructor: (id) ->
    @_id = id
    self = this
    start = new Date().getTime()
    @_quantity = 0
    console.log @_id
    EventBus.loadData @_id, (snapshot, events, lastEventId) ->
      self.init snapshot
      len = events.length
      i = 0
      while i < len
        self.apply events[i]
        i++
      EventBus.storeSnapshot self._id, lastEventId,
        quantity: self._quantity
      console.log new Date().getTime() - start + " ms"
  @find: (id) ->
    new Aggregate(id)

  @apply: (event) ->
    @_total += event.attribute.alount

  @emit: (event) ->
     EventBus.store event

console.log Aggregate
module.exports = Aggregate
