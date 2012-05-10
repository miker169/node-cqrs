/*global module: true, require:true
 */
var util = require('util');

module.exports.singleton  = function (base) {
    "use strict";
    base.getInstance = function () {
        var Base = base;
        if (!this.instance) {
            this.instance = new Base();
        }
        return this.instance;

    };
};

module.exports.delegators = function (base, target, method) {
    "use strict";
    base.prototype[method] = function () {
        this[target][method].apply(this[target], arguments);

    };
};

module.exports.extendable = function (base) {
    "use strict";
    base.extend = function (constructor) {
      //create a new function which inherits from base
        var Extended = function () {
                base.apply(this, arguments);
                if (constructor) {
                    constructor.apply(this, arguments);
                }
            };
        //copy the base prototype
        for (var i in base.prototype) {
            Extended.prototype[i] = base.prototype[i];
        }
        return Extended;
    };
};

module.exports.inherits = util.inherits;


