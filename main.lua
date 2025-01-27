---@diagnostic disable: undefined-global
require('love')

local assets = require('src.utils.assets')
local TileMap = require('src.map.tilemap')

local map

function love.load()
  -- Load tileset with correct tile dimensions (32x32)
  local tileset = assets.loadTileset('assets/tileset.png', 32, 32)

  -- Create 8x8 map
  map = TileMap.new(8, 8)
  map:setTileset(tileset)
end

function love.update(dt)
end

function love.draw()
  map:draw()
end
