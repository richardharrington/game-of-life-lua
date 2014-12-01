local gol = require('gol')

describe('game of life', function()
  describe('coordinates', function()

    it('serializes coord pair', function()
      serialized = gol.serializeCoordPair(87, -34)
      assert.are.equal(serialized, "87,-34")
    end)

    it('deserializes coord pair', function()
      local coordPair = gol.deserializeCoordPair("-1,23")

      assert.are.same(coordPair, {-1, 23})
    end)

    it('determines live neighbors from coord pair set', function()
      local coordPairs = {
        ["1,1"] = true, 
        ["2,3"] = true,
        ["3,3"] = true,
        ["4,4"] = true,
        ["1,5"] = true
      }
      local coordPair = "3,3"

      local neighbors = gol.liveNeighbors(coordPair, coordPairs)

      assert.is_true(neighbors["2,3"])
      assert.is_true(neighbors["4,4"])

      assert.is_nil(neighbors["1,1"])
      assert.is_nil(neighbors["3,3"])
      assert.is_nil(neighbors["1,5"])

    end)

    it('gets set of dead cells adjacent to live cells', function()
      local liveCells = { ["1,1"] = true, ["2,2"] = true }

      deadCells = gol.deadCoordPairsNearLiveOnes(liveCells)

      assert.are.same(deadCells, {
        ["0,0"] = true,
        ["1,0"] = true,
        ["2,0"] = true,
        ["0,1"] = true,
        ["2,1"] = true,
        ["3,1"] = true,
        ["0,2"] = true,
        ["1,2"] = true,
        ["3,2"] = true,
        ["1,3"] = true,
        ["2,3"] = true,
        ["3,3"] = true
      })
    end)

  end)

  describe('living and dying', function()

    local liveCoordPairs

    before_each(function()
      liveCoordPairs = {
        ["1,1"] = true, 
        ["2,1"] = true, 
        ["1,2"] = true, 
        ["2,2"] = true, 
        ["2,3"] = true, 
        ["3,3"] = true, 
        ["4,3"] = true, 
        ["5,3"] = true, 
        ["2,4"] = true
      }
    end)

    it('cell stays alive with two neighbors', function()
      local liveCoordPair = "2,4"

      local willBeAlive = gol.willBeAlive(liveCoordPair, liveCoordPairs)

      assert.is_true(willBeAlive)
    end)

    it('cell stays alive with three neighbors', function()
      local liveCoordPair = "1,1"

      local willBeAlive = gol.willBeAlive(liveCoordPair, liveCoordPairs)

      assert.is_true(willBeAlive)
    end)

    it('cell dies with less than two neighbors', function()
      local liveCoordPair = "5,3"

      local willBeAlive = gol.willBeAlive(liveCoordPair, liveCoordPairs)

      assert.is_false(willBeAlive)
    end)

    it('cell dies with more than three neighbors', function()
      local liveCoordPair = "2,2"

      local willBeAlive = gol.willBeAlive(liveCoordPair, liveCoordPairs)

      assert.is_false(willBeAlive)
    end)

    it('cell comes alive with three neighbors', function()
      local deadCoordPair = "4,2"

      local willBeAlive = gol.willBeAlive(deadCoordPair, liveCoordPairs)

      assert.is_true(willBeAlive)
    end)

    it('cell stays dead with less than three neighbors', function()
      local deadCoordPair = "1,4"

      local willBeAlive = gol.willBeAlive(deadCoordPair, liveCoordPairs)

      assert.is_false(willBeAlive)
    end)

    it('cell stays dead with greater than three neighbors', function()
      local deadCoordPair = "1,3"

      local willBeAlive = gol.willBeAlive(deadCoordPair, liveCoordPairs)

      assert.is_false(willBeAlive)
    end)

    it('iterates properly from one set of live cells to the next', function()
      local expectedNextLiveCoordPairs = {
        ["1,1"] = true,
        ["2,1"] = true,
        ["4,2"] = true,
        ["4,3"] = true,
        ["2,4"] = true,
        ["4,4"] = true
      }

      nextLiveCoordPairs = gol.nextLiveCoordPairs(liveCoordPairs)

      assert.are.same(nextLiveCoordPairs, expectedNextLiveCoordPairs)
    end)

  end)

end)


-- describe('Busted unit testing framework', function()
--   describe('should be awesome', function()
--     it('should be easy to use', function()
--       assert.truthy("Yup.")
--     end)

--     it('should have lots of features', function()
--       assert.are.same({ table = 'great' }, { table = 'great' })
--       assert.are_not.equal({ table = 'great' }, { table = 'great' })
--       assert.truthy('this is a string')

--       assert.True(1 == 1)
--       assert.is_true(1 == 1)

--       assert.falsy(nil)
--       assert.falsy(false)
--       assert.is_nil(nil)

--       assert.has_error(function() error("Wat") end, "Wat")
--     end)

--     it('should have mocks and spies for functional tests', function()
--       spy.on(gol, "greet")
--       gol.greet("Hi!")

--       assert.spy(gol.greet).was.called()
--       assert.spy(gol.greet).was.called_with("Hi!")
--     end)
--   end)
-- end)