local logger = {};
---@type {count:integer,id:string,nbt:table,at:string}[]
local requests = {};
local Webhook =
"https://discord.com/api/webhooks/1300423103901601824/hhDN5yylR5x8an-H6y4fEHlZ8pc_Dkga4dH7uxXpzGTREMnFbWu1aWIkiCodUS6ITiTd";
local STORAGES = {
    ["From"] = "minecolonies:warehouse_0",
    ["Laney I. Delgadillo"] = "minecolonies:colonybuilding_0",
    ["Zayden C. Wallgreen"] = "minecolonies:colonybuilding_1",
}

local function getRequests(Colony)
    local rawRequests = Colony.getRequests();
    for index, request in ipairs(rawRequests) do
        for _, value in ipairs(requests) do
            if value.id == request.items[1].name then
                goto next;
            end
        end
        requests[#requests + 1] = {
            count = request.count,
            id = request.items[1].name,
            nbt = request.items[1].id,
            at = request.target
        }
        ::next::
    end
    logger:print("We have " .. #requests .. " requests.")
end

local function ResolveRequests(Colony)
    local failedRequest = {};
    for index, request in ipairs(requests) do
        term.setTextColor(colors.brown);
        local from = peripheral.wrap(STORAGES["From"])
        for slot, value in ipairs(from.list()) do
            if value.name == request.id then
                local moved = from.pushItems(STORAGES[request.at], slot, request.count)
                term.setTextColor(colors.white)
                logger:print("Moved item: " .. request.id .. ", count:" .. moved);
                requests[index].count = request.count - moved;
                if requests[index].count == 0 then
                    term.setTextColor(colors.green)
                    logger:print("Resolved item: " .. request.id);
                    table.remove(requests, index)
                    return;
                end
            end
            failedRequest[#failedRequest + 1] = request;
        end
    end
    local field = {};
    for index, value in ipairs(failedRequest) do
        field[#field + 1] = {
            text = value.at,
            value = value.count .. "x " .. value.id,
            inline = true
        }
    end
    print(require("Discord_Webhook.WebhookDiscord")(Webhook, nil, Colony.getColonyName(), nil,
        require("Discord_Webhook.CreateEmbed").Embed(
        ---@diagnostic disable-next-line: param-type-mismatch
            "Request Items Report", "We don't have items.", nil, os.date("%Y-%m-%dT%H:%M:%S.00"), 0xffffff, nil, nil, nil,
            nil,
            nil, field
        )))
end

return {
    load = function(arg)
        logger = arg.Logger("Request", colors.yellow)
        logger:print("Loaded!")
        getRequests(arg.Colony);
    end,
    roop = function(arg)
        getRequests(arg.Colony);
        ResolveRequests(arg.Colony);
        sleep(10);
    end
}
