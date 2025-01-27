local Class = require('src/utils/class')

local Sprite = Class {
  init = function(self, image, x, y, layer)
    self.image = image
    self.x = x or 0
    self.y = y or 0
    self.layer = layer or 0
    self.rotation = 0
    self.scaleX = 1
    self.scaleY = 1
    self.originX = 0
    self.originY = 0
    self.quad = nil
    self.animation = nil
  end
}

-- Set sprite position
function Sprite:setPosition(x, y)
  self.x = x
  self.y = y
end

-- Set sprite scale
function Sprite:setScale(sx, sy)
  self.scaleX = sx
  self.scaleY = sy or sx
end

-- Set sprite rotation (in radians)
function Sprite:setRotation(rotation)
  self.rotation = rotation
end

-- Set sprite origin point
function Sprite:setOrigin(x, y)
  self.originX = x
  self.originY = y
end

-- Set sprite layer (for depth sorting)
function Sprite:setLayer(layer)
  self.layer = layer
end

-- Set sprite quad (for sprite sheets)
function Sprite:setQuad(quad)
  self.quad = quad
end

-- Set sprite animation
function Sprite:setAnimation(animation)
  self.animation = animation
end

-- Update sprite (for animations)
function Sprite:update(dt)
  if self.animation then
    self.animation:update(dt)
  end
end

-- Draw the sprite
function Sprite:draw()
  if self.animation then
    self.animation:draw(
      self.x,
      self.y,
      self.rotation,
      self.scaleX,
      self.scaleY
    )
  else
    love.graphics.draw(
      self.image,
      self.quad,
      self.x,
      self.y,
      self.rotation,
      self.scaleX,
      self.scaleY,
      self.originX,
      self.originY
    )
  end
end

-- Sprite Manager for handling multiple sprites
local SpriteManager = Class {
  init = function(self)
    self.sprites = {}
  end
}

-- Add a sprite to the manager
function SpriteManager:add(sprite)
  table.insert(self.sprites, sprite)
  return sprite
end

-- Remove a sprite from the manager
function SpriteManager:remove(sprite)
  for i, s in ipairs(self.sprites) do
    if s == sprite then
      table.remove(self.sprites, i)
      break
    end
  end
end

-- Update all sprites
function SpriteManager:update(dt)
  for _, sprite in ipairs(self.sprites) do
    sprite:update(dt)
  end
end

-- Draw all sprites (sorted by layer)
function SpriteManager:draw()
  -- Sort sprites by layer
  table.sort(self.sprites, function(a, b)
    return a.layer < b.layer
  end)

  -- Draw sprites
  for _, sprite in ipairs(self.sprites) do
    sprite:draw()
  end
end

-- Clear all sprites
function SpriteManager:clear()
  self.sprites = {}
end

return {
  Sprite = Sprite,
  Manager = SpriteManager
}
