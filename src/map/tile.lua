local Class = require('src.utils.class')

local Tile = Class {
  init = function(self, x, y, tileId)
    self.x = x or 0
    self.y = y or 0
    self.tileId = tileId or 1 -- Default to first tile in tileset
  end
}

-- Get tile coordinates
function Tile:getPosition()
  return self.x, self.y
end

-- Set tile coordinates
function Tile:setPosition(x, y)
  self.x = x
  self.y = y
end

-- Get tile ID (which tile from tileset)
function Tile:getTileId()
  return self.tileId
end

-- Set tile ID
function Tile:setTileId(id)
  self.tileId = id
end

return Tile
