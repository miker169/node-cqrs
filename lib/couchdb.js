/*global module:true, require:true
 */
var http = require("http");
var CouchDb = function () {
    "use strict";
    this.options = {
        host: 'localhost',
        port: 5984
    };
};
CouchDb.prototype.request = function (options) {
    "use strict";
    options = options || {};
    var params = this.options,
        req;
    params.method = options.method || 'GET';
    params.path = options.path || '/';
    
    req = http.request(params, function () {
    });
    req.end();
};
module.exports = CouchDb;
