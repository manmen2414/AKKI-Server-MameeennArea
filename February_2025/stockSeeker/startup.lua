local seek = require("seeker")("any") or error("inventory not found");
repeat
    local diff = seek();
    for index, value in ipairs(diff.stockOut) do
        print("- " .. value)
    end
    for index, value in ipairs(diff.stockIncreased) do
        print("+ " .. value)
    end
    sleep(0.5)
until false
