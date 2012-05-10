/*global module : true, require: true
 */
var repo = require('./repository').getInstance(),
    storage = require('./storage/couchStorage').getInstance();
/*The View is the ultimate way, of how to look at 
 * your data, wider than the scope of an aggregate.
 * Views take various sets of events, found by type,
 * and compose and output a report of the data, to be 
 * used as a DTO for a client. Its major purpose is to
 * decompose and normalize data from the event stream,
 * so the view queries can run with blazingly fast
 * performance, with no need for additional expensive
 * queries to the database
 */
var View = function (eventNames) {
    "use strict";
    this.eventNames = eventNames;
    //Data ocontent of the view, used as DTO for the client.
    this.data = {};
    //Timestamp of last applied event
    this.lastEvent = 0;

    this.uid = '1j0ddsesdfsfdo0m7';
};

View.prototype.apply = function (event) {
    "use strict";
    var name = event.name.charAt(0).toUpperCase() + event.name.slice(1),
        handler = this['on' + name];
    if (typeof handler !== 'function') {
        throw new Error('There is no handler for \'' + name + '\' event!');
    }
    this.lastEvent = event.time;
    
    handler.call(this, event);


        


};

View.prototype.load = function (callback) {
    "use strict";
    var self = this,
        start = new Date().getTime();
    storage.loadView(this.uid, function (data) {
      //Update data and lastEvent, load data from rep
      //just for newer events
        if (data) {
            self.data = data.data;
            self.lastEvent = data.lastEvent;
        }
        repo.getEventsByName(self.eventNames, self.lastEvent + 1, function (events) {
          //Apply all loaded events to update the aggregate to the most
          //recent know state
            var i = 0;
            for (i; i < events.length; i  += 1) {
                self.apply(events[i]);
            }
            if (events.length > 0) {
                storage.storeView(self);
            }
            if (callback) {
                callback.call(self);
            }


        });
    });
};

module.exports = View;
