db = require "./storage"
Event = require "./event"

class EventBus
  save: (eventName, aggregateId, attributes) ->
    event = new Event(
      name: eventName
      aggregateID: aggregateID
      attributes: attributes
    )
    event.save()
  getEventBefore:(aggregateID, beforeEventId, callback) ->
    Event.getEventBefore aggregateID, beforeEventId, callback
  storeSnapshot: (aggregateID, lastEventId, snapshot, callback) ->
    db.storeSnapshot aggregateID, lastEventId, snapshot, callback
  loadData:(aggregateID, callback) ->
    db.loadData aggregateID, callback

module.exports = EventBus
