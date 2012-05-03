CommandBus = require("./lib/CommandBus")
CommandHandler = require("./lib/CommandHandler").CommandHandler
commandBus =  new CommandBus()
commandBus.registerHandler 'test' , new CommandHandler()
commandBus.execute 'test'
