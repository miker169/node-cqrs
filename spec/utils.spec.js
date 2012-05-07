/*global describe: true, require: true, expect:true, it:true, beforeEach:true, spyOn:true
 */
var utils = require('../lib/utils');

describe('Utils', function () {

    "use strict";
    describe('delegators', function () {
        var Base, base;
        beforeEach(function () {
            Base = function () {
                this.receiver = {
                    foo: function () {

                    }
                };
            };

            base = new Base();
        });

        it("should define delegate method", function () {
            utils.delegators(Base, 'receiver', 'foo');
            spyOn(base.receiver, 'foo');

            base.foo();

            expect(base.receiver.foo).toHaveBeenCalled();
        });
    });
});
