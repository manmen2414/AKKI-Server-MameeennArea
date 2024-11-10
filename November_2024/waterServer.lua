local GUI = require("gui");
local Vector2 = GUI.Potion.newVector2;
local AIR = " ";

term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
GUI.Potion.termSize():clear()

---@return string
---@param text string
local function getCenter(text)
    local tLeng = #text;
    local x = term.getSize();
    local replCount = math.floor((x - tLeng) / 2);
    return string.rep(AIR, replCount) .. text .. string.rep(AIR, replCount);
end

GUI.GUI.Text(Vector2(1, 3), getCenter("MameeennArea - Drink Server"), colors.red)

GUI.GUI.Text(Vector2(3, 6), "Builder's Tea")
GUI.GUI.Text(Vector2(30, 6), "\165  0")

---@alias drinkid
---| 1 Builder's Tea

---@param id drinkid
local function buy(id)
    local side = {
        "bottom"
    }
    redstone.setOutput(side[id], true)
    sleep(0.1);
    redstone.setOutput(side[id], false)
end

local Buttons = {
    GUI.GUI.Button(Vector2(36, 6):to(47, 6), "    Buy    ", colors.yellow, nil, function() buy(1) end),
}

repeat
    GUI.GUI.WaitForAllButtonOrInput(table.unpack(Buttons));
until false
