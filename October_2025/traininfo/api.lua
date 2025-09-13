---@param port integer
---@param railId string
---@param replyPort integer?
return function(port, railId, replyPort)
  ---@class TraininfoAPI
  local instance = {};
  instance.port = port;
  instance.railId = railId;
  instance.replyPort = replyPort or port;
  instance.timeout = 2;
  ---@param selector "trains"|"train"|"map"|"moveable"|"stations"|"elapses"
  ---@param param table
  function instance:request(selector, param)
    local unique = math.random();
    ---@type Modem
    local modem = peripheral.find("modem") or error("no modem to request Traininfo");
    modem.transmit(self.port, self.replyPort, {
      name = "api",
      railId = self.railId,
      unique = unique,
      request = selector,
      param = param,
    })
    modem.open(self.replyPort);
    local ret = nil;
    local function wait5()
      sleep(self.timeout);
      modem.close(self.replyPort);
    end
    local function getReply()
      local _, _, ch, _, message = os.pullEvent("modem_message");
      if (ch ~= self.replyPort) then
      elseif (message.unique == unique) then
        modem.close(ch);
        ret = message.data;
        return;
      end
      getReply()
    end
    parallel.waitForAny(wait5, getReply)
    return ret;
  end

  ---@return TrainInfo.TrainInfo[]
  function instance:getTrains()
    return self:request("trains", {}) or {};
  end

  ---@param trainName string
  ---@return TrainInfo.TrainInfo
  function instance:getTrain(trainName)
    return self:request("train", { name = trainName }) or {};
  end

  ---@return (string|table)[]
  function instance:getMap()
    return self:request("map", {}) or {};
  end

  ---@return {from:string[],to:string[]}
  function instance:getMoveable()
    return self:request("moveable", {}) or {};
  end

  ---@return string[]
  function instance:getStations()
    return self:request("stations", {}) or {};
  end

  ---@return TrainInfo.AreaElapseTime[]
  function instance:getElapses()
    return self:request("elapses", {}) or {};
  end

  ---@param trainName string
  function instance:getTrainGoTo(trainName)
    local moveable = self:getMoveable();
    local trains = self:getTrains();
    ---@type TrainInfo.TrainInfo?
    local train;
    for _, value in ipairs(trains) do
      if (value.name == trainName) then
        train = value;
      end
    end
    if (not train) then
      return {};
    end

    local gotoList = { train.pos };

    local function get()
      for index, value in ipairs(moveable.from) do
        if (value == gotoList[#gotoList]) then
          local at = moveable.to[index];
          if not at then
            return;
          end
          for _, gotoat in ipairs(gotoList) do
            if (gotoat == at) then return; end
          end
          gotoList[#gotoList + 1] = at;
          get()
        end
      end
    end
    get()
    return gotoList;
  end

  ---@param fromStation string
  function instance:getStationBetween(fromStation)
    for index, map in ipairs(self:getMap()) do
      if map[1] == fromStation then
        ---@type string[]
        local between = {};
        for index, value in ipairs(map) do
          if (index ~= 1 and index ~= map[#map]) then
            between[#between + 1] = value;
          end
        end
        return between;
      end
    end
    return {};
  end

  return instance;
end
