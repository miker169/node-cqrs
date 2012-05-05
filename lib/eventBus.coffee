db = require "./storage"

class EventBus
  loadData: (aggregateID, callback) ->
    db.loadData aggregateID, callback
  storeEvent: (name, aggregateId, attributes) ->
   db.storeEvent(
      name: name,
      aggregateId: aggregateId,
      attributes: attributes
    )
  storeSnapshot: (aggregateID, lastEventId, snapshot, callback) ->
    db.storeSnapshot aggregateID, lastEventId, snapshot, callback
eventBus = new EventBus()
module.exports = eventBus
