---@param setting TrainInfo.Setting
---@param modem Modem
return function(setting, modem)
  repeat
    os.pullEvent("redstone")
    for _, side in ipairs(redstone.getSides()) do
      local isOn = redstone.getInput(side);
      if (isOn) then
        modem.transmit(setting.port, 0, {
          name = "detector",
          areaId = setting.areaId,
          railId = setting.railId
        })
      end
    end
  until false
end
