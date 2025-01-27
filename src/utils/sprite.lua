local Class = require('src/utils/class')

---@class Sprite
---@field image love.Image The sprite's image
---@field x number X coordinate of the sprite
---@field y number Y coordinate of the sprite
---@field layer number Layer for depth sorting
---@field rotation number Rotation in radians
---@field scaleX number Scale factor on X axis
---@field scaleY number Scale factor on Y axis
---@field originX number X coordinate of the origin point
---@field originY number Y coordinate of the origin point
---@field quad? love.Quad Optional quad for sprite sheets
---@field animation? Animation Optional animation
local Sprite = Class {
  ---Initialize a new Sprite instance
  ---@param self Sprite
  ---@param image love.Image The sprite's image
  ---@param x? number X coordinate (defaults to 0)
  ---@param y? number Y coordinate (defaults to 0)
  ---@param layer? number Layer for depth sorting (defaults to 0)
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

---Set sprite position
---@param x number X coordinate
---@param y number Y coordinate
function Sprite:setPosition(x, y)
  self.x = x
  self.y = y
end

---Set sprite scale
---@param sx number Scale factor on X axis
---@param sy? number Scale factor on Y axis (defaults to sx)
function Sprite:setScale(sx, sy)
  self.scaleX = sx
  self.scaleY = sy or sx
end

---Set sprite rotation
---@param rotation number Rotation in radians
function Sprite:setRotation(rotation)
  self.rotation = rotation
end

---Set sprite origin point
---@param x number X coordinate of the origin point
---@param y number Y coordinate of the origin point
function Sprite:setOrigin(x, y)
  self.originX = x
  self.originY = y
end

---Set sprite layer (for depth sorting)
---@param layer number Layer number (lower numbers are drawn first)
function Sprite:setLayer(layer)
  self.layer = layer
end

---Set sprite quad (for sprite sheets)
---@param quad love.Quad The quad to use for rendering
function Sprite:setQuad(quad)
  self.quad = quad
end

---Set sprite animation
---@param animation Animation The animation to play
function Sprite:setAnimation(animation)
  self.animation = animation
end

---Update sprite (for animations)
---@param dt number Delta time in seconds
function Sprite:update(dt)
  if self.animation then
    self.animation:update(dt)
  end
end

---Draw the sprite
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

---@class SpriteManager
---@field sprites Sprite[] Array of managed sprites
local SpriteManager = Class {
  ---Initialize a new SpriteManager instance
  ---@param self SpriteManager
  init = function(self)
    self.sprites = {}
  end
}

---Add a sprite to the manager
---@param sprite Sprite The sprite to add
---@return Sprite sprite The added sprite
function SpriteManager:add(sprite)
  table.insert(self.sprites, sprite)
  return sprite
end

---Remove a sprite from the manager
---@param sprite Sprite The sprite to remove
function SpriteManager:remove(sprite)
  for i, s in ipairs(self.sprites) do
    if s == sprite then
      table.remove(self.sprites, i)
      break
    end
  end
end

---Update all sprites
---@param dt number Delta time in seconds
function SpriteManager:update(dt)
  for _, sprite in ipairs(self.sprites) do
    sprite:update(dt)
  end
end

---Draw all sprites (sorted by layer)
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

---Clear all sprites from the manager
function SpriteManager:clear()
  self.sprites = {}
end

return {
  Sprite = Sprite,
  Manager = SpriteManager
}
