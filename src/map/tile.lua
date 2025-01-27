local Class = require('src.utils.class')

---@class Tile
---@field x number Grid X coordinate of the tile
---@field y number Grid Y coordinate of the tile
---@field tileId number ID of the tile in the tileset
---@field globalX number Global X coordinate of the tile's top face center
---@field globalY number Global Y coordinate of the tile's top face center
local Tile = Class {
  ---Initialize a new Tile instance
  ---@param self Tile
  ---@param x? number Grid X coordinate (defaults to 0)
  ---@param y? number Grid Y coordinate (defaults to 0)
  ---@param tileId? number ID of the tile in tileset (defaults to 1)
  init = function(self, x, y, tileId)
    self.x = x or 0
    self.y = y or 0
    self.tileId = tileId or 1 -- Default to first tile in tileset
    -- Store global coordinates for the center of the top face
    self.globalX = 0
    self.globalY = 0
  end
}

---Get tile grid coordinates
---@return number x The X grid coordinate
---@return number y The Y grid coordinate
function Tile:getPosition()
  return self.x, self.y
end

---Set tile grid coordinates
---@param x number The X grid coordinate
---@param y number The Y grid coordinate
function Tile:setPosition(x, y)
  self.x = x
  self.y = y
end

---Get global coordinates of the tile's top face center
---@return number x The global X coordinate
---@return number y The global Y coordinate
function Tile:getGlobalPosition()
  return self.globalX, self.globalY
end

---Set global coordinates of the tile's top face center
---@param x number The global X coordinate
---@param y number The global Y coordinate
function Tile:setGlobalPosition(x, y)
  self.globalX = x
  self.globalY = y
end

---Get the tile's ID in the tileset
---@return number tileId The ID of the tile
function Tile:getTileId()
  return self.tileId
end

---Set the tile's ID in the tileset
---@param id number The new tile ID
function Tile:setTileId(id)
  self.tileId = id
end

return Tile
