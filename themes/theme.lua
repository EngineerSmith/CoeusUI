local theme = {
    factory = {},
    -- Colours
    primaryColor = {.8,.8,.8,1},
    secondaryColor = {.7,.7,.7,1},
    tertiaryColor = {.2,.4,.8,1},
    inactiveColor = {.4,.4,.4,1},
    fontColor = {.2,.2,.2,1},
}
theme.__index = theme

theme.factory.button = function(button)
    button:setShape("rectangle", theme.primaryColor):setOutline(true, 4, 2):setRoundCorner(7)
end

theme.factory.text = function(text)
    text:setColor(theme.fontColor)
end

return theme