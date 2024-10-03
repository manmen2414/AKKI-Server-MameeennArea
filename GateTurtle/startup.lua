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

        end
    until false
end

repeat
    pcall(Main)
until false
