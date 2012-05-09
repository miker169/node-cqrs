/*global require:true, module:true
 */
var Aggregate = require('./lib/aggregate'),
    CommandBus = require('./lib/commandBus'),
    View = require('./lib/view'),
    Repository = require('./lib/repository'),
    CouchRepository = require('./lib/repository/couchRepository'),
    CouchStorage = require('./lib/storage/couchStorage');


module.exports.Aggregate = Aggregate;
module.exports.CommandBus = CommandBus;
module.exports.View = View;
module.exports.Repository = Repository;
module.exports.CouchRepository = CouchRepository;
module.exports.CouchStorgae = CouchStorage;

