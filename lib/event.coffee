db = require './storage'

class Event
  constructor: (data) ->
    data = data or {}
    @name = data.name
    @aggregateId = data.aggregateId
    @attributes = data.attributes
    @snapshot = data.null
  setSnapshot: (snapshot) ->
    @snapshot = snapshot
    @save()
  getSnapshot:->
    @snapshot
  hasSnapshot:->
    !!@snapshot
  save:->
    db.storeEvent this
  getEventBefore: (aggregateId, eventId, callback) ->
    db.getEventBefore aggregateId, eventId, callback
  getLastEventIndex: (aggregateId, callback) ->
    db.getLastEventIndex aggregateId, (err, doc) ->
      callback doc
