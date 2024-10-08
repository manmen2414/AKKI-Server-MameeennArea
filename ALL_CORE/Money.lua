---@enum PayInfo
PayInfo = {
    Sucess = 0,
    NotEnoughMoney = 1,
    BlockedbySystem = -1
}
return function()
    ---@class MameeennMoneySystem
    local MMS = {};
    MMS.users = {};
    if fs.exists("money.json") then
        ---@type ReadStream
        local stream = fs.open("money.json", "r");
        MMS.users = textutils.unserialiseJSON(stream.readAll());
        stream.close();
    else
        ---@type WriteStream
        local stream = fs.open("money.json", "w");
        stream.write("{}");
        stream.close();
    end
    function MMS.set(username, value)
        if value < 0 then
            return PayInfo.NotEnoughMoney;
        end
        MMS.users[username] = value;
        return PayInfo.Sucess;
    end

    function MMS.get(username)
        return MMS.users[username] or 0;
    end

    function MMS.existMoney(username)
        return MMS.get(username) > 0;
    end

    function MMS.add(username, count)
        return MMS.set(username, MMS.get(username) + count)
    end

    function MMS.remove(username, count)
        return MMS.add(username, -count)
    end

    return MMS;
end
