local music = require("music")
local station = peripheral.find("Create_Station")
repeat
    if station.isTrainPresent() then
        redstone.setOutput("back", true);
        music("music_saisei.json"):play({ peripheral.find("speaker") });
        redstone.setOutput("back", false);
        repeat
            sleep(0.5);
        until not station.isTrainPresent()
        redstone.setOutput("back", true);
    else
        sleep(0.5);
        redstone.setOutput("back", false);
    end
until false
