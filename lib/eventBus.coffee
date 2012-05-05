db = require "./storage"

class EventBus
  loadData: (aggregateID, callback) =>
    console.log "aggregateID to load", aggregateID
    console.log "Whats the calback?", callback 
    db.loadData aggregateID, callback
  save: (name, aggregateId, attributes) =>
   db.storeEvent(
      name: name,
      aggregateId: aggregateId,
      attributes: attributes
    )
  storeSnapshot: (aggregateID, lastEventId, snapshot, callback) =>
    db.storeSnapshot aggregateID, lastEventId, snapshot, callback
eventBus = new EventBus()
module.exports = eventBus
