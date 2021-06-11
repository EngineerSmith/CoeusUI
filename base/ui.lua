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
        color = {1,1,1,1},
        parent    = nil,
        enabled   = true,
        active    = true,
        state     = nil
    }, ui)
end

ui.addChild = function(self, child)
    if child.parent then error("Ui: element given already has a parent") end
    
    table.insert(self.children, child)
    self.children.count = self.children.count + 1
    child.parent = self
    return child, self.children.count
end

ui.addChildren = function(self, ...)
    for _, child in ipairs(arg) do
        self:addChild(child)
    end
end

ui.removeChild = function(self, child)
    if child.parent ~= self then error("Ui: element given doesn't belong to this parent") end
    
    for i, c in ipairs(self.children) do
        if c == child then
            table.remove(self.children, i)
            child.parent = nil
            self.children.count = self.children.count - 1
            return self.children.count
        end
    end
    
    error("Ui: Undefined behaviour, given element wasn't found but had its own parent parameter set as this element")
end

ui.removeChildren = function(self, ...)
    for _, child in ipairs(arg) do
        self:removeChild(child)
    end
end

ui.setColor = function(self, r, g, b, a)
    if type(r) == "table" then
        if g == "copy" then
            self.color[1] = r[1] or 1
            self.color[2] = r[2] or 1
            self.color[3] = r[3] or 1
            self.color[4] = r[4] or 1
        else
            self.color = r
        end
    else
        self.color[1] = r or self.color[1] or 1
        self.color[2] = g or self.color[2] or 1
        self.color[3] = b or self.color[3] or 1
        self.color[4] = a or self.color[4] or 1
    end
    return self
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