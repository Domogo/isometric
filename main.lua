---@diagnostic disable: undefined-global
require('love')

local push = require('src.utils.push')
local assets = require('src.utils.assets')
local TileMap = require('src.map.tilemap')

-- Physical screen dimensions
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

-- Virtual resolution dimensions
local VIRTUAL_WIDTH = 432
local VIRTUAL_HEIGHT = 243

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

  -- Load tileset with correct tile dimensions (32x32 for cube tiles)
  -- Width is 32 (cube width), height is 32 (includes top face + sides)
  local tileset = assets.loadTileset('assets/tileset.png', 32, 32)

  -- Create 8x8 map
  map = TileMap.new(8, 8)
  map:setTileset(tileset)
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
end

function love.draw()
  push:start()
  -- Translate to center of virtual resolution
  love.graphics.translate(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
  map:draw()
  push:finish()
end
