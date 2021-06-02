local path = (...):match("(.-)[^%.]+$")

local coeus = {
    ui = require(path.."base.ui"),
    window = require(path.."base.window"),
    -- Themes
    theme = {
        default = require(path.."themes.theme"),
        light = require(path.."themes.light"),
        dark = require(path.."themes.dark"),
    },
    -- Base Elements
    shape = require(path.."shape"),
    text = require(path.."text"),
    -- Complex Elements
    button = require(path.."button"),
}

return coeus