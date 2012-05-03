EventBus = require "./lib/eventBus"
db = require "./lib/storage"
eventBus = new EventBus()
eventBus.loadData 1, (snapshot, events) ->
  console.log "snapshot:"
  console.log snapshot
  console.log "events:"
  console.log events
