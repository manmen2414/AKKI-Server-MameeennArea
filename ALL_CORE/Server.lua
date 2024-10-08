---@enum ClientRequestType
local ClientRequestType = {
    Establishing = 0,
    HeartBeat = 1,
    Infomation = 2,
    MameeennMoneySystem_Access = 3
}

---@enum ServerResponseType
local ServerRequestType = {
    Established = 0,
    Response = 1,
    PasswordWrong = 2,
    CriticalError = 3
}

---@enum ServerRequestType
local ServerRequestType = {
    NewPassword = 0,
}

---@return MServerClient
---@param from string
---@param pos [number,number,number]
local function newClient(from, pos)
    ---@class MServerClient
    local MServerClient = {}
    MServerClient.name = from;
    MServerClient.position = pos;
    MServerClient.alive = true;
    return MServerClient;
end

return function(port)
    ---@class MameeennAreaServer
    local MServer = {};
    MServer.established = 0;
    MServer.port = port;
end
