print("MameeennArea System")
local port = 1;

--#region Peripherals
---@type Modem
local modem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)
if not modem then error("Wireless modem not connected") end
--#endregion

local MMS = require("Money")();
