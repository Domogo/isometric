local Class = require('src.utils.class')

---@class Animation
---@field tileset table The tileset containing image and quads
---@field frames table<number, number> Array of frame indices
---@field duration number Duration of the complete animation in seconds
---@field timer number Current animation timer
---@field currentFrame number Current frame index
local Animation = Class {
  ---Initialize a new Animation instance
  ---@param self Animation
  ---@param tileset table The tileset containing image and quads
  ---@param frames table<number, number> Array of frame indices
  ---@param duration number Duration of the complete animation in seconds
  init = function(self, tileset, frames, duration)
    self.tileset = tileset
    self.frames = frames
    self.duration = duration
    self.timer = 0
    self.currentFrame = 1
  end
}

---Update the animation state
---@param dt number Delta time in seconds
function Animation:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.duration then
    self.timer = self.timer - self.duration
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame > #self.frames then
      self.currentFrame = 1
    end
  end
end

---Draw the current animation frame
---@param x number X coordinate to draw at
---@param y number Y coordinate to draw at
---@param r? number Rotation in radians (default: 0)
---@param sx? number Scale factor on X axis (default: 1)
---@param sy? number Scale factor on Y axis (default: 1)
function Animation:draw(x, y, r, sx, sy)
  love.graphics.draw(
    self.tileset.image,
    self.tileset.quads[self.frames[self.currentFrame]],
    x, y, r or 0, sx or 1, sy or 1
  )
end

---@class assets
---@field images table<string, love.Image> Cached images
---@field animations table<string, Animation> Cached animations
---@field tilesets table<string, table> Cached tilesets
local assets = {
  images = {},     -- Store loaded images
  animations = {}, -- Store animation data
  tilesets = {}    -- Store tileset data
}

---Load an image and cache it
---@param path string Path to the image file
---@return love.Image image The loaded image
function assets.loadImage(path)
  if not assets.images[path] then
    local success, result = pcall(love.graphics.newImage, path)
    if success then
      assets.images[path] = result
    else
      error("Failed to load image: " .. path)
    end
  end
  return assets.images[path]
end

---Load a tileset and define its properties
---@param path string Path to the tileset image
---@param tileWidth number Width of each tile in pixels
---@param tileHeight number Height of each tile in pixels
---@return table tileset Table containing tileset data and quads
function assets.loadTileset(path, tileWidth, tileHeight)
  if not assets.tilesets[path] then
    local image = assets.loadImage(path)
    local tileset = {
      image = image,
      tileWidth = tileWidth,
      tileHeight = tileHeight,
      width = image:getWidth(),
      height = image:getHeight(),
      cols = math.floor(image:getWidth() / tileWidth),
      rows = math.floor(image:getHeight() / tileHeight)
    }

    -- Create quad lookup table
    tileset.quads = {}
    for y = 0, tileset.rows - 1 do
      for x = 0, tileset.cols - 1 do
        local quad = love.graphics.newQuad(
          x * tileWidth,
          y * tileHeight,
          tileWidth,
          tileHeight,
          tileset.width,
          tileset.height
        )
        table.insert(tileset.quads, quad)
      end
    end

    assets.tilesets[path] = tileset
  end
  return assets.tilesets[path]
end

---Create an animation from a spritesheet
---@param tileset table The tileset containing image and quads
---@param frames table<number, number> Array of frame indices
---@param duration number Duration of the complete animation in seconds
---@return Animation animation The created animation instance
function assets.createAnimation(tileset, frames, duration)
  return Animation(tileset, frames, duration)
end

---Clear all cached assets
function assets.clear()
  assets.images = {}
  assets.animations = {}
  assets.tilesets = {}
end

return assets
