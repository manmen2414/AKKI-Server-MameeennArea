--#region 型推測時に特定の型にさせる関数たち
local function _string()
  return string.char(0)
end
local function _integer()
  return math.floor(0)
end
local function _number()
  return math.random()
end
local function _boolean()
  return _number() == 0;
end
local function _table()
  return table.pack()
end
local function _stringNil()
  if _boolean() then return _string() end;
  return nil;
end
local function _integerNil()
  if _boolean() then return _integer() end;
  return nil;
end
local function _numberNil()
  if _boolean() then return _number() end;
  return nil;
end
--#endregion
return {
  ---@class TrainInfo.Setting
  setting = {
    areaId = _string(),
    platform = _integerNil(),
    port = _number(),
    railId = _string()
  },
  ---@class TrainInfo.DetectorMessage
  dt = {
    name = "detector",
    areaId = _string(),
    railId = _string(),
  },
  ---@class TrainInfo.StationMessage
  st = {
    name = "station",
    areaId = _string(),
    railId = _string(),
    platform = _integer(),
    train = _string()
  },
  ---@class TrainInfo.APIMessage
  apit = {
    name = "api",
    ---@type any 推奨:string or number
    unique = _stringNil(),
    ---@type "trains"|"train"|"map"|"moveable"|"stations"|"elapses"
    request = _string(),
    param = _table()
  },
  ---@class TrainInfo.TrainInfo
  trainInfo = {
    name = _string(),
    pos = _string(),
    time = _number(),
  },
  ---@class TrainInfo.AreaElapseTime
  elapseTime = {
    count = _integer(),
    avarage = _number(),
    from = _string(),
    to = _string()
  }
}
