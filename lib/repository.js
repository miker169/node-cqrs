/*global module: true, require: true
 */
var utils = require('./utils');

var Repository = function (strategy) {
    "use strict";
    this.strategy = strategy;
    this.handlers = {};
};
utils.singleton(Repository);
utils.delegators(Repository, 'strategy', 'storeEvent');
utils.delegators(Repository, 'strategy', 'getEventsByAggregate');

/*Register new handler for a given event. Callback is
 * triggered after aggregate emits the event of the
 * given type and the repository storage system
 * is finished saving it to permanent storage
 */
Repository.prototype.on = function (name, callback) {
    "use strict";
    this.handlers[name] = this.handlers[name] || [];
    if (this.handlers[name].indexOf(callback) === -1) {
        this.handlers[name].push(callback);
    }
   
};

module.exports = Repository;
