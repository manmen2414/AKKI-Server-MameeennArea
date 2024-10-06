local log = require("log")("Gate")

--#region Peripherals
---@type Modem
local modem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)
if not modem then error("Wireless modem not connected") end
---@type ChatBox
local chatBox = peripheral.find("chatBox")
if not chatBox then error("ChatBox not connected") end
--#endregion
return function(config)
    log:print("activated.")
    modem.open(config.port)
    repeat
        ---@type ["modem_message",string,number,number,table,number]
        local message = { os.pullEvent("modem_message") };
        if message[5].from == "gate" then
            ---@type {position:number[],player:string,go_inside:boolean,payed:string}
            local payload = message[5];
            log:print("Pay report:" .. payload.player .. ": " .. payload.payed)
            chatBox.sendMessageToPlayer("Payed in " .. config.stationName .. ", amount: " .. payload.payed .. "",
                payload.player, "&3Station&r");
        end
    until false
end
