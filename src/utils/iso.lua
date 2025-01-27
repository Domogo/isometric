local iso = {}

-- Tile dimensions (can be adjusted based on your tile assets)
iso.TILE_WIDTH = 64  -- Default tile width
iso.TILE_HEIGHT = 32 -- Default tile height (half of width for isometric)

-- Convert screen coordinates to isometric coordinates
function iso.screenToIso(screenX, screenY)
  local isoX = (screenX / iso.TILE_WIDTH + screenY / iso.TILE_HEIGHT) / 2
  local isoY = (screenY / iso.TILE_HEIGHT - screenX / iso.TILE_WIDTH) / 2
  return isoX, isoY
end

-- Convert isometric coordinates to screen coordinates
function iso.isoToScreen(isoX, isoY)
  local screenX = (isoX - isoY) * iso.TILE_WIDTH
  local screenY = (isoX + isoY) * iso.TILE_HEIGHT / 2
  return screenX, screenY
end

return iso
