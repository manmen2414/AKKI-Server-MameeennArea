local termX, termY = term.getSize();
return function(taskName, color)
    ---@class LogPrinter
    local logPrinter = {}
    logPrinter.taskName = taskName;
    logPrinter.taskColor = color;
    function logPrinter.print(self, text)
        local time = os.date("%H:%M:%S")
        term.blit("[" .. time .. ",", "0bbbbbbbb0", "ffffffffff")
        term.setTextColor(self.taskColor or colors.lime)
        term.write(self.taskName)
        term.setTextColor(colors.white)
        term.write("] ")
        local splited = {};
        local remainingTexts = text;
        repeat
            local writedCount = term.getCursorPos();
            local writeable = termX - writedCount;
            print(remainingTexts:sub(0, writeable))
            remainingTexts = remainingTexts:sub(writeable + 1)
            if #remainingTexts == 0 then
                break;
            else
                term.blit("\149 ", "70", "ff")
            end
        until false
    end

    function logPrinter.AddPrint(self, text)
        term.blit("\149 ", "70", "ff")
        print(text)
    end

    return logPrinter;
end;
