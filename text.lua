local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local text = setmetatable({}, ui)
text.__index = text

text.new = function(...)
    local self = setmetatable(ui.new(...), text)
    self.color = {1,1,1,1}
    self.string = ""
    self.font = love.graphics.getFont()
    self.wrap = "fit"
    self.allignmentX = "center"
    self.allignmentY = "center"
    return self
end

text.setTheme = function(self, theme)
    self.theme = theme
    if theme and theme.factory.text then
        theme.factory.text(self)
    end
    return self
end

text.setColor = function(self, r, g, b, a)
    if type(r) == "table" then
        self.color = r
    else
        self.color[1] = r or self.color[1] or 1
        self.color[2] = g or self.color[2] or 1
        self.color[3] = b or self.color[3] or 1
        self.color[4] = a or self.color[4] or 1
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
    local th = self.font:getHeight()
    if self.wrap == "wrap" then
        local width, wrappedText = self.font:getWrap(self.string, w)
        love.graphics.setColor(self.color)
        for i, text in ipairs(wrappedText) do
            love.graphics.print(text, self.font, x, y + th * (i-1))
        end
    elseif self.wrap == "fit" then
        local tw = self.font:getWidth(self.string)
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
        
        love.graphics.setColor(self.color)
        love.graphics.print(self.string, self.font, x, y, 0, s)
    end
end

return text
