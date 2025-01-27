local iso = require('src.utils.iso')
local Class = require('src.utils.class')
local Tile = require('src.map.tile')

local TileMap = Class {
  init = function(self, width, height)
    self.width = width
    self.height = height
    self.tiles = {}

    -- Calculate map center in isometric coordinates
    local mapCenterX = width / 2
    local mapCenterY = height / 2
    local mapCenterScreenX, mapCenterScreenY = iso.isoToScreen(mapCenterX, mapCenterY)

    -- Initialize empty map with Tile objects
    for y = 1, height do
      self.tiles[y] = {}
      for x = 1, width do
        -- Create tile with 0-based coordinates and default tileId of 1
        local tile = Tile(x - 1, y - 1, 1)

        -- Calculate global coordinates for the center of the top face
        local tileScreenX, tileScreenY = iso.isoToScreen(x - 1, y - 1)
        local globalX = tileScreenX - mapCenterScreenX - iso.TILE_WIDTH / 2
        local globalY = tileScreenY - mapCenterScreenY

        -- Set the global coordinates
        tile:setGlobalPosition(globalX, globalY)

        self.tiles[y][x] = tile
      end
    end
  end
}

-- Get tile at specific coordinates
function TileMap:getTile(x, y)
  if x >= 0 and x < self.width and y >= 0 and y < self.height then
    return self.tiles[y + 1][x + 1]
  end
  return nil
end

-- Check if point is inside diamond (top face of iso cube)
local function pointInDiamond(pointX, pointY, diamondCenterX, diamondCenterY)
  -- Convert point to diamond-local coordinates
  local localX = pointX - diamondCenterX
  local localY = pointY - diamondCenterY

  -- For isometric tiles, the diamond shape is formed by TILE_WIDTH/2 and TILE_HEIGHT/2
  -- This creates the exact diamond shape of the top face
  return math.abs(localX / (iso.TILE_WIDTH / 4)) + math.abs(localY / (iso.TILE_HEIGHT / 2)) <= 1
end

-- Convert mouse coordinates to tile coordinates
function TileMap:mouseToTile(mouseX, mouseY)
  -- Adjust mouse coordinates to account for isometric offset
  mouseX = mouseX - iso.TILE_WIDTH / 2
  mouseY = mouseY - iso.TILE_HEIGHT / 2

  -- Calculate map center in isometric coordinates
  local mapCenterX = self.width / 2
  local mapCenterY = self.height / 2
  local mapCenterScreenX, mapCenterScreenY = iso.isoToScreen(mapCenterX, mapCenterY)

  -- Check each tile's top face in isometric order (back to front)
  for y = self.height, 1, -1 do
    for x = 1, self.width do
      local tile = self.tiles[y][x]
      -- Get screen coordinates exactly as in draw()
      local tileScreenX, tileScreenY = iso.isoToScreen(tile:getPosition())
      tileScreenX = tileScreenX - mapCenterScreenX - iso.TILE_WIDTH / 2
      tileScreenY = tileScreenY - mapCenterScreenY

      -- Check if mouse is inside this tile's top face diamond
      if pointInDiamond(mouseX, mouseY, tileScreenX, tileScreenY) then
        return tile.x, tile.y
      end
    end
  end

  return -1, -1 -- No tile found
end

-- Set tile at specific coordinates
function TileMap:setTile(x, y, tileId)
  if x >= 0 and x < self.width and y >= 0 and y < self.height then
    self.tiles[y + 1][x + 1]:setTileId(tileId)
  end
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
      local tile = self.tiles[y][x]
      local tileScreenX, tileScreenY = iso.isoToScreen(tile:getPosition())

      -- Offset each tile by map center
      local screenX = tileScreenX - mapCenterScreenX - iso.TILE_WIDTH / 2
      local screenY = tileScreenY - mapCenterScreenY

      -- Draw the cube tile
      love.graphics.draw(
        self.tileset.image,
        self.tileset.quads[tile:getTileId()],
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
