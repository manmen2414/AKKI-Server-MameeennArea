return {
    ---@class Modem
    modem = {
        ---@param channel integer
        open = function(channel) return end,
        ---@param channel integer
        isOpen = function(channel) return false end,
        ---@param channel integer
        close = function(channel) return end,
        closeAll = function() return end,
        ---@param channel integer
        ---@param replyChannel integer
        ---@param payload integer
        transmit = function(channel, replyChannel, payload) return end,
        iswireless = function() return false end,
        ---@return ...
        getNamesRemote = function() return "" end,
        ---@param name string
        isPresentRemote = function(name) return false end,
        ---@return string|nil
        ---@param name string
        getTypeRemote = function(name) return "" end,
        ---@param name string
        ---@param type string
        hasTypeRemote = function(name, type) return false end,
        ---@param name string
        ---@return ...
        getMethodsRemote = function(name) return "" end,
        ---@param remotename string
        ---@param method string
        ---@param ... string
        callRemote = function(remotename, method, ...) return "" end,
        ---@return string|nil
        getNameLocal = function() return "" end,
    }
}
