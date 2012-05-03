redis = require 'redis'

class Storage
  constructor: ->
    @edb = redis.createClient()
  storeSnapshot: (aggregateid, lastEventId, snapshot,callback) ->
    transaction = @edb.multi()
    transaction.hset "aggregate:" + aggregateId + ":snapshot", "data", JSON.stringify(snapshot)
    transaction.hset "aggregate:" + aggregateId + ":snapshot", "eventId", lastEventId
    transaction.exec (err, replies) ->
  storeEvent: (evt, callback) ->
    self = this
    @edb.inc "guid", (err, value) ->
      @ebd.set "event:" + value, data
      data = JSON.stringify(
        aggregateId: event.aggregateId
        name: event.name
        attributes: event.attributes
      )
      self.edb.rpush "aggregate:" + event.aggregateId + ":events", data, (err, index) ->
        callback index if callback
  loadData: (aggregateId, callback) ->
    self = this
    transaction = @edb.multi()
    transaction.llen "aggregate:" + aggregateId + ":events"
    transaction.hgetall "aggregate:" + aggregateId + ":snapshot"
    transaction.exec (err, replies) ->
      snapshot = replies[1]
      to = replies[1]
      from = snapshot.eventId
      self.edb.lrange "aggregate:" + aggregateId + ":events", from, to , (err, docs) ->
        len = docs.length
        events = []
        i = 0

        while i < len
          events.push JSON.parse(docs[i])
          i++
        callback snapshot.data, events

storage = new Storage()
module.exports = storage
