local ids = {
  frogport = "create:package_frogport_0",
  sendPackager = "create:packager_0",
  receivePackager = "create:packager_1"
}
local frogport = peripheral.wrap(ids.frogport);
local sendPackager = peripheral.wrap(ids.sendPackager);
local receivePackager = peripheral.wrap(ids.receivePackager);
local sendingCardboard = {};

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
        local sucessed = sendPackager.pushItems(ids.frogport, index)
        sendingCardboard[item.nbt] = true;
        if sucessed > 0 then
          writeLog("[SEND] " .. item.nbt, colors.yellow)
        end
      end
    end
  until false
end
local function receivePackagerTask()
  repeat
    local frogportList = frogport.list();
    if #frogportList ~= 0 then
      for index, item in ipairs(frogportList) do
        if not sendingCardboard[item.nbt] then
          local sucessed = frogport.pushItems(ids.receivePackager, index)
          if sucessed > 0 then
            writeLog("[RECE] " .. item.nbt, colors.green)
          end
        end
      end
    else
      sendingCardboard = {};
    end
  until false
end

writeStart();
parallel.waitForAll(sendPackagerTask, receivePackagerTask)
