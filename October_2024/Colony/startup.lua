local Colony = peripheral.find("colonyIntegrator") or error("Colony Integrator is not connected")
---@type Modem|nil
local Modem = peripheral.find("modem") or nil;
---@type ChatBox|nil
local ChatBox = peripheral.find("chatBox") or nil;
local storages = { peripheral.find("inventory") };

local function WriteWithColor(text, color)
    local bcolor = term.getTextColor();
    term.setTextColor(color);
    term.write(text);
    term.setTextColor(bcolor);
end

local function Logger(name, color)
    color = color or colors.white
    local logger = { color = color, name = name };
    function logger:print(message)
        WriteWithColor(os.date("%H:%M:%S "), colors.white)
        WriteWithColor(self.name .. " ", self.color)
        print(message)
    end

    return logger;
end

local tasks = fs.list("./tasks")
for index, value in ipairs(tasks) do
    local roop = require("tasks." .. value:match("[^\\.]+")).roop
    local load = require("tasks." .. value:match("[^\\.]+")).load
    tasks[index] = function()
        load({ Colony = Colony, Modem = Modem, ChatBox = ChatBox, storages = storages, Logger = Logger })
        repeat
            local _, e = pcall(roop,
                { Colony = Colony, Modem = Modem, ChatBox = ChatBox, storages = storages, Logger = Logger })
            if e == "Terminated" then
                return;
            elseif e ~= nil then
                print("ERR: " .. e)
            end
        until false
    end
end

parallel.waitForAny(table.unpack(tasks))
