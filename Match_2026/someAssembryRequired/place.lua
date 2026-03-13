local breakTurtle = peripheral.find("turtle");
local mainItem = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
---@type number[][]
---上から順にパンを制作する。\
---配列内の任意のスロットにある食材を用いる。\
---最初は必ずパンである必要がある。
local recipe = {
  { 1, 2, 3, 4 },
  mainItem,
  mainItem,
  mainItem,
  mainItem,
  mainItem,
  mainItem,
  mainItem,
  mainItem,
}

---@param slotArr number[] 取得する任意のスロット。
local function getEnableSlots(slotArr)
  for i, slot in ipairs(slotArr) do
    if not not turtle.getItemDetail(slot) then
      turtle.select(slot);
      return true;
    end
  end
  return false;
end

local function make()
  for i, slotArr in ipairs(recipe) do
    if not getEnableSlots(slotArr) then
      return true;
    end
    ;
    turtle.place();
  end
  breakTurtle.reboot();
  return false;
end

repeat
  sleep(1);
until make();
print("Done!")
