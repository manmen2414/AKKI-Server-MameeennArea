---@type ChatBox
local chatBox = peripheral.find("chatBox");
local inventoryManager = peripheral.find("inventoryManager");
local side = "up";
repeat
  local event, username, message = os.pullEvent("chat")
  if (inventoryManager.getOwner() == username and message == "t") then
    print("emergency transport activated")
    for index, value in ipairs(inventoryManager.list()) do
      inventoryManager.removeItemFromPlayer(side, value);
    end
    for index, value in ipairs(inventoryManager.getArmor()) do
      inventoryManager.removeItemFromPlayer(side, value);
    end
  end
until false
