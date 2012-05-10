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

    describe("extendable", function () {
        var Base,
            bar;
        beforeEach(function () {
            Base = function () {};
            Base.prototype.foo = function () {};
        });
        it("should define extend method", function () {
            utils.extendable(Base);
            expect(typeof Base.extend).toEqual("function");
        });
        it("should accept prototype param", function () {
            utils.extendable(Base);
            var Foo = Base.extend(function (param) {
                this.param = param;
            });
            bar = new Foo('blah');
            expect(bar.param).toEqual('blah');

        });
        it("should create a constructor which calls the base constructor", function () {
            Base = function () { this.baseVar = true; };
            utils.extendable(Base);
            var Foo = Base.extend(),
                bar = new Foo('blah');
            expect(bar.baseVar).toEqual(true);
        });
        it("should extend all properties from the Base protype", function () {
            utils.extendable(Base);
            var Foo = Base.extend();
            expect(Foo.prototype.foo).toEqual(Base.prototype.foo);
        });
    });
});
