/*global module:true, require:true
 */
var http = require("http");
var CouchDb = function (databaseName) {
    "use strict";
    this.database = databaseName;
    this.options = {
        host: 'localhost',
        port: 5984
    };
};
CouchDb.prototype.createDocument = function (data, callback) {
    "use strict";
    var self = this;
    this.getUuid(function (uuid) {
        self.request({
            method: 'PUT',
            path: '/' + self.database + '/' + uuid,
            data: data
        }, callback);
    });
};
CouchDb.prototype.request = function (options, callback) {
    "use strict";
    options = options || {};
    var params = this.options,
        buffer = '',
        req;
    params.method = options.method || 'GET';
    params.path = options.path || '/';
    
    req = http.request(params, function (res) {
        res.on('data', function (chunk) {
            buffer += chunk;
        });

        res.on('end', function (chunk) {
            if (chunk) {
                buffer += chunk;
            }
            callback(buffer);
        });
    });
    if (options.data) {
        req.write(options.data);
    }
    req.end();
};

CouchDb.prototype.getUuid = function (callback) {
    "use strict";
    this.request({
        method: 'GET',
        path: '/_uuids'
    }, function (data) {
        callback(JSON.parse(data).uuids[0]);
    });
};

module.exports = CouchDb;
