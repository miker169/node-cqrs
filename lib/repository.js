/*global module: true, require: true
 */
var utils = require('./utils');

var Repository = function (strategy) {
    "use strict";
    this.strategy = strategy;
};
utils.singleton(Repository);
utils.delegators(Repository, 'strategy', 'storeEvent');

module.exports = Repository;
