---@param INVENTORY "any"|string
return function(INVENTORY)
    ---@generic T
    ---@param bool boolean
    ---@param a T
    ---@param b T
    ---@return T
    local function bSelect(bool, a, b)
        if bool then return a else return b end
    end

    ---@type Inventory
    local inventory = bSelect(INVENTORY == "any", peripheral.find("inventory"), peripheral.wrap(INVENTORY));
    if not inventory then
        return nil;
    end

    local function getInventoryItems()
        --インベントリが消失した場合は全てのものがなくなった扱いとする
        if (not inventory.size()) then return {} end
        ---@type string[]
        local list = {};
        for _, v in pairs(inventory.list()) do
            list[#list + 1] = v.name;
        end
        return list;
    end
    ---@param arr any[]
    ---@param findValue any
    ---@return boolean
    local function find(arr, findValue)
        for _, value in ipairs(arr) do
            if (value == findValue) then return true end;
        end
        return false;
    end
    ---@generic T
    ---@param arrA T[]
    ---@param arrB T[]
    ---@return {onlyA:T[],onlyB:T[]}
    ---findを`#arrA+#arrB`回使うので効率悪いかも？
    local function checkDiff(arrA, arrB)
        local diff = { onlyA = {}, onlyB = {} };
        --arrAを回してない場合はonlyAに追加
        for index, a in ipairs(arrA) do
            if (not find(arrB, a)) then
                diff.onlyA[#diff.onlyA + 1] = a;
            end
        end
        --arrBを回してない場合はonlyBに追加
        for index, b in ipairs(arrB) do
            if (not find(arrA, b)) then
                diff.onlyB[#diff.onlyB + 1] = b;
            end
        end
        return diff;
    end

    local previousItems = getInventoryItems();

    return function()
        local items = getInventoryItems();
        local diff = checkDiff(previousItems, items)
        previousItems = items;
        return { stockOut = diff.onlyA, stockIncreased = diff.onlyB };
    end
end
