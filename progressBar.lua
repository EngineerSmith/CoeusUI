local path = (...):match("(.-)[^%.]+$")
local ui = require(path.."base.ui")

local progressBar = setmetatable({}, ui)
progressBar.__index = progressBar

progressBar.new = function(...)
    local self = setmetatable(ui.new(...), progressBar)
    return self
end

return progressBar