/*global module: true, require:true
 */
var utils = require('../utils'),
    CouchDb = require('../util/couchdb');

var CouchStorage = function () {
    "use strict";
    CouchDb.call(this, 'cqrs');
};
utils.inherits(CouchStorage, CouchDb);
utils.singleton(CouchStorage);

CouchStorage.prototype.storeView = function (view) {
    "use strict";
    this.createDocument(JSON.stringify({
        viewId: view.uid,
        type: 'view',
        lastEvent: view.lastEvent,
        time: new Date().getTime(),
        data: view.data
    }));
};

CouchStorage.prototype.loadView = function (id, callback) {
    "use strict";
    this.request({
        method: 'GET',
        path: '/' + this.database + '/_design/cqrs/_view/viewSnapshot?startkey=["' + id + '",9999999999999]&endkey=["' + id + '",0]&limit=1&descending=true'
    }, function (data) {
        data = JSON.parse(data);
        var item = data.rows[0].value;
        delete item.id;
        delete item.rev;
        delete item.type;
        callback(item);
    });
};
module.exports = CouchStorage;
