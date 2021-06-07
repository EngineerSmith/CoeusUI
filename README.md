# CoeusUI
Love2D Lua UI library that supports anchoring.

## Where Coeus coems from
Coeus comes from the Greek Titan of intelligence, and the embodiment of the celestial axis at which the heavens revolve. this is perfect for my UI library that I wanted to anchor and resize itself actively. 

# Example Usage

```lua
local coeus = require("coeus")

local x, y, w, h = love.window.getSafeArea()
local window = coeus.window(w, h) -- Window is the canvas for all ui elements, a window can be a child to another window


local shape = coeus.shape(.5,.5, 1,1)
shape:setShape("ellipse", "fill")
window:addChild(shape)


local image = coeus.image(.5,0, 1,.5)
image:setImage(love.graphics.newImage("duck.png")):setWrap("wrap")
window:addChild(image)


local button = coeus.button(.35,.23,.65,.47)
button:setTheme(coeus.theme.default)
button:setText("Press Me"):setFont(love.graphics.newFont(70)):setTextAllignment("right", "center"):setTextWrap("wrap")
window:addChild(button)

button:setCBPressed(function()
    shape:setColor(1,0,0) -- Shape from first element
    return true
end)

button:setCBReleased(function()
    shape:setColor(1,1,1)
    return true
end)


local text = coeus.text(0,0,1,1)
text:setTheme(coeus.theme.default)
text:setString("Hello World! Coeus comes from the Greek Titan of intelligence, and the embodiment of the celestial axis around which the heavens revolve. Which is perfect for a UI library that I wanted to anchor and resize itself.")
text:setWrap("wrap")
shape:addChild(text)


local progress = coeus.progressBar(.05,.85,.45,.9)
progress:setShape("rectangle"):setOutline(4, 2):setProgress(0):setDirection("top")

local dir, index = {"top", "right", "bottom", "left"}, 1
progress.updateElement = function(self, dt)
    local p = self.progress + dt
    if p > 1 then 
        index = index + 1
        if index > #dir then index = 1 end
        self:setDirection(dir[index])
        p = 0
    end
    self:setProgress(p)
end

window:addChild(progress)


-- Calls for love

love.update = function(dt)
    window:update(dt) 
end

love.graphics.setBackgroundColor(.8,0,.8)
love.draw = function()
    window:draw()
end

love.resize = function(...)
    window:resize(...) -- Window default grabs love.window.getSafeArea, but can be optionally turned off to use given values
end

-- Only two input events supported right now due to focus towards mobile
love.touchpressed = function(...)
    window:touchpressed(...) -- Input events return true when handled
end

love.touchreleased = function(...)
    window:touchreleased(...)
end
```