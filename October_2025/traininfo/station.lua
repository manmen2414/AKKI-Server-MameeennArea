---@type TrainStation
local trainStation = peripheral.find("Create_Station") or error("no station");
local function stationSetting()
  local function init()
    term.clear();
    term.setCursorPos(1, 1);
    term.setBackgroundColor(colors.brown)
    term.setTextColor(colors.white)
    term.clearLine();
    term.setCursorPos(1, 2);
    term.clearLine();
    print(" " .. trainStation.getStationName())
    if trainStation.isTrainPresent() then
      term.clearLine();
      print(" Train: \"" .. trainStation.getTrainName() .. "\"")
    end
    term.clearLine();
    term.setBackgroundColor(colors.black);
    term.setTextColor(colors.white)
    term.setCursorPos(1, 5);
    print("Press N: change station name")
    print("Press C: assemble train / change name")
    print("Press E: shutdown")
  end
  init()
  repeat
    local event, key, is_held = os.pullEvent("key")
    for i = 5, ({ term.getSize() })[2], 1 do
      term.setCursorPos(1, i);
      term.clearLine()
    end
    term.setCursorPos(1, 5);
    if is_held then
    elseif key == keys.n then
      sleep(0.05)
      print("Enter new name:")
      ---@type string
      local text = read();
      if #text > 0 then
        trainStation.setStationName(text);
      end
    elseif key == keys.c then
      pcall(trainStation.setAssemblyMode, true);
      repeat
        print("Enter train name and assemble:")
        ---@type string
        local text = read();
        if #text > 0 then
          local sucessed = pcall(trainStation.assemble);
          if (sucessed) then
            trainStation.setTrainName(text);
            break;
          end
          print("Assemble Falied...")
        end
      until false
    elseif key == keys.e then
      os.shutdown();
    end
    init()
  until false
end
---@param setting TrainInfo.Setting
---@param modem Modem
return function(setting, modem)
  local function main()
    local trainPresented = false;
    repeat
      local isPresent = trainStation.isTrainPresent();
      if (trainPresented ~= isPresent) then
        trainPresented = isPresent
        if isPresent then
          modem.transmit(setting.port, 0, {
            name = "station",
            areaId = setting.areaId,
            railId = setting.railId,
            platform = setting.platform,
            train = trainStation.getTrainName()
          })
        end
      end
      sleep(0.05)
    until false
  end
  parallel.waitForAny(main, stationSetting)
end
