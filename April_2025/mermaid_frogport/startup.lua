local ids = {
  sendPackager = "create:packager_0",
  receivePackager = "create:packager_1"
}
local DEFAULT_FROGPORT = 1;
local frogports = { peripheral.find("create:package_frogport") };
local sendPackager = peripheral.wrap(ids.sendPackager);
local receivePackager = peripheral.wrap(ids.receivePackager);
local sendingCardboard = {};
if #frogports == 0 then error("frogport not connected"); end

local function writeStart()
  term.clear();
  term.setCursorPos(1, 1);
  term.setTextColor(colors.red)
  print("Cardboard I/O System")
  term.setTextColor(colors.white)
end
local function writeLog(content, color)
  term.setTextColor(color)
  print(content)
  term.setTextColor(colors.white)
end
local function sendPackagerTask()
  repeat
    local OPackagerList = sendPackager.list();
    if #OPackagerList ~= 0 then
      for index, item in ipairs(OPackagerList) do
        local sucessed = sendPackager.pushItems(
          peripheral.getName(frogports[DEFAULT_FROGPORT]), index)
        sendingCardboard[item.nbt] = true;
        if sucessed > 0 then
          writeLog("[SEND " .. DEFAULT_FROGPORT .. "] " .. item.nbt, colors.yellow)
        end
      end
    end
  until false
end
local function receivePackagerTask()
  repeat
    for frogIndex, frogport in ipairs(frogports) do
      local frogportList = frogport.list();
      if #frogportList ~= 0 then
        for index, item in ipairs(frogportList) do
          if not sendingCardboard[item.nbt] then
            local sucessed = frogport.pushItems(ids.receivePackager, index)
            if sucessed > 0 then
              writeLog("[RECV " .. frogIndex .. "] " .. item.nbt, colors.green)
            end
            --パッケージャーが空になるまでの時間。余裕をもって1
            --//TODO: シングルプレイワールドでバグの整合性を確認する
            sleep(1)
          end
        end
      else
        sendingCardboard = {};
      end
    end
  until false
end

writeStart();
parallel.waitForAll(sendPackagerTask, receivePackagerTask)
