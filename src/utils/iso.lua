local iso = {}

-- Tile dimensions (matching the actual tileset dimensions)
iso.TILE_WIDTH = 64  -- Width of the tile
iso.TILE_HEIGHT = 32 -- Height of the top face (half of width for isometric)
iso.TILE_DEPTH = 64  -- Full height of the cube including sides

-- Convert screen coordinates to isometric coordinates
function iso.screenToIso(screenX, screenY, mapCenterScreenX, mapCenterScreenY)
  -- Adjust coordinates relative to map center
  screenX = screenX + mapCenterScreenX + iso.TILE_WIDTH / 2
  screenY = screenY + mapCenterScreenY

  -- Convert to isometric coordinates
  local isoX = (screenX / (iso.TILE_WIDTH / 2) + screenY / (iso.TILE_HEIGHT / 2)) / 2
  local isoY = (screenY / (iso.TILE_HEIGHT / 2) - screenX / (iso.TILE_WIDTH / 2)) / 2

  return math.floor(isoX), math.floor(isoY)
end

-- Convert isometric coordinates to screen coordinates
function iso.isoToScreen(isoX, isoY)
  -- Adjust the multipliers to eliminate gaps between tiles
  local screenX = (isoX - isoY) * (iso.TILE_WIDTH / 2)  -- Halved the width multiplier
  local screenY = (isoX + isoY) * (iso.TILE_HEIGHT / 2) -- Halved the height multiplier
  return screenX, screenY
end

return iso
