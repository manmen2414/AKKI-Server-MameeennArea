local displaylink = peripheral.find("Create_DisplayLink") or error("no Display Link.");

local function write()
    displaylink.clear();
    displaylink.setCursorPos(1, 1);
    displaylink.write(os.date("%Y/%m/%d"));
    displaylink.setCursorPos(1, 2);
    displaylink.write(os.date("%T"));
    displaylink.setCursorPos(1, 3);
    displaylink.write("('V')/")
    displaylink.setCursorPos(1, 4);
    displaylink.write("Mameeenn Area");
    displaylink.update();
end

repeat
    write();
    sleep(0.5)
until false
