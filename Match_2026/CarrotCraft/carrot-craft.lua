--- [Environment File Needed] env_dev.lua -> env.lua

if not turtle then
  error("This program can be run in turtle.")
end

---@param name string
---@param defaultValue "error"|any
---@return any | false
local function SafeRequire(name, defaultValue)
  local sucessed, required = pcall(require, name);
  if (sucessed) then return required end;
  if (defaultValue == "error") then error(required); end;
  if (defaultValue) then return defaultValue end;
  return false;
end

---@param name string
---@param url string
local function getPackage(name, url)
  local package = SafeRequire(name)
  if not package then
    shell.run("wget",
      url,
      name .. ".lua");
    return require(name);
  end
  return package;
end

local env = getPackage("env",
  "https://raw.githubusercontent.com/manmen2414/AKKI-Server-MameeennArea/refs/heads/main/Match_2026/env-dev.lua")
local WebhookDiscord = getPackage("WebhookDiscord",
  "https://raw.githubusercontent.com/manmen2414/Smali_CCTPrograms/refs/heads/main/src/Discord_Webhook/WebhookDiscord.lua")
local CreateEmbed = getPackage("CreateEmbed",
  "https://raw.githubusercontent.com/manmen2414/Smali_CCTPrograms/refs/heads/main/src/Discord_Webhook/CreateEmbed.lua")
local name = "Carrot Compresser"


---@type "Setup"|"Running"|"ErrorCrafting"|"ErrorDropping"|"ErrorPulling"
local status = "Setup"


---@param reason string
local function reportError(reason)
  if env.SEND_TO_DISCORD then
    WebhookDiscord(env.DISCORD_WEBHOOK, nil, nil, nil, {
      CreateEmbed.Embed("An error occurred", "Error(" .. status .. ")\n" .. reason, nil, nil, 0xee3333, nil, nil, nil,
        nil,
        { name = name }, nil)
    })
  end
end

local function reportResumed()
  if env.SEND_TO_DISCORD then
    WebhookDiscord(env.DISCORD_WEBHOOK, nil, nil, nil, {
      CreateEmbed.Embed("System Resumed", nil, nil, nil, 0x33ee33, nil, nil, nil,
        nil,
        { name = name }, nil)
    })
  end
end


local function isStatusError()
  return status:startsWith("Error")
end

---@param slot integer
---@return integer
local function getItemCount(slot)
  local slotInfo = turtle.getItemDetail(slot)
  if not slotInfo then
    return 0;
  end
  return slotInfo.count
end

---@param slot integer
local function getCarrot(slot)
  repeat
    turtle.select(slot);
    local count = getItemCount(slot);
    turtle.suck(64 - count);
    sleep(0.05)
  until count == 64
end

local function getCarrots()
  getCarrot(1)
  getCarrot(2)
  getCarrot(3)
  getCarrot(5)
  getCarrot(6)
  getCarrot(7)
  getCarrot(9)
  getCarrot(10)
  getCarrot(11)
end

local function craft()
  if not turtle.craft then
    error("Need crafting table to craft.")
  end
  local successed, reason = turtle.craft();
  if not successed and not isStatusError() then
    status = "ErrorCrafting";
    reportError(reason);
  end
  if successed and isStatusError() then
    status = "Running";
    reportResumed();
  end
end

local function dropCrafted()
  local slotInfo = turtle.getItemDetail();
  if not slotInfo or slotInfo.name == "minecraft:carrot" then
    return;
  end
  local successed, reason = turtle.dropDown();
  if not successed and not isStatusError() then
    status = "ErrorDropping";
    reportError(reason);
  end
  if successed and isStatusError() then
    status = "Running";
    reportResumed();
  end
end

---@param str string
---@param start string
---@return boolean
function string.startsWith(str, start)
  return string.sub(str, 1, string.len(start)) == start
end

status = "Running"
repeat
  getCarrots()
  craft()
  dropCrafted()
until false
