/*global module: true, require:true
 */
var util = require('util'),
    utils = require('../utils'),
    CouchDb = require('../util/couchdb');
var CouchStorage = function () {
    "use strict";
    CouchDb.call(this, 'cqrs');
};
util.inherits(CouchStorage, CouchDb);
utils.singleton(CouchStorage);

CouchStorage.prototype.storeView = function (view) {
    "use strict";
    this.createDocument(JSON.stringify({
        viewId: view.uid,
        type: 'view',
        lastEvent: view.lastEvent,
        data: view.data
    }));
};

CouchStorage.prototype.loadView = function (id, callback) {
    "use strict";
    this.request({
        method: 'GET',
        path: '/' + this.database + '/' + id
    }, function (data) {
        callback(JSON.parse(data));
    });
};
module.exports = CouchStorage;
