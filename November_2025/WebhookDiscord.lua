---@return boolean,string
---@param webhookurl string
---@param content string|nil --content or embeds
---@param username string|nil
---@param imageurl string|nil
---@param embeds table|nil --arrays of embed
return function(webhookurl, content, username, imageurl, embeds)
    local bodytable = {}
    if webhookurl == nil or (content == nil and embeds == nil) then
        return false, "webhookurl or content,embeds is nil";
    end
    bodytable["content"] = content;
    bodytable["username"] = username;
    bodytable["avatar_url"] = imageurl;
    bodytable["embeds"] = embeds;
    local Resornil = http.post(webhookurl, textutils.serialiseJSON(bodytable), { ["Content-Type"] = "application/json" });
    if Resornil == nil then
        return false, "Post failed";
    else
        return true, "Post success!";
    end
end
