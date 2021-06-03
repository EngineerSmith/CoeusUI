local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local image = setmetatable({}, ui)
image.__index = image

image.new = function(...)
    local self = setmetatable(ui.new(...), image)
    self.allignmentX = "center"
    self.allignmentY = "center"
    self.wrap = "fit"
    return self
end

image.setImage = function(self, image, quad)
    self.image = image
    self.quad = quad
    return self
end

image.setQuad = function(self, quad)
    self.quad = quad
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

image.setAllignment = function(self, allignmentX, allignmentY)
    self.allignmentX = allignmentsX[allignmentX] and allignmentX or error("Image: 2nd argument not supported type\n Gave: "..tostring(allignmentX))
    self.allignmentY = allignmentsY[allignmentY] and allignmentY or error("Image: 3rd argument not supports type\n Gave: "..tostring(allignmentY))
    return self
end

local wraps = {
    ["wrap"] = 1,
    ["fit"] = 1,
    ["none"] = 1,
}

image.setWrap = function(self, wrap)
    self.wrap = wraps[wrap] and wrap or error("Image: 2nd argument not supported type\n Gave: "..tostring(wrap))
    return self
end

image.drawElement = function(self)
    if self.image then
        love.graphics.setColor(self.color)
        
        local x, y, w, h = self.transform:get()
        local iw, ih, _ = self.image:getDimensions()
        if self.quad then
            _, _, iw, ih = self.quad:getViewport()
        end
        
        if self.wrap == "wrap" then
            local sx = w / iw
            local sy = h / ih
            
            if self.quad then
                love.graphics.draw(self.image, self.quad, x, y, 0, sx, sy)
            else
                love.graphics.draw(self.image, x, y, 0, sx, sy)
            end
        elseif self.wrap == "fit" then
            local s = (w < h and w or h) / (iw < ih and iw or ih)
            
            if self.allignmentX == "center" then
                x = x + w/2 - (iw*s)/2
            elseif self.allignmentX == "right" then
                x = x + w - iw*s
            end
            
            if self.allignmentY == "center" then
                y = y + h/2 - (ih*s)/2
            elseif self.allignmentY == "bottom" then
                y = y + h - ih*s
            end
            
            if self.quad then
                love.graphics.draw(self.image, self.quad, x, y, 0, s)
            else
                love.graphics.draw(self.image, x, y, 0, s)
            end
        elseif self.wrap == "none" then 
            if self.allignmentX == "center" then
                x = x + w/2 - iw/2
            elseif self.allignmentX == "right" then
                x = x + w - iw
            end
            
            if self.allignmentY == "center" then
                y = y + h/2 - ih/2
            elseif self.allignmentY == "bottom" then
                y = y + h - ih
            end
            
            if self.quad then
                love.graphics.draw(self.image, self.quad, x, y)
            else
                love.graphics.draw(self.image, x, y)
            end
        end
    end
end

return image