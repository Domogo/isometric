local iso = {}

-- Tile dimensions (matching the actual tileset dimensions)
iso.TILE_WIDTH = 32  -- Actual tile width from tileset
iso.TILE_HEIGHT = 16 -- Half of width for isometric

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
