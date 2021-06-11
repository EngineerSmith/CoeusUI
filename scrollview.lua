local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local scrollview = setmetatable({}, ui)
scrollview.__index = scrollview

scrollview.new = function(...)
    local self = setmetatable(ui.new(...), scrollview)
    self.maskFunction = function()
        lg.rectangle("fill", self.transform:get())
    end
    
    self:setScrollDirection("vertical", 0.2)
    
    return self
end

local directions = {
    ["horizontal"] = 1,
    ["vertical"] = 1,
}

scrollview.setScrollDirection = function(self, direction, lengthPercent)
    self.direction = directions[direction] and direction or error("Scrollview: 2nd argument not supported type\n Gave: "..tostring(direction))
    self.lengthPercent = lengthPercent or 0.2
    self.offsetX, self.offsetY = 0, 0
    return self
end

scrollview.addChild = function(self, child)
    local _, index = ui.addChild(self, child)
    
    if self.direction == "vertical" then
        child.transform:set(0,(index-1)*self.lengthPercent,1,index*self.lengthPercent)
    end
end

scrollview.empty = function(self)
    self:removeChildren(unpack(self.children))
    self.offsetX, self.offsetY = 0, 0
end

local lg = love.graphics

scrollview.drawChildren = function(self) 
    lg.setColor(1,1,1)
    
    lg.stencil(self.maskFunction, "replace", "1")
    lg.setStencilTest("greater", 0)
    lg.push()
    lg.translate(self.offsetX, self.offsetY)
    for _, child in ipairs(self.children) do
        if child.enabled then
            child:draw()
        end
    end
    lg.pop()
    lg.setStencilTest()
end

return scrollview