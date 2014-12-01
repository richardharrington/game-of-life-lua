local intPattern = "(-?%d+)"
local coordPattern = intPattern .. "," .. intPattern

local function count(t)
  local counter = 0
  for _ in pairs(t) do
    counter = counter + 1
  end
  return counter
end

local function mergeIntoSet(target, source)
  for key in pairs(source) do
    target[key] = true
  end
end

function setUnion(set1, set2)
  local union = {}
  mergeIntoSet(union, set1)
  mergeIntoSet(union, set2)
  return union
end

local function serializeCoordPair(x,y) 
  return tostring(x) .. "," .. tostring(y)
end

local function deserializeCoordPair(s)
  local x, y = s:match(coordPattern)
  return { tonumber(x), tonumber(y) }
end

local function areNeighbors(coordPair1, coordPair2)
  local x1, y1 = unpack(coordPair1)
  local x2, y2 = unpack(coordPair2)
  return (not (x1 == x2 and y1 == y2)) and 
         (math.abs(x1 - x2) < 2 and math.abs(y1 - y2) < 2)
end

local function liveNeighbors(coordPair, coordPairs)
  local numCoordPair = deserializeCoordPair(coordPair)
  local neighbors = {}
  for coordPair in pairs(coordPairs) do
    if areNeighbors(numCoordPair, deserializeCoordPair(coordPair)) then
      neighbors[coordPair] = true
    end
  end
  return neighbors
end

local function deadCoordPairsNearLiveOnes(coordPairs)
  local deadCoordPairs = {}
  for coordPair in pairs(coordPairs) do
    local x, y = unpack(deserializeCoordPair(coordPair))
    for i = x - 1, x + 1 do
      for j = y - 1, y + 1 do
        local cp = serializeCoordPair(i, j)
        if not coordPairs[cp] then
          deadCoordPairs[cp] = true
        end
      end
    end
  end
  return deadCoordPairs
end

function willBeAlive(coordPair, liveCoordPairs) 
  local c = count(liveNeighbors(coordPair, liveCoordPairs))
  if liveCoordPairs[coordPair] then
    return c > 1 and c < 4
  else
    return c == 3
  end
end

function nextLiveCoordPairs(liveCoordPairs) 
  local deadCoordPairs = deadCoordPairsNearLiveOnes(liveCoordPairs)
  local allCoordPairs = setUnion(liveCoordPairs, deadCoordPairs)

  local nextLiveCoordPairs = {}
  for coordPair in pairs(allCoordPairs) do
    if willBeAlive(coordPair, liveCoordPairs) then
      nextLiveCoordPairs[coordPair] = true
    end
  end

  return nextLiveCoordPairs
end

return {
  serializeCoordPair = serializeCoordPair,
  deserializeCoordPair = deserializeCoordPair,
  liveNeighbors = liveNeighbors,
  deadCoordPairsNearLiveOnes = deadCoordPairsNearLiveOnes,
  willBeAlive = willBeAlive,
  nextLiveCoordPairs = nextLiveCoordPairs,
}

