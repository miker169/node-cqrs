/*global module:true
 */

/*
 * The command bus is the single entry point to
 * send commands to the domain. Its responsibility
 * is ton retrieve events and search for the proper
 * event handler, which will be the thing that
 * executes the command.
 */
var CommandBus = function () {
    "use strict";
    this.handlers = {};
};
/*
 * The Command bus is only able to respond to a 
 * given list of actions. When we need to add a 
 * new one to the list we call register handler
 * therefore in the future the application can
 * search for the proper commandHandler and
 * delegate execution to it.
 */
CommandBus.prototype.registerHandler = function (commandName, handler) {
    "use strict";
    this.handlers[commandName] = handler;
};

CommandBus.prototype.execute = function (commandName, attributes) {
    "use strict";
    var handler = this.handlers[commandName];
    if (!handler) {
        throw new Error('Handler for \'' + commandName + '\' doesn\'t exist!');
    }
    handler(attributes);

};

module.exports = CommandBus;
