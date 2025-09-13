local apiClass = require("api");
local pretty = require("cc.pretty");
local api = apiClass(24140, "test");
local name = "Unnamed2";

local function includes(arr, item)
  for index, value in ipairs(arr) do
    if (value == item) then return true end;
  end
  return false;
end

local time = 0;
local start = "";
local elapses = api:getElapses();
---@param from string
local function getTimeFrom(from)
  for index, value in ipairs(elapses) do
    if value.from == from then
      return math.floor(value.avarage / 1000 + 0.5)
    end
  end
  return 0;
end
local lastTime = os.epoch("utc");
local function getTime()
  local nowtime = os.epoch("utc");
  local elapsed = nowtime - lastTime;
  lastTime = nowtime;
  return elapsed / 1000;
end
local function check()
  term.clear();
  term.setCursorPos(1, 1);
  print(name)
  local stations = api:getStations()
  local golist = api:getTrainGoTo(name)
  local needTimeReload = start ~= golist[1];
  elapses = api:getElapses();
  if needTimeReload then
    time = 0;
    for index, go in ipairs(golist) do
      if (includes(stations, go)) then
        if index ~= 1 then
          break;
        end
      end
      time = time + getTimeFrom(go);
    end
  end
  for index, go in ipairs(golist) do
    if index == 1 then
      term.setTextColor(colors.green)
      print("> " .. go)
    else
      term.setTextColor(colors.white)
      print("  " .. go)
    end
  end

  start = golist[1];
  if not needTimeReload then
    time = time - getTime();
  else
    getTime()
  end
  print(math.floor(time));
end
repeat
  check();
  sleep(0.2);
until false
