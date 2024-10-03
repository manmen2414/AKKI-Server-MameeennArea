local log = require("log")("Main", colors.red)
term.clear(); term.setCursorPos(1, 1);
local termX = term.getSize();
local fakeFunction = function() end
log:print("Loading...")
--#region Peripherals
---@type Modem
local modem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)
if not modem then error("Wireless modem not connected") end
--#endregion
log:print("Peripheral Loaded!")
local tasks = {};
log:print("Loaded tasks: ")
for index, value in ipairs(fs.list("./tasks")) do
    tasks[#tasks + 1] = require("tasks." .. value:match("^[^\\.]+"))
    log:AddPrint("+ " .. value)
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
