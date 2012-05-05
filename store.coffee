eventBus = require "./lib/eventBus"
db = require "./lib/storage"
len = 1000
i = 0
while i < len
  console.log i
  eventBus.save "Create" + i, 1,
    amount: i
  i++
console.log "Done Saving"
