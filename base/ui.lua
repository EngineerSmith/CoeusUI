local ui = {}
ui.__index = ui

ui.new = function(anchor)
    local self = setmetatable({
        children = {count=0},
        parent   = nil,
    }, ui)
    return self
end

return ui