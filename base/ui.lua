local path = (...):match("(.-)[^%.]+$") 

local ui = {}
ui.__index = ui

local transform = require(path.."transform")

ui.new = function(...)
    local self = setmetatable({
        transform = transform(...),
        children  = {count=0},
        parent    = nil,
    }, ui)
    return self
end

return ui