local path = (...):match("(.-)[^%.]+$")
local _require = require
local require = function(filePath)
    return _require(path .. filePath)
end

local coeus = {
    ui = require("base.ui"),
    window = require("base.window"),
    -- Themes
    theme = {
        default = require("themes.theme"),
        light = require("themes.light"),
        dark = require("themes.dark"),
    },
    -- Base Elements
    shape = require("shape"),
    text = require("text"),
    image = require("image"),
    -- Complex Elements
    button = require("button"),
    progressBar = require("progressBar"),
    checkbox = require("checkbox"),
}

return coeus