local pretty = require("cc.pretty")
---@type string[][]
local lineMap = {
  {
    "1",
    "1>2 1",
    "1>2 2",
    "2",
  },
  {
    "2",
    "2>1 1",
    "2>1 2",
    "1",
  },
}
---@type {from:string[],to:string[]}
local trainMoveable = {
  from = {},
  to = {}
};
---@type string[]
local stations = {}
---@type TrainInfo.TrainInfo[]
local trainInfo = {}
---@type TrainInfo.AreaElapseTime[]
local elapses = {}
---@param from string
---@param to string
---@param beforetime any
local function calculationAvarageTime(from, to, beforetime)
  local time = os.epoch("utc") - beforetime;
  for index, elapse in ipairs(elapses) do
    if elapse.from ~= from then
    elseif elapse.to ~= to then
    else
      local total = elapse.avarage * elapse.count;
      elapse.count = elapse.count + 1;
      elapse.avarage = (total + time) / elapse.count
      return;
    end
  end
  elapses[#elapses + 1] = {
    from = from,
    to = to,
    count = 1,
    avarage = time
  }
end
---@param name string
---@param pos string
local function changeTrainInfo(name, pos)
  ---@type TrainInfo.TrainInfo?
  local before = nil;
  for index, value in ipairs(trainInfo) do
    if (value.name == name) then
      before = value;
      table.remove(trainInfo, index)
      break;
    end
  end
  trainInfo[#trainInfo + 1] = {
    name = name,
    pos = pos,
    time = os.epoch("utc"),
  }
  if before then
    calculationAvarageTime(before.pos, pos, before.time)
  end
end

local function includes(arr, item)
  for index, value in ipairs(arr) do
    if (value == item) then return true end;
  end
  return false;
end
local function findIndex(arr, item)
  for index, value in ipairs(arr) do
    if (value == item) then return index end;
  end
  return false;
end

local function initTrainMap()
  for _, betweenPoints in ipairs(lineMap) do
    if (not includes(stations, betweenPoints[1])) then
      stations[#stations + 1] = betweenPoints[1]
    end
    if (not includes(stations, betweenPoints[#betweenPoints])) then
      stations[#stations + 1] = betweenPoints[#betweenPoints]
    end
    for i, point in ipairs(betweenPoints) do
      local next = betweenPoints[i + 1];
      if (next) then
        trainMoveable.from[#trainMoveable.from + 1] = point;
        trainMoveable.to[#trainMoveable.to + 1] = next;
      end
    end
  end
end


---検知した場所から列車を割り出す
---@param pos string
local function findTrain(pos)
  local from = trainMoveable.from[findIndex(trainMoveable.to, pos)];
  for index, value in ipairs(trainInfo) do
    if (value.pos == from) then
      return value;
    end
  end
  return nil;
end

---@param setting TrainInfo.Setting
---@param detector TrainInfo.DetectorMessage
local function onDetectorMessage(setting, detector)
  local train = findTrain(detector.areaId);
  if (not train) then return; end
  changeTrainInfo(train.name, detector.areaId);
end
---@param setting TrainInfo.Setting
---@param station TrainInfo.StationMessage
local function onStationMessage(setting, station)
  changeTrainInfo(station.train, station.areaId);
end
---@param setting TrainInfo.Setting
---@param api TrainInfo.APIMessage
local function onApiMessage(setting, api)
  if api.request == "trains" then
    return trainInfo;
  elseif api.request == "train" then
    for index, train in ipairs(trainInfo) do
      if (train == api.param.name) then
        return train
      end
    end
    return nil
  elseif api.request == "map" then
    return lineMap;
  elseif api.request == "moveable" then
    return trainMoveable;
  elseif api.request == "stations" then
    return stations;
  elseif api.request == "elapses" then
    return elapses;
  end
end

---@param setting TrainInfo.Setting
---@param modem Modem
return function(setting, modem)
  initTrainMap()
  local function loop()

  end

  local function receiveTransmit()
    repeat
      ---@type nil,nil,nil,integer,table
      local _, _, _, repChannel, message = os.pullEvent("modem_message");
      if (message.railId ~= setting.railId) then
      elseif (message.name == "detector") then
        onDetectorMessage(setting, message)
      elseif (message.name == "station") then
        onStationMessage(setting, message)
      elseif (message.name == "api") then
        modem.transmit(repChannel, 0, {
          unique = message.unique,
          data = onApiMessage(setting, message)
        })
      end
    until false
  end
  modem.open(setting.port);
  parallel.waitForAll(loop, receiveTransmit)
end
