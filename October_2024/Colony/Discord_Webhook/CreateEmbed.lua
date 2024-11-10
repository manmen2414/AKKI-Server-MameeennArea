local Pubilc = {}
---@return table  --EmbedJson
---@param title string|nil
---@param description string|nil
---@param url string|nil
---@param timestamp string|nil --ISO8601 timestamp
---@param color integer|nil
---@param footer table|nil
---@param image table|nil --URL("imageurl here")
---@param thumbnail table|nil --URL("thumbnailurl here")
---@param vidio table|nil --URL("videourl here")
---@param author table|nil
---@param fields table|nil --field array
function Pubilc.Embed(title, description, url, timestamp, color, footer, image, thumbnail, vidio, author, fields)
    local embedtable = {};
    embedtable["title"] = title;
    embedtable["type"] = "rich";
    embedtable["description"] = description;
    embedtable["url"] = url;
    embedtable["timestamp"] = timestamp;
    embedtable["color"] = color;
    embedtable["footer"] = footer;
    embedtable["image"] = image;
    embedtable["thumbnail"] = thumbnail;
    embedtable["vidio"] = vidio;
    embedtable["author"] = author;
    embedtable["fields"] = fields;
    return embedtable;
end

---@return table|nil
---@param text string
---@param icon_url string|nil
function Pubilc.Footer(text, icon_url)
    if text == nil then
        return nil;
    end
    local footertable = {};
    footertable["text"] = text;
    footertable["icon_url"] = icon_url;
    return footertable;
end

---@return table|nil
---@param url string
function Pubilc.URL(url)
    if url == nil then
        return nil;
    end
    local table = {};
    table["url"] = url;
    return table;
end

---@return table|nil
---@param name string
---@param url string|nil
---@param icon_url string|nil
function Pubilc.Author(name, url, icon_url)
    if name == nil then
        return nil;
    end
    local authortable = {};
    authortable["name"] = name;
    authortable["url"] = url;
    authortable["icon_url"] = icon_url;
    return authortable;
end

---@return table|nil
---@param name string
---@param value string
---@param inline boolean|nil
function Pubilc.Field(name, value, inline)
    if name == nil or value == nil then
        return nil;
    end
    local fieldtable = {};
    fieldtable["text"] = name;
    fieldtable["value"] = value;
    fieldtable["inline"] = inline;
    return fieldtable;
end

return Pubilc;
