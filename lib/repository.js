/*global module: true, require: true
 */
var utils = require('./utils');

var Repository = function (strategy) {
    "use strict";
    this.strategy = strategy;
};
utils.singleton(Repository);

module.exports = Repository;
