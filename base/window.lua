local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."ui")

local window = setmetatable({}, ui)
window.__index = window

window.new = function(width, height)
    local self = setmetatable(ui.new(0,0,1,1), window)
    self:setSafeArea(0, 0, width, height)
    self:draw()
    return self
end

window.setDimensions = function(self, width, height)
    if not width then error("Window: 2nd argument required") end
    if width < 0 then error("Window: 2nd argument must be greater than 0\n Gave: "..width) end
    
    if not height then error("Window: 3rd argument required") end
    if height < 0 then error("Window: 3rd argument must be greater than 0\n Gave: "..height) end
    
    self.width = width
    self.height = height
end

window.setSafeOffset = function(self, x, y)
    if not x then error("Window: 2nd argument required") end
    if not y then error("Window: 3rd argument required") end
    
    self.x = x
    self.y = y
end

window.setSafeArea = function(self, x, y, width, height)
    self:setSafeOffset(x, y)
    self:setDimensions(width, height)
end

window.update = function(self, dt)
    self:updateTransform()
    self:updateElement(dt)
    self:updateChildren(dt)
end

window.draw = function(self)
    if self.enabled then
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        self:drawElement()
        self:drawChildren()
        love.graphics.pop()
    end
end

return window