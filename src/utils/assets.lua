local assets = {
  images = {},       -- Store loaded images
  animations = {},   -- Store animation data
  tilesets = {}      -- Store tileset data
}

-- Load an image and cache it
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

-- Load a tileset and define its properties
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

-- Create an animation from a spritesheet
function assets.createAnimation(tileset, frames, duration)
  local animation = {
    tileset = tileset,
    frames = frames,
    duration = duration,
    timer = 0,
    currentFrame = 1
  }

  -- Update animation frame
  function animation:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.duration then
      self.timer = self.timer - self.duration
      self.currentFrame = self.currentFrame + 1
      if self.currentFrame > #self.frames then
        self.currentFrame = 1
      end
    end
  end

  -- Draw current frame
  function animation:draw(x, y, r, sx, sy)
    love.graphics.draw(
      self.tileset.image,
      self.tileset.quads[self.frames[self.currentFrame]],
      x, y, r or 0, sx or 1, sy or 1
    )
  end

  return animation
end

-- Clear all cached assets
function assets.clear()
  assets.images = {}
  assets.animations = {}
  assets.tilesets = {}
end

return assets
