/*global console:true,require:true,module:true
*/
var EventBus = require('./eventBus');
var db = require('./couchdb').getInstance();

var Aggregate = function (id, callback) {
        "use strict";
        this.id = id;
        var self = this;
        db.getEventsByAggregate(id, function (events) {
            var i = 0,
                j = events.length;
            for (i, j; i < j; i += 1) {
                self.apply(events[i]);
            }
        });
        if (callback) {
            callback.call(self);
        }

    };
// EVENT SOURCING
/*
 * Apply given event to the aggregate in order to update its
 * status.
*/
Aggregate.prototype.apply = function (event) {
    "use strict";
    var name = event.name.charAt(0).toUpperCase() + event.name.slice(1),
        handler = this['on' + name];
        

    if (typeof handler !== 'function') {
        throw new Error('There is no handler for \'' + name + '\' event!');
    }
    handler.call(this, event);
};
/*
 * In case the aggregate needs to store any information about the state
 * being mutated, it emeits an event, which should contain neccessary event 
 * information.
 */
Aggregate.prototype.emit = function (name, attributes) {
    "use strict";
    db.storeEvent(this.id, name, attributes);
};

module.exports = Aggregate;
