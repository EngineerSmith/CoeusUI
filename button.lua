local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")
local utilities = require(path.."base.utilities")
local shape = require(path.."shape")
local text = require(path.."text")
local image = require(path.."image")

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
    local t = self.theme
    if t then
        if self.shape then
            self.shape:setColor(self.active and t.primaryColor or t.inactiveColor)
            self.shape.lineColor = self.shape.color -- Line cannot have a different colour to shape on a button
        end
        if self.text then
            self.text:setColor(self.active and t.fontColor or t.inactiveFontColor)
        end
        
        if self.image then
            error("TODO")
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
    return self
end

button.setCBReleased = function(self, cb) 
    self.cbReleased = cb or utilities.nilFunc
    self:setActive(cb ~= nil or self.cbPressed ~= utilities.nilFunc)
    return self
end

-- [[ SHAPE ]]
button.setShape = function(self, type)
    if self.shape then self:removeChild(self.shape) end
    self.shape = shape(0,0,1,1)
    self.shape:setType(type):setDrawMode("fill")
    self:addChild(self.shape)
    self:updateActiveChanges()
    return self
end

button.setOutline = function(self, enabled, distance, size) -- Note, color has been removed
    if not self.shape then error("Button: Must call setShape before calling setOutline") end
    self.shape:setOutline(enabled, distance, size)
    return self
end

button.setRoundCorner = function(self, ...)
    if not self.shape then error("Button: Must call setShape before calling setRoundCorner") end
    self.shape:setRoundCorner(...)
    return self
end

button.setSegments = function(self, ...)
    if not self.shape then error("Button: Must call setShape before calling setSegments") end
    self.shape:setSegments(...)
    return self
end

-- [[ TEXT ]]
button.setText = function(self, string)
    if not self.text then
        self.text = text(0,0,1,1)
        self:addChild(self.text)
    end
    self.text:setString(string)
    self:updateActiveChanges()
    return self
end

button.setFont = function(self, ...)
    if not self.text then error("Button: Must call setText before calling setFont") end
    self.text:setFont(...)
    return self
end

button.setTextAllignment = function(self, ...)
    if not self.text then error("Button: Must call setText before calling setTextAllignment") end
    self.text:setAllignment(...)
    return self
end

button.setTextWrap = function(self, ...)
    if not self.text then error("Button: Must call setText before calling setTextWrap") end
    self.text:setWrap(...)
    return self
end

-- [[ IMAGE ]]
button.setImage = function(self, ...)
    if not self.image then
        self.image = image(0,0,1,1)
        self:addChild(self.image)
    end
    self.image:setImage(...)
    self:updateActiveChanges()
    return self
end

button.setQuad = function(self, ...)
    if not self.image then error("Button: Must call setImage before calling setQuad") end
    self.image:setQuad(...)
    return self
end

button.setImageAllignment = function(self, ...)
    if not self.image then error("Button: Must call setImage before calling setImageAllignment") end
    self.image:setAllignment(...)
    return self
end

button.setImageWrap = function(self, ...)
    if not self.image then error("Button: Must call setImage before calling setImageWrap") end
    self.image:setWrap(...)
    return self
end

-- [[ EVENT]]
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