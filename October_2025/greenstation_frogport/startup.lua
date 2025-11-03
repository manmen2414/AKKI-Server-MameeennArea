---@type Inventory[]
local postboxs = { peripheral.find("create:package_postbox") };
---@type Inventory[]
local frogports = { peripheral.find("create:package_frogport") };
local sendingMode = {};
local TASKTYPES = { "SEND", "RECV" }

local defaultPostbox = peripheral.getName(postboxs[1])
local defaultFrogport = peripheral.getName(frogports[1])
if #postboxs == 0 then error("postboxs not connected"); end

local function writeLog(content, color)
  term.setTextColor(color)
  print(content)
  term.setTextColor(colors.white)
end
local function writeStart()
  term.clear();
  term.setCursorPos(1, 1);
  writeLog("Station Postbox System", colors.red);
end
---@generic T1
---@generic T2
---@param b boolean
---@param t T1
---@param f T2
---@return T1|T2
local function s(b, t, f)
  if b then
    return t;
  end
  return f;
end

---taskTypeから並列実行用のタスクを生成する
---@param taskType "SEND"|"RECV"
local function genTask(taskType)
  local isRecv = taskType == "RECV";
  local unProcessableTaskType = s(isRecv, "SEND", "RECV");
  local fromPeripheralList = s(isRecv, postboxs, frogports);
  local toPeripheralName = s(isRecv, defaultFrogport, defaultPostbox);
  return function()
    repeat
      local noItem = true;
      for fIndex, from in ipairs(fromPeripheralList) do
        local fromList = from.list();
        if #fromList ~= 0 then
          noItem = false;
          for index, item in ipairs(fromList) do
            if sendingMode[item.nbt] ~= unProcessableTaskType then
              local sucessed = from.pushItems(
                toPeripheralName, index)
              if sucessed > 0 then
                sendingMode[item.nbt] = taskType;
                writeLog("[" .. taskType .. "/" .. fIndex .. "] " .. item.nbt, colors.yellow)
              else
                writeLog("[" .. taskType .. "/" .. fIndex .. "] FAILED", colors.red)
              end
            end
          end
        end
      end
      if noItem then
        for nbt, task in pairs(sendingMode) do
          if task == unProcessableTaskType then
            sendingMode[nbt] = nil;
          end
        end
      end
    until false
  end
end
--[[local function sendTask()
  repeat
    for frogIndex, frogport in ipairs(frogports) do
      local frogList = frogport.list();
      if #frogList ~= 0 then
        for index, item in ipairs(frogList) do
          if sendingMode[item.nbt] ~= 2 then
            local sucessed = frogport.pushItems(
              defaultPostbox, index)
            if sucessed > 0 then
              sendingMode[item.nbt] = 1;
              writeLog("[F" .. frogIndex .. ">P1] " .. item.nbt, colors.yellow)
            end
          end
        end
      end
    end
  until false
end
local function receiveTask()
  repeat
    for postIndex, postbox in ipairs(postboxs) do
      local postList = postbox.list();
      if #postList ~= 0 then
        for index, item in ipairs(postList) do
          if sendingMode[item.nbt] ~= 1 then
            local sucessed = postbox.pushItems(defaultFrogport, index)
            if sucessed > 0 then
              sendingMode[item.nbt] = 2;
              writeLog("[P" .. postIndex .. ">F1] " .. item.nbt, colors.green)
            end
          end
        end
      end
    end
  until false
end]]

writeStart();
parallel.waitForAll(
  genTask("SEND"),
  genTask("RECV")
)
