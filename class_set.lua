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
        ---@param payload number|integer|string|boolean|table
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
    },
    ---@class PlayerDetector
    playerDetector = {
        ---@param username string
        ---@return {dimension: string,eyeHeight: number,pitch: number,health: number,maxHealth: number,airSupply: number,respawnPosition: number,respawnDimension: number,respawnAngle: number,yaw: number,x: number,y: number,z: number}
        getPlayerPos = function(username)
            return {};
        end,
        getOnlinePlayers = function() return {} end,
        ---@param range number
        ---@return string[]
        getPlayersInRange = function(range) return {} end,
        ---@param posOne {x:number,y:number,z:number}
        ---@param posTwo {x:number,y:number,z:number}
        ---@return string[]
        getPlayersInCoords = function(posOne, posTwo) return {} end,
        ---@return boolean
        ---@param w number
        ---@param h number
        ---@param d number
        getPlayersInCubic = function(w, h, d) return false end,
        ---@param range number
        ---@param username string
        ---@return boolean
        isPlayerInRange = function(range, username) return false end,
        ---@param posOne {x:number,y:number,z:number}
        ---@param posTwo {x:number,y:number,z:number}
        ---@param username string
        ---@return boolean
        isPlayerInCoords = function(posOne, posTwo, username) return false end,
        ---@return boolean
        ---@param w number
        ---@param h number
        ---@param d number
        isPlayerInCubic = function(w, h, d) return false end,
        ---@param range number
        ---@return boolean
        isPlayersInRange = function(range, username) return false end,
        ---@param posOne {x:number,y:number,z:number}
        ---@param posTwo {x:number,y:number,z:number}
        ---@return boolean
        isPlayersInCoords = function(posOne, posTwo, username) return false end,
        ---@return boolean
        ---@param w number
        ---@param h number
        ---@param d number
        isPlayersInCubic = function(w, h, d) return false end,
    },
    ---@class ChatBox
    chatBox = {
        ---@return true|nil,string?
        ---@param message string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendMessage = function(message, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param message string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendMessageToPlayer = function(message, username, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param json string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendFormattedMessage = function(json, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param json string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendFormattedMessageToPlayer = function(json, username, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param message string
        ---@param title string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendToastToPlayer = function(message, title, username, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param json string
        ---@param title string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendFormattedToastToPlayer = function(json, title, username, prefix, brackets, bracketColor, range) end,
    },
    ---@class ReadStream
    readStream = {
        close = function() end,
        read = function() return "" end,
        readAll = function() return "" end,
        readLine = function() return "" end,
        seek = function() return -1 end
    },
    ---@class WriteStream
    writeStream = {
        close = function() end,
        ---@param str string
        write = function(str) end,
        seek = function() return -1 end,
        flush = function() end,
        ---@param line string
        writeLine = function(line) end,
    },
    ---@class Inventory
    inventory = {
        size          = function() return -1 end,
        ---@return {name:string,count:number}[]
        list          = function() return {} end,
        ---@param slot number
        getItemDetail = function(slot) return {} end,
        ---@param slot number
        getItemLimit  = function(slot) return -1 end,
        ---@param toName string
        ---@param fromSlot number
        ---@param limit number
        ---@param toSlot string
        ---@return integer
        pushItems     = function(toName, fromSlot, limit, toSlot) return -1 end,
        ---@param fromName string
        ---@param fromSlot number
        ---@param limit number
        ---@param toSlot string
        ---@return integer
        pullItems     = function(fromName, fromSlot, limit, toSlot) return -1 end,
    },
    ---@class TrainStation Create_Station
    trainStation = {
        assemble = function() end,
        disassemble = function() end,
        ---@param assemblyMode boolean
        setAssemblyMode = function(assemblyMode) end,
        isInAssemblyMode = function() return false end,
        getStationName = function() return "" end,
        ---@param name string
        setStationName = function(name) end,
        isTrainPresent = function() return false end,
        isTrainImminent = function() return false end,
        isTrainEnroute = function() return false end,
        getTrainName = function() return "" end,
        ---@param name string
        setTrainName = function(name) end,
        hasSchedule = function() return false end,
        getSchedule = function() return {} end,
        ---@param schedule string
        setSchedule = function(schedule) return {} end,
    }
}
