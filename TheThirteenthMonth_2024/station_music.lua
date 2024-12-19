local music = require("music")
local station = peripheral.find("Create_Station")
repeat
    if station.isTrainPresent() then
        music("music_saisei.json"):play({ peripheral.find("speaker") });
        repeat
            sleep(0.5);
        until not station.isTrainPresent()
    else
        sleep(0.5);
    end
until false
