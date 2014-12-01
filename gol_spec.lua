local gol = require('gol')

function buildSet(items)
  local set = {}
  for _, item in ipairs(items) do
    set[item] = true
  end
  return set
end

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
      local coordPairs = buildSet {"1,1", "2,3", "3,3", "4,4", "1,5"}
      local coordPair = "3,3"

      local neighbors = gol.liveNeighbors(coordPair, coordPairs)

      assert.are.same(neighbors, { ["2,3"] = true, ["4,4"] = true })
    end)

    it('gets set of dead cells adjacent to live cells', function()
      local liveCells = { ["1,1"] = true, ["2,2"] = true }
      local expectedDeadCells = buildSet {"0,0", "1,0", "2,0", "0,1", "2,1", "3,1",
                                          "0,2", "1,2", "3,2", "1,3", "2,3", "3,3"}

      deadCells = gol.deadCoordPairsNearLiveOnes(liveCells)

      assert.are.same(deadCells, expectedDeadCells)
    end)
  end)

  describe('living and dying', function()

    local liveCoordPairs

    before_each(function()
      liveCoordPairs = buildSet {"1,1", "2,1", "1,2", "2,2", "2,3",
                                 "3,3", "4,3", "5,3", "2,4"}
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
      local expectedNextLiveCoordPairs = buildSet { "1,1", "2,1", "4,2",
                                                    "4,3", "2,4", "4,4" }

      nextLiveCoordPairs = gol.nextLiveCoordPairs(liveCoordPairs)

      assert.are.same(nextLiveCoordPairs, expectedNextLiveCoordPairs)
    end)
  end)
end)
