---@diagnostic disable: undefined-global
require('love')

local push = require('src.utils.push')
local assets = require('src.utils.assets')
local TileMap = require('src.map.tilemap')

-- Physical screen dimensions
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

-- Virtual resolution dimensions
local VIRTUAL_WIDTH = 864
local VIRTUAL_HEIGHT = 486

local map

function love.load()
  -- Initialize nearest-neighbor filter
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- Initialize our virtual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  -- Load tileset with correct tile dimensions (64x64 for cube tiles)
  -- Width is 64 (cube width), height is 64 (includes top face + sides)
  local tileset = assets.loadTileset('assets/tileset64.png', 64, 64)

  map = TileMap(9, 9)
  map:setTileset(tileset)
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  -- Get mouse position in virtual coordinates
  local mouseX, mouseY = push:toGame(love.mouse.getPosition())

  if mouseX and mouseY then
    -- Adjust for screen center translation
    mouseX = mouseX - VIRTUAL_WIDTH / 2
    mouseY = mouseY - VIRTUAL_HEIGHT / 2

    -- Convert mouse position to tile coordinates
    local tileX, tileY = map:mouseToTile(mouseX, mouseY)

    -- Update hover state for all tiles
    for y = 1, map.height do
      for x = 1, map.width do
        local tile = map.tiles[y][x]
        if tile.x == tileX and tile.y == tileY then
          tile:setTileId(2) -- Hover state tile ID
        else
          tile:setTileId(1) -- Normal state tile ID
        end
      end
    end
  end
end

function love.draw()
  push:start()
  -- Translate to center of virtual resolution
  love.graphics.translate(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
  map:draw()
  push:finish()
end
