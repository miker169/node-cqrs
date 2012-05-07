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


