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
  -- Calculate center offset
  local centerX = love.graphics.getWidth() / 2
  local centerY = love.graphics.getHeight() / 3

  -- Draw tiles in isometric order (back to front)
  for y = 1, self.height do
    for x = 1, self.width do
      local screenX, screenY = iso.isoToScreen(x - 1, y - 1)

      -- Center the map and adjust for tile dimensions
      screenX = screenX + centerX - iso.TILE_WIDTH / 4 -- Adjusted for new isometric calculations
      screenY = screenY + centerY - iso.TILE_DEPTH     -- Account for cube height

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
