---@enum ClientRequestType
local ClientRequestType = {
    Establishing = 0,
    HeartBeat = 1,
    Infomation = 2,
    MameeennMoneySystem_Access = 3
}

---@enum ServerResponseType
local ServerResponseType = {
    Established = 0,
    Response = 1,
    PasswordWrong = 2,
    CriticalError = 3
}

---@enum ServerRequestType
local ServerRequestType = {
    NewPassword = 100,
}

---@type MameeennAreaServer
local Server;

function os.pullEvents(events)
    local parallelObject = {};
    for event, func in pairs(events) do
        parallelObject[#parallelObject+1] = function ()
            func(os.pullEventRaw(event));
        end
    end
    parallel.waitForAny(table.unpack(parallelObject));
end

---@return MServerClient
---@param from string
---@param pos [number,number,number]
local function newClient(from, pos)
    ---@class MServerClient
    local MServerClient = {}
    MServerClient.name = from;
    MServerClient.position = pos;
    MServerClient.id = MServerClient.name..os.epoch();
    MServerClient.alive = true;
    MServerClient.password = ""..math.random();
    MServerClient.leftPasswordTime = 10;
    ---@param type ServerRequestType|ServerResponseType
    ---@param content string|table
    ---@param replyMessageID string?
    function MServerClient:sendMessage(type,content,replyMessageID)
        local isReply = not not replyMessageID;
        local requestORresponse = isReply and "Response" or "Request";
        local payload = {
            [requestORresponse] = type,
            ReplyMessageID = replyMessageID,
            YourName=self.name,
            YourPosition=self.position,
            YourID=self.id,
            From="ALLCORE",
            Content=content,
            ContentLength=#content,
            MessageID=""..(os.epoch()..os.getComputerID());
        }
        Server:sendMessage(payload);
    end
    function MServerClient:sendNewPassword()
        self.password = ""..math.random()..self.password;
        if #self.password > 20 then
            self.password=self.password:sub(1,20)
        end
        self:sendMessage(ServerRequestType.NewPassword,self.password)
    end
    function MServerClient:generateParallelFunction()
        return function()
            repeat
                pcall(function()
                    repeat
                        os.startTimer(0.25)
                        os.pullEvents({
                            timer=function ()
                                self.leftPasswordTime = self.leftPasswordTime-0.25;
                                if self.leftPasswordTime <= 0 then
                                    
                                end
                            end
                        })
                    until false
                end)
            until false
        end
    end

    return MServerClient;
end

return function(port)
    ---@class MameeennAreaServer
    local MServer = {};
    Server=MServer;
    ---@type MServerClient[]
    MServer.established = {};
    ---@type integer
    MServer.port = port;
    ---@type Modem
    MServer.modem = peripheral.find("modem",function (modem)
        return modem.isWireless();
    end);

    function MServer:sendMessage(payload)
        self.modem.transmit(self.port,0,payload)
    end
end
