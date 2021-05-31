local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local shape = setmetatable({}, ui)
shape.__index = shape

shape.new = function(...)
    local self = setmetatable(ui.new(...), shape)
    self.color = {1,1,1}
    return self
end

shape.setShape = function(self, type, mode)
    return self:setType(type):setDrawMode(mode)
end

local types = {
    ["rectangle"] = 1,
    ["circle"] = 1,
    ["eclipse"] = 1,
}

shape.setType = function(self, type)
    self.type = types[type] and type or error("Shape must be a supported type. "..tostring(type))
    return self
end

local drawModes = {
    ["fill"] = 1,
    ["line"] = 1,
}

shape.setDrawMode = function(self, mode)
   self.mode = drawModes[mode] and mode or error("Drawmode must be a supported type. "..tostring(mode))
   return self
end

shape.setColor = function(self, r, g, b, a)
    self.color[1] = r or self.color[1] or 1
    self.color[2] = g or self.color[2] or 1
    self.color[3] = b or self.color[3] or 1
    self.color[4] = a or self.color[4] or 1
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

local lg = love.graphics

shape.drawElement = function(self)
    local x, y, w, h = self.transform:get()
    if self.type == "rectangle" then
        if self.lineEnabled then
            local line = self.lineDistance
            lg.setLineWidth(self.lineSize)
            lg.setColor(self.lineColor)
            lg.rectangle("line", x-line, y-line, w+line*2, h+line*2, self.rx, self.ry, self.segments)
            lg.setLineWidth(1)
        end
        
        lg.setColor(self.color)
        lg.rectangle(self.mode, x, y, w, h, self.rx, self.ry, self.segments)
    elseif self.type == "circle" or self.type == "eclipse" then
        if self.lineEnabled then
            local line = self.lineDistance
            lg.setLineWidth(self.lineSize)
            lg.setColor(self.lineColor)
            lg.eclipse("line", x-line, y-line, w+line*2, h+line*2, self.segments)
            lg.setLineWidth(1)
        end
        
        lg.setColor(self.color)
        lg.eclipse(self.mode, x, y, w, h, self.segments)
    end
end

return shape