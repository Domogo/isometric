---@class iso
---@field TILE_WIDTH number Width of the isometric tile in pixels
---@field TILE_HEIGHT number Height of the top face in pixels (half of width for isometric)
---@field TILE_DEPTH number Full height of the cube including sides in pixels
local iso = {}

-- Tile dimensions (matching the actual tileset dimensions)
iso.TILE_WIDTH = 64  -- Width of the tile
iso.TILE_HEIGHT = 32 -- Height of the top face (half of width for isometric)
iso.TILE_DEPTH = 64  -- Full height of the cube including sides

---Convert screen coordinates to isometric grid coordinates
---@param screenX number X coordinate in screen space
---@param screenY number Y coordinate in screen space
---@param mapCenterScreenX number X coordinate of the map center in screen space
---@param mapCenterScreenY number Y coordinate of the map center in screen space
---@return number isoX The X coordinate in isometric grid space (floored)
---@return number isoY The Y coordinate in isometric grid space (floored)
function iso.screenToIso(screenX, screenY, mapCenterScreenX, mapCenterScreenY)
  -- First adjust for the center offset
  screenX = screenX + mapCenterScreenX
  screenY = screenY + mapCenterScreenY

  -- Then adjust for tile width offset (matching draw() method)
  screenX = screenX + iso.TILE_WIDTH / 2

  -- Convert to isometric coordinates using the inverse of isoToScreen transformation
  local isoX = (screenX / (iso.TILE_WIDTH / 2) + screenY / (iso.TILE_HEIGHT / 2)) / 2
  local isoY = (screenY / (iso.TILE_HEIGHT / 2) - screenX / (iso.TILE_WIDTH / 2)) / 2

  return math.floor(isoX), math.floor(isoY)
end

---Convert isometric grid coordinates to screen coordinates
---@param isoX number X coordinate in isometric grid space
---@param isoY number Y coordinate in isometric grid space
---@return number screenX The X coordinate in screen space
---@return number screenY The Y coordinate in screen space
function iso.isoToScreen(isoX, isoY)
  -- Adjust the multipliers to eliminate gaps between tiles
  local screenX = (isoX - isoY) * (iso.TILE_WIDTH / 2)  -- Halved the width multiplier
  local screenY = (isoX + isoY) * (iso.TILE_HEIGHT / 2) -- Halved the height multiplier
  return screenX, screenY
end

return iso
