local GUIFile = require("gui")
local GUI = GUIFile.GUI;
local Potion = GUIFile.Potion;
local termX = term.getSize();
local function getCenter(char) return (termX - char) / 2; end
local config = {
    stationName = "",
    --ぶっちゃけ何でもいい
    port = 64345
}

local function setConfig()
    ---@type WriteStream
    local stream = fs.open("_config.json", "w")
    stream.write(textutils.serialiseJSON(config));
    stream.close();
end
if fs.exists("_config.json") then
    ---@type ReadStream
    local stream = fs.open("_config.json", "r")
    config = textutils.unserialiseJSON(stream.readAll());
    stream.close();
else
    setConfig()
end

term.setPaletteColor(colors.brown, 0x2b2c42)
term.setBackgroundColor(colors.brown)
Potion.termSize():clear()
GUI.Text(Potion.newVector2(getCenter(15), 1), "Station  Config")
GUI.Text(Potion.newVector2(1, 3), "Station Name")
GUI.Text(Potion.newVector2(1, 5), "Port(default:64345)")
GUI.Text(Potion.newVector2(1, 7), "Port(default:64345)")
local exitCenterPos = (" "):rep(getCenter(4) + 1);
local Buttons = {
    GUI.Input(Potion.newSize(15, 3, 40, 3), config.stationName, colors.gray, colors.white, false, nil,
        function(value)
            config.stationName = value;
            setConfig();
        end),
    GUI.Input(Potion.newSize(22, 5, 27, 5), tostring(config.port), colors.gray, colors.white, false, nil,
        function(value)
            if tonumber(value) then
                config.port = tonumber(value);
                setConfig();
            end
        end),
    GUI.Button(Potion.newSize(1, 19, 51, 19), exitCenterPos .. "Exit" .. exitCenterPos, colors.green, colors.white,
        function()
            term.setBackgroundColor(colors.black);
            Potion.termSize():clear();
            term.setCursorPos(1, 1);
            return "exit";
        end)
}

GUI.WaitForAllButtonOrInput(table.unpack(Buttons))
