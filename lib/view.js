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
    this.data = '';
    this.lastEvent = 0;
};

View.prototype.apply = function (event) {
    "use strict";
    var name = event.name.charAt(0).toUpperCase() + event.name.slice(1),
        handler = this['on' + name];
    if (typeof handler !== 'function') {
        throw new Error('There is no handler for \'' + name + '\' event!');
    }
    
    handler.call(this, event);

        


};

View.prototype.load = function (callback) {
    "use strict";
    var self = this;
    storage.loadView(this.uid, function (data) {
      //Update data and lastEvent, load data from rep
      //just for newer events
        self.data = data.data;
        self.lastEvent = data.lastEvent;
        repo.getEventsByName(self.eventNames, data.lastEvent, function (events) {
          //Apply all loaded events to update the aggregate to the most
          //recent know state
            var i = 0;
            for (i; i < events.length; i  += 1) {
                self.apply(events[i]);
            }
            if (callback) {
                callback.call(self);
            }


        });
    });
    //repo.getEventsByName(this.events, function (events) {
     //   var i = 0;
      //Apply all loaded events to update the
      //aggregate to the most recent know state
      //  for (i; i < events.length; i += 1) {
       //     self.apply(events[i]);
        //}
       // 
        //if (callback) {
         //   callback.call(self);
        //}
  //  });
};


module.exports = View;
