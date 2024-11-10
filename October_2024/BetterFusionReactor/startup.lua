local rla = peripheral.find("fusionReactorLogicAdapter") or error("No fusion Reactor") or {
    ---@return number
    ---@diagnostic disable-next-line:missing-return
    getEfficiency = function() end,
    ---@return number
    ---@diagnostic disable-next-line:missing-return
    getErrorLevel = function() end,
    ---@param value number
    adjustReactivity = function(value) end,

}

local CR = 0;
local isMoving = false;

print("Hold CTRL+C to exit...")

---@alias MoniroredAnswers
---|0 0の場合、開始地点から終了地点にはTRの値がないし、TRから離れていることを表す。
---|1 1の場合、TRは半分より進行方向にある。
---|2 2の場合、開始地点から終了地点にはTRの値がないが、TRに近づいて行ってることを表す。
---|-1 -1の場合、TRは半分より逆方向にある。
---@return MoniroredAnswers
local function MonitoringEF()
    local lastEfficiency = -1;
    local curEfficiency = 0;
    local repeatCount = 1;
    local EFMaxTiming = 0;
    local SameCount = 0;
    isMoving = true;
    repeat
        curEfficiency = rla.getEfficiency();
        if lastEfficiency ~= -1 then
            if lastEfficiency == curEfficiency then
                if SameCount > 3 then
                    isMoving = false;
                    if repeatCount == EFMaxTiming then
                        return 2;
                    elseif EFMaxTiming == 0 then
                        return 0;
                    elseif repeatCount / 2 < EFMaxTiming then
                        return 1;
                    else
                        return -1;
                    end
                else
                    SameCount = SameCount + 1;
                end
            elseif lastEfficiency < curEfficiency then
                SameCount = 0;
                EFMaxTiming = repeatCount;
            else
                SameCount = 0;
            end
        end
        lastEfficiency = curEfficiency;
        repeatCount = repeatCount + 1;
        ---@diagnostic disable-next-line:missing-return
    until false;
end

local function addValue(num)
    rla.adjustReactivity(num);
    CR = CR + num;
    if CR < 0 then
        CR = 0;
    elseif CR > 100 then
        CR = 100;
    end
end

local function Set()
    sleep(3);
    term.clear();
    term.setCursorPos(1, 1)
    term.setTextColor(colors.yellow);
    print("- Adjust Start")
    term.setTextColor(colors.white)
    isMoving = true;
    rla.adjustReactivity(-100);
    sleep(5);
    isMoving = false;
    CR = 0;
    local Quarter = 25;
    local StartPoint = 0;
    addValue(Quarter)
    MonitoringEF();
    for i = 1, 4, 1 do
        addValue(Quarter * 2);
        local TRPos = MonitoringEF();
        local Sixteenth = Quarter / 4;
        term.blit(i .. ",value:", "d0333333", "ffffffff")
        term.write(TRPos .. " ")
        if TRPos == 0 then
            print("TR:" .. StartPoint + Quarter * 0 .. " - " .. StartPoint + Quarter * 1);
            addValue(Sixteenth - Quarter * 3);
            MonitoringEF();
            Quarter = Sixteenth;
        elseif TRPos == -1 then
            print("TR:" .. StartPoint + Quarter * 1 .. " - " .. StartPoint + Quarter * 2);
            addValue(Sixteenth - Quarter * 2);
            MonitoringEF();
            StartPoint = StartPoint + Quarter;
            Quarter = Sixteenth;
        elseif TRPos == 1 then
            print("TR:" .. StartPoint + Quarter * 2 .. " - " .. StartPoint + Quarter * 3);
            addValue(Sixteenth - Quarter);
            MonitoringEF();
            StartPoint = StartPoint + Quarter * 2;
            Quarter = Sixteenth;
        elseif TRPos == 2 then
            print("TR:" .. StartPoint + Quarter * 3 .. " - " .. StartPoint + Quarter * 4);
            addValue(Sixteenth);
            MonitoringEF();
            StartPoint = StartPoint + Quarter * 3;
            Quarter = Sixteenth;
        end
    end
    term.setTextColor(colors.yellow)
    print("- Start tweaking")
    term.setTextColor(colors.white)
    local lastEfficiency = 0
    local curEfficiency = 0
    local adjustment = 0.25
    repeat
        curEfficiency = rla.getEfficiency()
        if curEfficiency > 0 then
            if lastEfficiency > curEfficiency then
                adjustment = -adjustment
            end
            addValue(adjustment)
            lastEfficiency = curEfficiency
            if rla.getEfficiency() > 99 then
                term.setBackgroundColor(colors.yellow)
                term.setTextColor(colors.black);
                print(string.rep(" ", 100))
                print("End Adjust! CR:" .. CR .. string.rep(" ", 100))
                print(string.rep(" ", 100));
                term.setTextColor(colors.white);
                term.setBackgroundColor(colors.black)
                return;
            end
            sleep(0.25);
        end
    until false
end
local exit = false;
local function Check()
    local lastEfficiency = -1;
    local curEfficiency = -1;
    local lastErrorLevel = -1;
    local curErrorLevel = 0;
    repeat
        curEfficiency = rla.getEfficiency();
        curErrorLevel = rla.getErrorLevel();
        if curEfficiency == 0 then
            exit = true;
            return;
        elseif lastEfficiency - curEfficiency > 5 and not isMoving then
            return;
        else
            local Tx, Ty = term.getSize()
            local Cx, Cy = term.getCursorPos();
            term.setCursorPos(Tx - 5, 1);
            term.write("EF:" .. math.floor(curEfficiency))
            term.setCursorPos(Tx - 5, 2);
            term.write("CR:" .. math.floor(CR))
            term.setCursorPos(Tx - 5, 3);
            term.write("ER:" .. math.floor(lastErrorLevel))
            term.setCursorPos(Cx, Cy)
            sleep(0.35);
        end
        lastEfficiency = curEfficiency;
        lastErrorLevel = curErrorLevel;
    until false
end

repeat
    parallel.waitForAny(Check, function()
        Set(); sleep(2e32);
    end)
until exit

term.clear();
term.setCursorPos(1, 1)
term.setTextColor(colors.red);
print("Fusion Reactor is Stoped.")
term.setTextColor(colors.white)
