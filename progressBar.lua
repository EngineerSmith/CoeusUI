local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")
local shape = require(path.."shape")

local progressBar = setmetatable({}, ui)
progressBar.__index = progressBar

progressBar.new = function(...)
    local self = setmetatable(ui.new(...), progressBar)
    self.direction = "left"
    return self
end

local shapes = {
    ["rectangle"] = "rectangle",
    ["arc"] = "circle",
    ["ellipse"] = "ellipse"
}

progressBar.setShape = function(self, type, color)
    if type == "circle" then type = "arc" end
    if self.shape then self:removeChild(self.shape) end
    self.shape = shape(0,0,1,1)
    self.shape:setType(type):setDrawMode("fill"):setColor(color)
    self:addChild(self.shape)
    return self
end

progressBar.setOutline = function(self, distance, size, color)
    if not self.shape then error("ProgressBar: Must call setShape before calling setOutline") end
    if self.outline then self:removeChild(self.outline) end
    self.outline = shape(0,0,1,1)
    local type = shapes[self.shape.type]
    if not type then error("ProgressBar: Undefined behaviour, check valid shapes") end
    self.outline:setType(type):setDrawMode("none"):setOutline(true, distance, size, color)
    self:addChild(self.outline)
    return self
end

local directions = {
    ["top"] = "bottom", -- Top to Bottom 
    ["bottom"] = "top", -- Bottom to Top
    ["left"] = "right", -- Left to Right
    ["right"] = "left", -- Right to Left
}

progressBar.setDirection = function(self, direction)
    if not direction then error("ProgressBar: 2nd argument required") end
    self.direction = directions[direction] and direction or error("ProgressBar: 2nd argument not supported type\n Gave: "..tostring(direction))
    return self
end


progressBar.setProgress = function(self, progress)
    if not self.shape then error("ProgressBar: Must call setShape before calling setProgress") end
    
    if not progress then error("ProgressBar: 2nd argument required")
    elseif progress < 0 then error("ProgressBar: 2nd argument must be greater than 0")
    elseif progress > 1 then error("ProgressBar: 2nd argument must be less than 1") end
        
    self.progress = progress
    
    if self.shape.type == "rectangle" then
        local t = self.shape.transform
        --self.shape.transform[self.direction] = progress
        t.top    = self.direction == "top"    and   progress or 1
        t.bottom = self.direction == "bottom" and 1-progress or 0
        t.left   = self.direction == "left"   and   progress or 1
        t.right  = self.direction == "right"  and 1-progress or 0
    elseif self.shape.type == "arc" then
        
    else
        error("ProgressBar: Undefined behaviour for type: "..tostring(self.shape.type))
    end
    
    return self
end

return progressBar