/*global module:true, require:true, console:true
 */
var http = require("http"),
    utils = require("../utils"),
    CouchDb = require('../util/couchdb'),
    instance;

var CouchRepository = function () {
    "use strict";
    this.database = 'cqrs';
    this.options = {
        host: 'localhost',
        port: 5984
    };
    CouchDb.call(this, this.database, this.options);
};
utils.inherits(CouchRepository, CouchDb);
utils.singleton(CouchRepository);

/*Event Sourcing Methods*/
/*Gets a list of all events for one specific aggregate*/
CouchRepository.prototype.getEventsByAggregate = function (aggregateId, callback) {
    "use strict";
    var self = this,
        startKey = '["' + aggregateId + '",0]',
        endKey = '["' + aggregateId + '",9999999999999]',
        params = '?startKey=' + startKey + '&endkey=' + endKey;
    this.request({
        method: 'GET',
        path: '/' + this.database + '/_design/cqrs/_view/aggregate' + params
    }, function (data) {
        self.parseEvents(data, callback);
    });
};
/* Gets a list of all events of a specific type*/
CouchRepository.prototype.getEventsByName = function (type, from, callback) {
    "use strict";
    var self =  this,
        toFinish,
        events,
        i,
    //Load function itself can be called once or multiple times
        load = function (type, callback) {
            var startKey = '["' + type + '",' + from + ']',
                endKey = '["' + type + '",9999999999999]',
                params = '?startkey=' + startKey + '&endkey=' + endKey;
                
            self.start = new Date().getTime();

            self.request({
                method : "GET",
                path  : '/' + self.database + '/_design/cqrs/_view/name' + params
            }, function (data) {
                self.parseEvents(data, callback);
            });
        };

    if (typeof type === 'string') {
        load(type, callback);
    } else {
        toFinish = type.length;
        events = [];

        for (i in type) {
            load(type[i], function (data) {
                events = events.concat(data);
                toFinish -= 1;

                if (toFinish === 0) {
                    callback(events);
                }
          });
          
        }
    }
};
    
CouchRepository.prototype.parseEvents = function (data, callback) {
    "use strict";
    var events = [];
    data = JSON.parse(data);

    if (data.error) {
        console.log("ERROR: " + data.error);
        callback(events);
        return;
    }

    for ( var i = 0; i < data.rows.length; i++) {
      delete data.rows[i].value['_id'];
      delete data.rows[i].value['_rev'];

      events.push(data.rows[i].value);
    }
    callback(events);
};
/* Store a new Event
 */
CouchRepository.prototype.storeEvent =
    function (aggregateId, name, attrs) {
        "use strict";
        this.createDocument(JSON.stringify({
            aggregateId : aggregateId,
            name : name,
            type : "event",
            time : new Date().getTime(),
            attrs : attrs
        }));
    };

module.exports = CouchRepository;
