if not fs.exists("_config.json") then
    shell.run("configuration")
    return;
end
local POSITION_SHIFT = {
    north = { 0, 0, -1 },
    east = { 1, 0, 0 },
    south = { 0, 0, 1 },
    west = { -1, 0, 0 }
}

--#region Peripherals
---@type Modem
local modem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)
if not modem then error("Wireless modem not connected") end
---@type PlayerDetector
local playerDetector = peripheral.find("playerDetector")
if not playerDetector then error("Player Detector not connected") end
--#endregion

---@type ReadStream
local readStream = fs.open("_config.json", "r")
local config = textutils.unserialiseJSON(readStream.readAll());
readStream.close();

local position = { gps.locate() };
local gatePosition = position;
for i, _ in ipairs(position) do
    gatePosition[i] = gatePosition[i] + POSITION_SHIFT[config.side][i]
end

local playerPassingPositionFrom = {};
local playerPassingPositionTo = {};

if config.side == "south" or config.side == "north" then
    playerPassingPositionFrom = {
        gatePosition[1] - 1,
        gatePosition[2] - 0.5,
        gatePosition[3] - 0.25,
    }
    playerPassingPositionTo = {
        gatePosition[1] + 2,
        gatePosition[2] + 1,
        gatePosition[3] + 1,
    }
else
    playerPassingPositionFrom = {
        gatePosition[1] - 0.25,
        gatePosition[2] - 0.5,
        gatePosition[3] - 1,
    }
    playerPassingPositionTo = {
        gatePosition[1] + 1,
        gatePosition[2] + 1,
        gatePosition[3] + 2,
    }
end

local function arrayToPosition(array)
    local KEYS = { "x", "y", "z" }
    local positionObject = {};
    for index, value in ipairs(array) do
        positionObject[KEYS[index]] = value;
    end
    return positionObject;
end
playerPassingPositionFrom = arrayToPosition(playerPassingPositionFrom)
playerPassingPositionTo = arrayToPosition(playerPassingPositionTo)

local function OpenGate()
    redstone.setOutput("front", true)
    turtle.dropDown();
end
local function Main()
    repeat
        local players = playerDetector.getPlayersInCoords(playerPassingPositionFrom, playerPassingPositionTo);
        if #players == 1 then
            turtle.suckUp(1);
            if turtle.getItemCount() ~= 0 then
                local item = turtle.getItemDetail();
                if item.name == "lightmanscurrency:coin_copper" then
                    local payload = {
                        position = position,
                        player = players[1],
                        go_inside = config.inside,
                        payed = "1c",
                        from = "gate"
                    }
                    modem.transmit(config.port, 0, payload)
                    OpenGate()
                    repeat
                        players = playerDetector.getPlayersInCoords(playerPassingPositionFrom, playerPassingPositionTo);
                        sleep(0.05)
                    until #players ~= 1
                    redstone.setOutput("front", false)
                else
                    turtle.drop();
                    sleep(1);
                end
            end
        else
            if redstone.getOutput("front") then
                redstone.setOutput("front", false)
            end
        end
    until false
end

repeat
    local _, reason = pcall(Main);
    if reason == "Terminated" then
        return;
    end
until false
