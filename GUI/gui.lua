local GUI = {};
local Potion = {};

local function safeChange(func, ...)
    local color     = term.getTextColor();
    local backcolor = term.getBackgroundColor();
    local x, y      = term.getCursorPos();
    local returns   = { func(...) };
    term.setTextColor(color);
    term.setBackgroundColor(backcolor);
    term.setCursorPos(x, y);
    return table.unpack(returns)
end
---size class
---@param fromX number
---@param fromY number
---@param toX number
---@param toY number
---@return Size
function Potion.newSize(fromX, fromY, toX, toY)
    ---@class Size
    local size = {}
    size.fromX = fromX;
    size.fromY = fromY;
    size.toX = toX;
    size.toY = toY;
    size.from = Potion.newVector2(fromX, fromY)
    size.to = Potion.newVector2(toX, toY)
    ---@param color number?
    function size.clear(self, color)
        return safeChange(function()
            local count = 0;
            if color then
                term.setBackgroundColor(color);
            end
            for y = self.fromY, self.toY, 1 do
                for x = self.fromX, self.toX, 1 do
                    term.setCursorPos(x, y);
                    term.write(" ");
                    count = count + 1;
                end
            end
            return count;
        end)
    end

    ---@param x number
    ---@param y number
    function size.IsInner(self, x, y)
        local xInnner = self.fromX <= x and x <= self.toX;
        local yInnner = self.fromY <= y and y <= self.toY;
        return xInnner and yInnner;
    end

    return size;
end

---term Size
---@return Size
function Potion.termSize()
    return Potion.newSize(1, 1, term.getSize())
end

---vector2 class
---@param x number
---@param y number
---@return Vector2
function Potion.newVector2(x, y)
    ---@class Vector2
    local vector2 = {};
    vector2.x = x;
    vector2.y = y;
    ---@return number,number
    function vector2.get(self)
        return self.x, self.y;
    end

    function vector2.to(self, tox, toy)
        return Potion.newSize(self.x, self.y, tox, toy)
    end

    return vector2;
end

---@param Potion Vector2
---@param Text string
---@param Color number?
---@param BackColor number?
function GUI.Text(Potion, Text, Color, BackColor)
    safeChange(function()
        term.setCursorPos(Potion:get());
        term.setTextColor(Color or term.getTextColor());
        term.setBackgroundColor(BackColor or term.getBackgroundColor());
        term.write(Text);
    end)
end

---@param Size Size
---@param Text string
---@param ButtonNormalColor number
---@param TextColor number?
---@param Function function?
---@return [Size,string,number,number?,function?]
function GUI.Button(Size, Text, ButtonNormalColor, TextColor, Function)
    return safeChange(function()
        Size:clear(ButtonNormalColor);
        GUI.Text(Size.from, Text, TextColor, ButtonNormalColor)
        return { Size, Text, ButtonNormalColor, TextColor, function(func, ...)
            return (Function or function() end)()
        end };
    end)
end

---@param Size Size
---@param Placeholder string
---@param BackGroundColor number?
---@param TextColor number?
---@param isPassword boolean?
---@param Choices string[]?
---@param Function function?
---@return [Size,string,number?,number?,function]
function GUI.Input(Size, Placeholder, BackGroundColor, TextColor, isPassword, Choices, Function)
    local ButtonFunc = GUI.Button(Size, Placeholder, BackGroundColor or term.getTextColor(), TextColor);
    return { Size, Placeholder, BackGroundColor, TextColor, function()
        return safeChange(function()
            term.setCursorPos(Size.from:get())
            term.setTextColor(TextColor);
            term.setBackgroundColor(BackGroundColor);
            GUI.Button(Size, "", BackGroundColor or term.getTextColor(), TextColor);
            local ans = read((function() if isPassword then return "\07" end end)(), nil, function(t)
                return require("cc.completion").choice(t, Choices or {})
            end);
            return (Function or function(ans) end)(ans)
        end)
    end
    }
end

function GUI.WaitForAllButtonOrInput(...)
    local BorIObjs = { ... };
    ---@type Size[]
    local SizeList = {};
    local FuncList = {};
    for i = 1, #BorIObjs, 1 do
        SizeList[#SizeList + 1] = BorIObjs[i][1]
        FuncList[#FuncList + 1] = BorIObjs[i][#BorIObjs[i]]
    end
    local _, _, x, y;
    local foundButtonFunc = false;
    repeat
        repeat
            _, _, x, y = os.pullEvent("mouse_click")
            for index, value in ipairs(SizeList) do
                if value:IsInner(x, y) then
                    foundButtonFunc = FuncList[index]
                end
            end
        until foundButtonFunc
        if foundButtonFunc then
            local ans = foundButtonFunc()
            if ans then
                return ans;
            end
        end
    until false
end

return { Potion = Potion, GUI = GUI }
