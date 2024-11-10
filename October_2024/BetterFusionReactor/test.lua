local back = peripheral.wrap("back")

repeat
    local damage = back.getDamagePercent();
    if damage < 99 then
        back.setBurnRate(0.2)
        back.activate();
        sleep(0.1)
        back.scram()
    end
until false
