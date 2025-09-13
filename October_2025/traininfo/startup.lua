---@type TrainInfo.Setting
local setting = {
  port = 24140,
  railId = "test",
  areaId = "",
  platform = nil
}

---@type Modem
local modem = peripheral.find("modem") or error("No modem");


---@param name string
---@param defaultValue "error"|any
---@return any | false
function SafeRequire(name, defaultValue)
  local sucessed, required = pcall(require, name);
  if (sucessed) then return required end;
  if (defaultValue == "error") then error(required); end;
  if (defaultValue) then return defaultValue end;
  return false;
end

local func = SafeRequire("detector", nil) or
    SafeRequire("hub", nil) or
    SafeRequire("station", "error")
func(setting, modem)
