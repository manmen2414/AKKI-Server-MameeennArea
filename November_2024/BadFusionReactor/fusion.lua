local rla = peripheral.find("fusionReactorLogicAdapter")
local webhook = require("WebhookDiscord");
local url = require("url")
local result = 0
local function waitUntilChangeReactivity()
    local prevEff = 0
    repeat
        prevEff = rla.getEfficiency()
        sleep(0.05)
    until prevEff == rla.getEfficiency()
end
local function observeEfficiency()
    local effinciencyHistory = {}
    local prevEff = 0
    local maxEff = 0
    local maxEffIndex = 1
    local i = 0
    repeat
        i = i + 1
        prevEff = rla.getEfficiency()
        if prevEff > maxEff then
            maxEff = prevEff
            maxEffIndex = i
        end
        sleep(0.05)
    until prevEff == rla.getEfficiency()
    if maxEffIndex == i then
        result = 2
        return 2
    elseif maxEffIndex == 1 then
        result = 0
        return 0
    elseif maxEffIndex > (i / 2) then
        result = 1
        return 1
    else
        result = -1
        return -1
    end
end
local function tweakEfficiency()
    local minRange = 0
    local range = 100
    local maxRange = 100
    local minDetectRange = 25
    local detectRange = 50
    local maxDetectRange = 75
    parallel.waitForAll(function() rla.adjustReactivity(1) end, observeEfficiency)
    local EF = rla.getEfficiency()
    local difference = 100 * ((1 / (EF + 10) * 22) - 0.2)
    if difference > 100 then
        difference = 100;
    elseif difference < -100 then
        difference = -100;
    end
    if result == 2 then
        rla.adjustReactivity(difference)
    else
        rla.adjustReactivity(-difference)
    end
    waitUntilChangeReactivity()
end
rla.adjustReactivity(-100)
sleep(5)
local sended = false;
while sended do
    local currentEff = rla.getEfficiency()
    if currentEff <= 90 then
        print("TR change was detected.\ntweak Efficiency.")
        tweakEfficiency()
        print("done!!")
    end
    if currentEff == 0 then
        webhook(url, "<@778582802504351745> Fussion Reactor Stoped", "MameeennArea")
        sended = true;
    end
    sleep(1)
end
