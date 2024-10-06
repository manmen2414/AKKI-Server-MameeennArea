local termX, termY = term.getSize();
return function(taskName, taskColor)
    ---@class LogPrinter
    local logPrinter = {}
    logPrinter.taskName = taskName;
    logPrinter.taskColor = taskColor;
    function logPrinter.print(self, text)
        local time = os.date("%H:%M:%S")
        term.blit("[" .. time .. ",", "0bbbbbbbb0", "ffffffffff")
        term.setTextColor(self.taskColor or colors.lime)
        term.write(self.taskName)
        term.setTextColor(colors.white)
        term.write("] ")
        local splited = {};
        local remainingTexts = text;
        local writedCount = term.getCursorPos();
        local writeable = termX - writedCount;
        --local writeText = remainingTexts:sub(0, writeable);
        local continue = false;
        for i = 1, #text, 1 do
            local char = text:sub(i, i)
            local nextChar = text:sub(i + 1, i + 1)
            if continue then
                continue = false;
            elseif nextChar == "\n" or #nextChar == 0 or ({ term.getCursorPos() })[1] == termX then
                _G.print(char);
            elseif char == "\222" then
                local color = colors.fromBlit(nextChar)
                term.setTextColor(color)
                continue = true;
            else
                if ({ term.getCursorPos() })[1] == 1 then
                    term.blit("\149 ", "70", "ff")
                end
                term.write(char)
            end
        end
        remainingTexts = remainingTexts:sub(writeable + 1)
    end

    function logPrinter.AddPrint(self, text)
        term.blit("\149 ", "70", "ff")
        local continue = false;
        for i = 1, #text, 1 do
            local char = text:sub(i, i)
            local nextChar = text:sub(i + 1, i + 1)
            if continue then
                continue = false;
            elseif nextChar == "\n" or #nextChar == 0 or ({ term.getCursorPos() })[1] == termX then
                _G.print(char);
            elseif char == "\222" then
                local color = colors.fromBlit(nextChar)
                term.setTextColor(color)
                continue = true;
            else
                if ({ term.getCursorPos() })[1] == 1 then
                    term.blit("\149 ", "70", "ff")
                end
                term.write(char)
            end
        end
    end

    return logPrinter;
end;
