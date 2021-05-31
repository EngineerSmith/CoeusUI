local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local button = setmetatable({}, ui)
button.__index = button

button.new = function(...)
    local self = setmetatable(ui.new(...), button)
    
    return self
end

return button