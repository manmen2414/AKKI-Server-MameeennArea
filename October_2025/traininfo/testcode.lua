---@type string[][]
local lineMap = {
  {
    "1",
    "1>P1",
    "2",
  },
  {
    "2",
    "2>1",
    "1",
  },
}
---@type {from:string[],to:string[]}
local trainMoveable = {
  from = {},
  to = {}
};
local function createTrainMoveable()
  for _, betweenPoints in ipairs(lineMap) do
    for i, point in ipairs(betweenPoints) do
      local next = betweenPoints[i + 1];
      if (next) then
        trainMoveable.from[#trainMoveable.from + 1] = point;
        trainMoveable.to[#trainMoveable.to + 1] = next;
      end
    end
  end
end
createTrainMoveable()
local pretty = require("cc.pretty")
pretty.pretty_print(trainMoveable)
