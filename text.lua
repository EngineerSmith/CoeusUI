local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local text = setmetatable({}, ui)
text.__index = text

text.new = function(...)
    local self = setmetatable(ui.new(...), text)
    self.string = ""
    self.font = love.graphics.getFont()
    self.allignmentX = "center"
    self.allignmentY = "center"
    self.wrap = "fit"
    return self
end

text.setTheme = function(self, theme)
    self.theme = theme
    if theme and theme.factory.text then
        theme.factory.text(self)
    end
    return self
end

local allignmentsX = {
    ["left"] = 1,
    ["center"] = 1,
    ["right"] = 1,
}
local allignmentsY = {
    ["top"] = 1,
    ["center"] = 1,
    ["bottom"] = 1,
}

text.setAllignment = function(self, allignmentX, allignmentY)
    self.allignmentX = allignmentsX[allignmentX] and allignmentX or error("Text: 2nd argument not supported type\n Gave: "..tostring(allignmentX))
    self.allignmentY = allignmentsY[allignmentY] and allignmentY or error("Text: 3rd argument not supports type\n Gave: "..tostring(allignmentY))
    return self
end

text.setString = function(self, string)
    if type(string) ~= "string" then error("Text: 2nd argument only supports string types") end
    self.string = string or ""
    return self
end

text.setFont = function(self, font)
    self.font = font or error("Text: 2nd argument required")
    return self
end

local wraps = {
    ["wrap"] = 1,
    ["fit"] = 1,
    ["none"] = 1,
}

text.setWrap = function(self, wrap)
    self.wrap = wraps[wrap] and wrap or error("Text: 2nd argument not supported type\n Gave: "..tostring(wrap))
    return self
end

text.drawElement = function(self)
    local x, y, w, h = self.transform:get()
    local tw = self.font:getWidth(self.string)
    local th = self.font:getHeight()
    love.graphics.setColor(self.color)
    if self.wrap == "wrap" then
        local _, wrappedText = self.font:getWrap(self.string, w)
        if self.allignmentY == "center" then
            y = y + h/2 - (#wrappedText*th)/2
        elseif self.allignmentY == "bottom" then
            y = y + h - #wrappedText*th
        end
        
        local modx = 0
        for i, text in ipairs(wrappedText) do
            text = text:gsub('^%s*(.-)%s*$', '%1') -- Remove whitespaces left over from the wrap at start and end
            if self.allignmentX == "left" then
                modx = x
            elseif self.allignmentX == "center" then
                modx = x + (w/2) - (self.font:getWidth(text)/2)
            elseif self.allignmentX == "right" then
                modx = x + w - self.font:getWidth(text)
            else
                error("Text: caught undefined behaviour. Have you changed allignments?")
            end
            love.graphics.print(text, self.font, modx, y + th * (i-1))
        end
    elseif self.wrap == "fit" then
        local sw = w / tw
        local sh = h / th
        local s = sw < sh and sw or sh
        
        if self.allignmentX == "center" then
            x = x + w/2 - (tw*s)/2 
        elseif self.allignmentX == "right" then
            x = x + w - tw*s
        end
        
        if self.allignmentY == "center" then
            y = y + h/2 - (th*s)/2
        elseif self.allignmentY == "bottom" then
            y = y + h - th*s
        end
        
        love.graphics.print(self.string, self.font, x, y, 0, s)
    elseif self.wrap == "none" then
        if self.allignmentX == "center" then
            x = x + w/2 - tw/2
        elseif self.allignmentX == "right" then
            x = x + w - tw
        end
        
        if self.allignmentY == "center" then
            y = y + h/2 - th/2
        elseif self.allignmentY == "bottom" then
            y = y + h - th
        end
        
        love.graphics.print(self.string, self.font, x, y)
    end
end

return text
