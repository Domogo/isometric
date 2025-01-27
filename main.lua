---@diagnostic disable: undefined-global
require('love')

local push = require('src.utils.push')
local assets = require('src.utils.assets')
local TileMap = require('src.map.tilemap')
local TileHover = require('src.map.tile_hover')

-- Physical screen dimensions
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

-- Virtual resolution dimensions
local VIRTUAL_WIDTH = 864
local VIRTUAL_HEIGHT = 486

local map
local hover

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

  map = TileMap.new(9, 9)
  map:setTileset(tileset)

  -- Create hover effect handler
  hover = TileHover.new(map)
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  hover:update()
end

function love.draw()
  push:start()
  -- Translate to center of virtual resolution
  love.graphics.translate(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
  map:draw()
  hover:draw()
  push:finish()
end
