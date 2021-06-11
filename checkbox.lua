local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")
local utilities = require(path.."base.utilities")
local shape = require(path.."shape")

local checkbox = setmetatable({}, ui)
checkbox.__index = checkbox

checkbox.new = function(...)
    local self = setmetatable(ui.new(...), checkbox)
    self.state = "unchecked"
    self:setCBChanged(nil)
    self.touches = {}
    return self
end

checkbox.setTheme = function(self, theme)
    self.theme = theme
    if theme and theme.factory.button then
        theme.factory.checkbox(self)
    end
    return self
end

checkbox.setChecked = function(self, checked)
    if checked then 
        self.state = "checked"
    else
        self.state = "unchecked"
    end
end

checkbox.setCBChanged = function(self, cb)
    self.cbChanged = cb or utilities.nilFunc
    return self
end

local shapes = {
    ["rectangle"] = 1,
    ["circle"] = 1,
    ["square"] = 1,
}

checkbox.setShape = function(self, background, check, backgroundColor, checkColor)
    check = check or background
    
    background = shapes[background] and background or error("Checkbox: 2nd argument not supported type\n Gave: "..tostring(background))
    check  = shapes[check]  and check  or error("Checkbox: 4th argument not supported type\n Gave: "..tostring(check))
    
    backgroundColor = backgroundColor or {.68,.68,.68,1}
    checkColor = checkColor or {.8,.8,.8,1}
    
    if self.check then self.background.removeChild(self.check) end
    if self.background then self:removeChild(self.background) end
    
    self.background = shape(0,0,1,1)
    self.background:setType(background):setDrawMode("fill"):setColor(backgroundColor)
    self:addChild(self.background)
    
    self.check = shape(.13,.13,.87,.87)
    self.check:setType(check):setDrawMode("fill"):setColor(checkColor)
    self.background:addChild(self.check)
    self.check.enabled = self.state == "checked"
    
    return self
end

checkbox.setOutline = function(self, enabled, distance, size, color)
    if not self.background then error("Checkbox: Must call setShape before calling setOutline") end
    color = color or {.6,.6,.6,1}
    self.background:setOutline(enabled, distance, size, color)
    return self
end

local findTouch = function(touches, id)
    for k,v in ipairs(touches) do
        if v == id then return k end
    end
    return -1
end

checkbox.touchpressedElement = function(self, id, x, y)
    if self.active and utilities.aabb(x, y, self.transform:get()) then
        table.insert(self.touches, id)
        return true
    end
    return false
end

checkbox.touchreleasedElement = function(self, id, x, y)
    local key = findTouch(self.touches, id)
    if key ~= -1 then
        table.remove(self.touches, key)
        if self.active and utilities.aabb(x, y, self.transform:get()) then
            self.state = self.state == "checked" and "unchecked" or "checked"
            if self.check then
                self.check.enabled = self.state == "checked"
            end
            local result = self:cbChanged()
            return result ~= nil and result or true
        end
    end
    return false
end

return checkbox