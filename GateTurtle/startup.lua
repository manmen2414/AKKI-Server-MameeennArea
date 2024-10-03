local function OpenGate()
    redstone.setOutput("front", true)
    turtle.dropDown();
    sleep(0.5);
    redstone.setOutput("front", false)
end
local function Main()
    repeat
        turtle.suckUp();
        if turtle.getItemCount() ~= 0 then
            local item = turtle.getItemDetail();
            if item.name == "lightmanscurrency:coin_copper" then
                OpenGate()
            else
                turtle.turnLeft()
                turtle.drop();
                turtle.turnRight();
                sleep(1);
            end
        end
    until false
end

repeat
    local _, reason = pcall(Main);
    if reason == "Terminated" then
        return;
    end
until false
