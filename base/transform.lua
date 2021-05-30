local anchor = {}
anchor.__index = anchor

anchor.new = function(top, right, bottom, left, horizontal, vertical)
    local self = setmetatable({
        -- Anchor points (percent 0..1)
        top        = top        or error("Anchor: 1st argument required"),
        right      = right      or error("Anchor: 2nd argument required"),
        bottom     = bottom     or error("Anchor: 3rd argument required"),
        left       = left       or error("Anchor: 4th argument required"),
        -- Offsets (pixels)
        horizontal = horizontal or 0,
        vertical   = vertical   or 0,
        -- Caluated values
        x = 0, y = 0, w = 0, h = 0
    }, anchor)

    -- Validation
    if self.top < 0 then error("Anchor: 1st argument must be greater than 0\n Gave: "..self.top)
    elseif self.top > 1 then error("Anchor: 1st argument must be less than 1\n Gave: "..self.top) end
        
    if self.right < 0 then error("Anchor: 2nd argument must be greater than 0\n Gave: "..self.right)
    elseif self.right > 1 then error("Anchor: 2nd argument must be less than 1\n Gave: "..self.right) end
        
    if self.bottom < 0 then error("Anchor: 3rd argument must be greater than 0\n Gave: "..self.bottom)
    elseif self.bottom > 1 then error("Anchor: 3rd argument must be less than 1\n Gave: "..self.bottom) end
    
    if self.left < 0 then error("Anchor: 4th argument must be greater than 0\n Gave: "..self.left)
    elseif self.left > 1 then error("Anchor: 4th argument must be less than 1\n Gave: "..self.left) end
    
    return self
end

anchor.calculate = function(self, width, height, offsetX, offsetY)
    -- Position
    self.x = self.right * width + self.horizontal
    self.y = self.top * height + self.vertical
    -- Length
    self.w = (self.left * width) - self.x
    self.h = (self.bottom * height) - self.y
    -- Offset
    self.x = self.x + offsetX
    self.y = self.y + offsetY
end

anchor.get = function(self)
    return self.x, self.y, self.w, self.h
end

return setmetatable(anchor, {
    __call = function(tbl, ...)
        return tbl.new(...)
    end
})