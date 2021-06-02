local path = (...):match("(.-)[^%.]+$")
local transform = require(path.."transform")

local ui = {}
ui.__index = ui
ui.__call = function(tbl, ...)
    return tbl.new(...)
end

ui.new = function(...)
    return setmetatable({
        transform = transform.new(...),
        children  = {count=0},
        parent    = nil,
        enabled   = true,
        active    = true,
        state     = nil
    }, ui)
end

ui.addChild = function(self, child)
    if child.parent then 
        error("Ui: element given already has a parent") 
    end
    
    table.insert(self.children, child)
    self.children.count = self.children.count + 1
    child.parent = self
    return self.children.count
end

ui.setActive = function(self, active)
    self.active = active
end

ui.updateTransform = function(self)
    if self.parent then
        self.parent:updateTransform()
    else
        if not self.width or not self.height then
            error("Ui: Current element isn't a window element, cannot calculate transform")
        end
        self:updateTransformRecursive(self.width, self.height)
    end
end

ui.updateTransformRecursive = function(self, width, height, offsetX, offsetY)
    local x, y, w, h = self.transform:calculate(width, height, offsetX or 0, offsetY or 0)
    for _, child in ipairs(self.children) do
        child:updateTransformRecursive(w, h, x, y)
    end
end

ui.update = function(self, dt)
    self:updateElement(dt)
    self:updateChildren(dt)
end

ui.updateChildren = function(self, dt) 
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

ui.updateElement = function(self, dt) end 

ui.draw = function(self)
    if self.enabled then
        self:drawElement()
        self:drawChildren()
    end
end

ui.drawChildren = function(self) 
    for _, child in ipairs(self.children) do
        if child.enabled then
            child:draw()
        end
    end
end

ui.drawElement = function(self) end

-- Events

ui.touchpressed = function(self, ...)
    return self:touchpressedChildren(...) or self:touchpressedElement(...)
end

ui.touchpressedChildren = function(self, ...)
    for _, child in ipairs(self.children) do
        if child.enabled and child:touchpressed(...) then
            return true
        end
    end
    return false
end

ui.touchpressedElement = function(self, id, x, y, dx, dy, pressure)
    return false
end

ui.touchmoved = function(self, ...)
   return self:touchmovedChildren(...) or self:touchmovedElement(...) 
end

ui.touchmovedChildren = function(self, ...)
    for _, child in ipairs(self.children) do
        if child.enabled and child:touchmoved(...) then
            return true
        end
    end
    return false
end

ui.touchmovedElement = function(self, id, x, y, dx, dy, pressure)
    return false
end

ui.touchreleased = function(self, ...)
    return self:touchreleasedChildren(...) or self:touchreleasedElement(...)
end

ui.touchreleasedChildren = function(self, ...)
    for _, child in ipairs(self.children) do
        if child.enabled and child:touchreleased(...) then
            return true
        end
    end
    return false
end

ui.touchreleasedElement = function(self, id, x, y, dx, dy, pressure)
    return false
end

ui.resize = function(self, ...)
    self:resizeElement(...)
    self:resizeChildren(...)
end

ui.resizeChildren = function(self, ...)
    for _, child in ipairs(self.children) do
        child:resize(...)
    end
end

ui.resizeElement = function(self, w, h) end

return ui