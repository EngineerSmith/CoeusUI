local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local text = setmetatable({}, ui)
text.__index = text

text.new = function(...)
    local self = setmetatable(ui.new(...), text)
    self.color = {1,1,1,1}
    self.string = ""
    self.font = love.graphics.getFont()
    self.wrap = false
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

text.setString = function(self, string)
    if type(string) ~= "string" then error("Text: 2nd argument only supports string types") end
    self.string = string or ""
    return self
end

text.setFont = function(self, font)
    self.font = font or error("Text: 2nd argument required")
    return self
end

text.setWrap = function(self, wrap)
    self.wrap = wrap
    return self
end

text.drawElement = function(self)
    local x, y, w, h = self.transform:get()
    if self.wrap then
        local width, wrappedText = self.font:getWrap(self.string, w)
        love.graphics.setColor(self.color)
        local height = self.font:getHeight()
        for i, text in ipairs(wrappedText) do
            love.graphics.print(text, self.font, x, y + height * (i-1))
        end
    else
        local sw = w /self.font:getWidth(self.string)
        local sh = h / self.font:getHeight()
        local s = sw < sh and sw or sh
        
        love.graphics.setColor(self.color)
        love.graphics.print(self.string, self.font, x, y, 0, s)
    end
end

return text
