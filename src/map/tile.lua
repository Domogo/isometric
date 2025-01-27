local Class = require('src.utils.class')

local Tile = Class {
  init = function(self, x, y, tileId)
    self.x = x or 0
    self.y = y or 0
    self.tileId = tileId or 1 -- Default to first tile in tileset
    -- Store global coordinates for the center of the top face
    self.globalX = 0
    self.globalY = 0
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

-- Get global coordinates of the top face center
function Tile:getGlobalPosition()
  return self.globalX, self.globalY
end

-- Set global coordinates of the top face center
function Tile:setGlobalPosition(x, y)
  self.globalX = x
  self.globalY = y
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
