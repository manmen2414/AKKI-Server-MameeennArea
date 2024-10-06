local log = require("log")("Main", colors.red)
term.clear(); term.setCursorPos(1, 1);
log:print("Starting...")
local termX = term.getSize();
local fakeFunction = function() end
if not fs.exists("_config.json") then
    log:print("log not found...")
    shell.run("configuration")
    return;
end
---@type ReadStream
log:print("Config Loading...")
local readStream = fs.open("_config.json", "r")
local config = textutils.unserialiseJSON(readStream.readAll());
readStream.close();
log:print("Config Loaded: \2228" .. textutils.serialise(config))
--#region Peripherals
---@type Modem
local modem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)
if not modem then error("Wireless modem not connected") end
--#endregion
log:print("Peripheral Loaded!")
local tasks = {};
log:print("Loaded tasks: ")
for index, value in ipairs(fs.list("./tasks")) do
    local task = require("tasks." .. value:match("^[^\\.]+"));
    tasks[#tasks + 1] = function()
        task(config);
    end
    log:AddPrint("\2228+ \2223" .. value)
end
term.setTextColor(colors.yellow)
local Name = "Station Core"
local centerSpace = (" "):rep((termX - 2 - #Name) / 2);
print(("="):rep(termX))
print("|" .. centerSpace .. Name .. centerSpace .. "|")
print(("="):rep(termX))
term.setTextColor(colors.white)
log:print("activated.")
parallel.waitForAll(table.unpack(tasks))
