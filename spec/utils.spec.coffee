utils = require "../lib/utils"

describe "Utils", ->
  describe "singleton", ->
    Base = undefined
    base = undefined

    beforeEach ->
      Base = ->
      Base::foo = ->

      base = new Base()
    it "should create getInstance method on base", ->
      utils.singleton Base
      expect(typeof Base.getInstance).toBe "function"
    it "Base.getInstance should return the same base instance", ->
      utils.singleton Base
      instance = Base.getInstance()
      expect(Base.getInstance()).toBe instance
      expect(typeof Base.getInstance().foo).toEqual "function"
