/*global module: true
 */
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
   /* base.prototype[method] = function () {
        this[target][method].apply(this[target], arguments);
    }*/
    base.prototype[method] = function () {
        this[target][method].apply(this[target], arguments);

    };
};


