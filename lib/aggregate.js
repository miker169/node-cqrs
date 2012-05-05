/*global console:true,require:true,module:true
*/
var EventBus = require('./eventBus');

var Aggregate = function (id, callback) {
        "use strict";
        var self = this;
        this.id = id;
        //Load data from the event storahge
        EventBus.loadData(id, function (snapshot, events, lastEventId) {
            var i = 0, j = events.length;
           //If any snapshot fund, we use it to 
            //initalize the object state
            if (snapshot) {
                self.init(snapshot);
            }
            // Apply all loaded events to update the
            // aggregate to the most recent 
            // know state
            for (i, j; i < j; i += 1) {
                self.apply(events[i]);
            }
        });
    };
Aggregate.prototype.init = function () {
    "use strict";
    console.log("init");
};
Aggregate.prototype.apply = function () {
    "use strict";
};
module.exports = Aggregate;
