local assets = require('src.utils.assets')
local iso = require('src.utils.iso')

local TileMap = {}
TileMap.__index = TileMap

function TileMap.new(width, height)
  local self = setmetatable({}, TileMap)
  self.width = width
  self.height = height
  self.tiles = {}

  -- Initialize empty map
  for y = 1, height do
    self.tiles[y] = {}
    for x = 1, width do
      self.tiles[y][x] = 1 -- Default to first tile
    end
  end

  return self
end

function TileMap:draw()
  -- Calculate map center in isometric coordinates
  local mapCenterX = self.width / 2
  local mapCenterY = self.height / 2

  -- Get screen coordinates for map center
  local mapCenterScreenX, mapCenterScreenY = iso.isoToScreen(mapCenterX, mapCenterY)

  -- Draw tiles in isometric order (back to front)
  for y = 1, self.height do
    for x = 1, self.width do
      local tileScreenX, tileScreenY = iso.isoToScreen(x - 1, y - 1)

      -- Offset each tile by map center
      local screenX = tileScreenX - mapCenterScreenX - iso.TILE_WIDTH / 2
      local screenY = tileScreenY - mapCenterScreenY

      -- Draw the cube tile
      love.graphics.draw(
        self.tileset.image,
        self.tileset.quads[self.tiles[y][x]],
        screenX,
        screenY
      )
    end
  end
end

function TileMap:setTileset(tileset)
  self.tileset = tileset
end

return TileMap
