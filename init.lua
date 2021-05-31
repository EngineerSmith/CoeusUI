local path = (...):match("(.-)[^%.]+$")

local coeus = {
    ui = require(path.."base.ui"),
    window = require(path.."base.window"),
    
    shape = require(path.."shape"),
}

return coeus