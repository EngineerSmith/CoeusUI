local transform = {}
transform.__index = transform
--                       minX,  minY,maxX, maxY,   offsetX,    offsetY
transform.new = function(right, top, left, bottom, horizontal, vertical)
    local self = setmetatable({
        -- Transform points (percent 0..1)
        top        = top        or error("Transform: 1st argument required"),
        right      = right      or error("Transform: 2nd argument required"),
        bottom     = bottom     or error("Transform: 3rd argument required"),
        left       = left       or error("Transform: 4th argument required"),
        -- Offsets (pixels)
        horizontal = horizontal or 0,
        vertical   = vertical   or 0,
        -- Caluated values
        x = 0, y = 0, w = 0, h = 0
    }, transform)

    -- Validation
    if self.top < 0 then error("Transform: 1st argument must be greater than 0\n Gave: "..self.top)
    elseif self.top > 1 then error("Transform: 1st argument must be less than 1\n Gave: "..self.top) end
        
    if self.right < 0 then error("Transform: 2nd argument must be greater than 0\n Gave: "..self.right)
    elseif self.right > 1 then error("Transform: 2nd argument must be less than 1\n Gave: "..self.right) end
        
    if self.bottom < 0 then error("Transform: 3rd argument must be greater than 0\n Gave: "..self.bottom)
    elseif self.bottom > 1 then error("Transform: 3rd argument must be less than 1\n Gave: "..self.bottom) end
    
    if self.left < 0 then error("Transform: 4th argument must be greater than 0\n Gave: "..self.left)
    elseif self.left > 1 then error("Transform: 4th argument must be less than 1\n Gave: "..self.left) end
    
    if self.top > self.bottom then error("Transform: Top cannot be greater than bottom") end
    if self.right > self.left then error("transform: Right cannot be greater than left") end
    
    return self
end

transform.set = function(self, right, top, left, bottom)
    return self:setRight(right):setTop(top):setLeft(left):setBottom(bottom)
end

transform.setTop = function(self, value)
    if not value then error("Transform: 2nd argument required")
    elseif value < 0 then error("Transform: 2nd argument must be greater than 0\n Gave: "..tostring(value))
    elseif value > 1 then error("Transform: 2nd argument must be less than 1\n Gave: "..tostring(value)) end
    
    self.top = value
    return self
end

transform.setRight = function(self, value)
    if not value then error("Transform: 2nd argument required")
    elseif value < 0 then error("Transform: 2nd argument must be greater than 0\n Gave: "..tostring(value))
    elseif value > 1 then error("Transform: 2nd argument must be less than 1\n Gave: "..tostring(value)) end
    
    self.right = value
    return self
end

transform.setBottom = function(self, value)
    if not value then error("Transform: 2nd argument required")
    elseif value < 0 then error("Transform: 2nd argument must be greater than 0\n Gave: "..tostring(value))
    elseif value > 1 then error("Transform: 2nd argument must be less than 1\n Gave: "..tostring(value)) end
        
    self.bottom = value
    return self
end

transform.setLeft = function(self, value)
    if not value then error("Transform: 2nd argument required")
    elseif value < 0 then error("Transform: 2nd argument must be greater than 0\n Gave: "..tostring(value))
    elseif value > 1 then error("Transform: 2nd argument must be less than 1\n Gave: "..tostring(value)) end
    
    self.left = value
    return self
end

transform.calculate = function(self, width, height, offsetX, offsetY)
    -- Position
    self.x = self.right * width
    self.y = self.top * height
    -- Length
    self.w = (self.left * width) - self.x
    self.h = (self.bottom * height) - self.y
    -- Offset
    self.x = self.x + self.horizontal + offsetX
    self.y = self.y + self.vertical + offsetY
    
    return self:get()
end

transform.get = function(self)
    return self.x, self.y, self.w, self.h
end

return transform