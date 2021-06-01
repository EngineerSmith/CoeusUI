local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")
local utilities = require(path.."base.utilities")
local shape = require(path.."shape")

local button = setmetatable({}, ui)
button.__index = button

button.new = function(...)
    local self = setmetatable(ui.new(...), button)
    self.touches = {}
    self.cbPressed  = utilities.nilFunc
    self.cbReleased = utilities.nilFunc
    self:setActive(false)
    return self
end

button.setActive = function(self, active)
    if self.theme then 
        if self.active ~= active then
            self.active = active
            self:updateActiveChanges()
        end
    else
        self.active = active
    end
end

button.updateActiveChanges = function(self)
    if self.theme then
        if self.shape then
            self.shape:setColor(self.active and self.theme.primaryColor or self.theme.inactiveColor)
            self.shape.lineColor = self.shape.color -- Line cannot have a different colour to shape on a button
        end
    end
end

button.setTheme = function(self, theme)
    self.theme = theme
    if theme and theme.factory.button then
        theme.factory.button(self)
    end
    return self
end

button.setCBPressed = function(self, cb)
    self.cbPressed = cb or utilities.nilFunc
    self:setActive(cb ~= nil or self.cbReleased ~= utilities.nilFunc)
end

button.setCBReleased = function(self, cb) 
    self.cbReleased = cb or utilities.nilFunc
    self:setActive(cb ~= nil or self.cbPressed ~= utilities.nilFunc)
end

button.setShape = function(self, type)
    self.shape = shape(0,0,1,1)
    self.shape:setType(type):setDrawMode("fill")
    self:addChild(self.shape)
    self:updateActiveChanges()
    return self
end

button.setOutline = function(self, enabled, distance, size) -- Note, color has been removed
    if not self.shape then error("Shape: Must call setShape before calling setOutline") end
    self.shape:setOutline(enabled, distance, size)
    return self
end

button.setRoundCorner = function(self, ...)
    if not self.shape then error("Shape: Must call setShape before calling setRoundCorner") end
    self.shape:setRoundCorner(...)
    return self
end

button.setSegments = function(self, ...)
    if not self.shape then error("Shape: Must call setShape before calling setSegments") end
    self.shape:setSegments(...)
    return self
end

button.setText = function()
    
end

button.setImage = function()
    
end

local findTouch = function(touches, id)
    for k,v in ipairs(touches) do
        if v == id then return k end
    end
    return -1
end

button.touchpressedElement = function(self, id, x, y)
    if self.active and utilities.aabb(x, y, self.transform:get()) then
        table.insert(self.touches, id)
        self.state = "held"
        local result = self:cbPressed()
        return result ~= nil and result or true
    end
    return false
end

button.touchreleasedElement = function(self, id, x, y)
    local key = findTouch(self.touches, id)
    if key ~= -1 then
        table.remove(self.touches, key)
        if self.active and utilities.aabb(x, y, self.transform:get()) then
            local result = self:cbReleased()
            if #self.touches == 0 then
                self.state = nil
            end
            return result ~= nil and result or true
        end
    end
    return false
end

return button