local iso = require('src.utils.iso')
local Class = require('src.utils.class')

local TileHover = Class {
  init = function(self, tilemap)
    self.tilemap = tilemap
    self.hoveredTile = nil
    self.hoverImage = love.graphics.newImage('assets/hover.png')
  end
}

function TileHover:screenToTile(screenX, screenY)
  -- Get map center in screen coordinates
  local mapCenterX, mapCenterY = iso.isoToScreen(self.tilemap.width / 2, self.tilemap.height / 2)

  -- Adjust screen coordinates relative to map center
  screenX = screenX + mapCenterX + iso.TILE_WIDTH / 2
  screenY = screenY + mapCenterY

  -- Convert to isometric coordinates
  local isoX, isoY = iso.screenToIso(screenX, screenY)

  -- Round to nearest tile (convert to 0-based coordinates)
  local tileX = math.floor(isoX)
  local tileY = math.floor(isoY)

  return tileX, tileY
end

function TileHover:update()
  local mouseX, mouseY = love.mouse.getPosition()
  local tileX, tileY = self:screenToTile(mouseX, mouseY)

  -- Check if coordinates are within map bounds (using 0-based coordinates)
  if tileX >= 0 and tileX < self.tilemap.width and tileY >= 0 and tileY < self.tilemap.height then
    self.hoveredTile = self.tilemap:getTile(tileX, tileY)
  else
    self.hoveredTile = nil
  end
end

function TileHover:draw()
  if not self.hoveredTile then return end

  -- Calculate map center in isometric coordinates
  local mapCenterX = self.tilemap.width / 2
  local mapCenterY = self.tilemap.height / 2

  -- Get screen coordinates for map center
  local mapCenterScreenX, mapCenterScreenY = iso.isoToScreen(mapCenterX, mapCenterY)

  -- Get screen coordinates for hovered tile
  local tileX, tileY = self.hoveredTile:getPosition()
  local tileScreenX, tileScreenY = iso.isoToScreen(tileX, tileY)

  -- Offset by map center
  local screenX = tileScreenX - mapCenterScreenX - iso.TILE_WIDTH / 2
  local screenY = tileScreenY - mapCenterScreenY

  -- Draw hover image
  love.graphics.draw(
    self.hoverImage,
    screenX,
    screenY
  )
end

return TileHover
