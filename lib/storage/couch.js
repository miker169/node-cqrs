/*global module: true, require:true
 */
var util = require('util'),
    CouchDb = require('../util/couchdb');
var CouchStorage = function () {
    "use strict";
};
util.inherits(CouchStorage, CouchDb);

CouchStorage.storeView = function (view) {
    "use strict";
};

CouchStorage.loadView = function (id, callback) {
    "use strict";
};

module.exports = CouchStorage;
