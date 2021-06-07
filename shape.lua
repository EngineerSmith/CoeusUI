local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local shape = setmetatable({}, ui)
shape.__index = shape

shape.new = function(...)
    local self = setmetatable(ui.new(...), shape)
    self.angle1 = 0
    self.angle2 = 0
    self.lineSize = 1
    return self
end

shape.setShape = function(self, type, mode)
    return self:setType(type):setDrawMode(mode)
end

local types = {
    ["rectangle"] = 1,
    ["circle"] = 1,
    ["ellipse"] = 1,
    ["arc"] = 1
}

shape.setType = function(self, type)
    self.type = types[type] and type or error("Shape: 2nd argument not supported type\n Gave: "..tostring(type))
    return self
end

local drawModes = {
    ["fill"] = 1,
    ["line"] = 1,
    ["none"] = 1,
}

shape.setDrawMode = function(self, mode)
   self.mode = drawModes[mode] and mode or error("Shape: 2nd argument not supported mode\n Gave: "..tostring(mode))
   return self
end

shape.setRoundCorner = function(self, rx, ry)
   self.rx, self.ry = rx, ry
   return self
end

shape.setSegments = function(self, segments)
    self.segments = segments
    return self
end

shape.setOutline = function(self, enabled, distance, size, color)
    self.lineEnabled = enabled or false
    self.lineDistance = distance or 2
    self.lineSize = size or 1
    self.lineColor = color or self.color
    return self
end

shape.setAngles = function(self, angle1, angle2)
    if self.type ~= "arc"then error("Shape: given shape isn't of type arc, it cannot have it's angle set") end
    
    self.angle1 = angle1 or self.angle1
    self.angle2 = angle2 or self.angle2
    
    return self
end

local lg = love.graphics

shape.drawElement = function(self)
    local x, y, w, h = self.transform:get()
    local halfW, halfH = w/2, h/2
    local centreX, centreY = x+halfW, y+halfH
    local radius = halfW < halfH and halfW or halfH
    
    local line = self.lineDistance
    lg.setLineWidth(self.lineSize)
    lg.setColor(self.lineColor or self.color)
    
    if self.type == "rectangle" then
        if self.lineEnabled then
            lg.rectangle("line", x-line, y-line, w+line*2, h+line*2, self.rx, self.ry, self.segments)
        end
        lg.setLineWidth(1)
        
        lg.setColor(self.color)
        if self.mode ~= "none"then
            lg.rectangle(self.mode, x, y, w, h, self.rx, self.ry, self.segments)
        end
    elseif self.type == "circle" then
        if self.lineEnabled then
            lg.circle("line", centreX-line, centreY-line, radius+line*2, self.segments)
        end
        lg.setLineWidth(1)
        
        lg.setColor(self.color)
        if self.mode ~= "none"then
            lg.circle(self.mode, centreX, centreY, radius, self.segments)
        end
    elseif self.type == "ellipse" then
        if self.lineEnabled then
            lg.ellipse("line", centreX-line, centreY-line, halfW+line*2, halfH+line*2, self.segments)
        end
        lg.setLineWidth(1)
        
        lg.setColor(self.color)
        if self.mode ~= "none"then
            lg.ellipse(self.mode, centreX, centreY, halfW, halfH, self.segments)
        end
    elseif self.type == "arc" then
        if self.lineEnabled then
            lg.arc("line", centreX-line, centreY-line, radius+line*2, self.angle1, self.angle2, self.segments)
        end
        lg.setLineWidth(1)
        
        lg.setColor(self.color)
        if self.mode ~= "none"then
            lg.arc(self.mode, centreX, centreY, radius, self.angle1, self.angle2, self.segments)
        end
    else
        error("Shape: Undefined behaviour for "..tostring(self.type) .. " while trying to draw")
    end
end

return shape