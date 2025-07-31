local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Constants for skull values and IDs
local VAL_FLAWLESS = 100000000     -- 100kk
local VAL_CHIPPED = 1000000        -- 1kk

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Standard keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler, onlyFocus = true, text = "I buy lots of things! Just tell me the name of the item you want to sell or say 'sell all' to sell multiple items."
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler, onlyFocus = true, text = "I am Mad, the buyer of treasures and trinkets!"
})
keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler, onlyFocus = true, text = "It is exactly |TIME|."
})

-- Helper Functions
local function formatPrice(value)
    if value >= 1000000 then
        return string.format("%.1f million", value / 1000000)
    elseif value >= 1000 then
        return string.format("%d thousand", value / 1000)
    else
        return tostring(value)
    end
end

local function givePayment(cid, amount)
    local numFlawless = math.floor(amount / VAL_FLAWLESS)
    amount = amount - (numFlawless * VAL_FLAWLESS)
    
    local numChipped = math.floor(amount / VAL_CHIPPED)
    amount = amount - (numChipped * VAL_CHIPPED)

    if numFlawless > 0 then
        doPlayerAddItem(cid, ITEM_FLAWLESS_SKULL, numFlawless)
    end
    if numChipped > 0 then
        doPlayerAddItem(cid, ITEM_CHIPPED_SKULL, numChipped)
    end
    if amount > 0 then
        doPlayerAddMoney(cid, amount)
    end
    
    return {
        flawless = numFlawless,
        chipped = numChipped,
        coins = amount
    }
end

local function formatPaymentMessage(payment)
    local parts = {}
    if payment.flawless > 0 then
        table.insert(parts, payment.flawless .. " flawless skull" .. (payment.flawless > 1 and "s" or ""))
    end
    if payment.chipped > 0 then
        table.insert(parts, payment.chipped .. " chipped skull" .. (payment.chipped > 1 and "s" or ""))
    end
    if payment.coins > 0 then
        table.insert(parts, payment.coins .. " gold coins")
    end
    return table.concat(parts, ", ")
end

-- Items to buy with their IDs and prices
local items = {
    -- Regular items
    ["spike sword"] = { id = 2383, price = 10000 },
    ["magic longsword"] = { id = 2390, price = 100000 },
    ["war hammer"] = { id = 2391, price = 5000 },
    ["fire sword"] = { id = 2392, price = 10000 },
    ["giant sword"] = { id = 2393, price = 30000 },
    ["ice rapier"] = { id = 2396, price = 3000 },
    ["magic sword"] = { id = 2400, price = 80000 },
    ["bright sword"] = { id = 2407, price = 20000 },
    ["serpent sword"] = { id = 2409, price = 20000 },
    ["dragon lance"] = { id = 2414, price = 10000 },
    ["great axe"] = { id = 2415, price = 100000 },
    ["golden sickle"] = { id = 2418, price = 10000 },
    ["thunder hammer"] = { id = 2421, price = 80000 },
    ["guardian halberd"] = { id = 2427, price = 10000 },
    ["knight axe"] = { id = 2430, price = 50000 },
    ["stonecutter axe"] = { id = 2431, price = 100000 },
    ["fire axe"] = { id = 2432, price = 10000 },
    ["dragon hammer"] = { id = 2434, price = 10000 },
    ["skull staff"] = { id = 2436, price = 10000 },
    ["golden mace"] = { id = 2437, price = 60000 },
    ["apocalipsis"] = { id = 2438, price = 20000 },
    ["crystal mace"] = { id = 2445, price = 10000 },
    ["djinn blade"] = { id = 2451, price = 10000 },    
    ["guardian shield"] = { id = 2515, price = 10000 },
    ["dragon shield"] = { id = 2516, price = 10000 },
    ["beholder shield"] = { id = 2518, price = 5000 },
    ["crown shield"] = { id = 2519, price = 15000 },
    ["tower shield"] = { id = 2528, price = 20000 },
    ["ancient shield"] = { id = 2532, price = 5000 },
    ["vampire shield"] = { id = 2534, price = 20000 },
    ["amazon shield"] = { id = 2537, price = 20000 },
    ["phoenix shield"] = { id = 2539, price = 20000 },
    ["medusa shield"] = { id = 2536, price = 30000 },
    ["scarab shield"] = { id = 2540, price = 10000 },
    ["plasma shield"] = { id = 2542, price = 50000 },
    ["bronze amulet"] = { id = 2172, price = 10000 },
    ["Infinity Gauntlent"] = { id = 2218, price = 10000 },
    ["golden amulet"] = { id = 2130, price = 20000 },
    ["star amulet"] = { id = 2131, price = 20000 },
    ["ruby necklace"] = { id = 2133, price = 10000 },
    ["scarab amulet"] = { id = 2135, price = 10000 },
    ["starlight amulet"] = { id = 2138, price = 20000 },
    ["ancient amulet"] = { id = 2142, price = 20000 },
    ["strange talisman"] = { id = 2161, price = 10000 },
    ["strange symbol"] = { id = 2319, price = 10000 },
    ["helmet of the ancients"] = { id = 2342, price = 20000 },
    ["helmet of the ancients"] = { id = 2343, price = 30000 },
    ["steel helmet"] = { id = 2457, price = 1000 },
    ["devil helmet"] = { id = 2462, price = 10000 },
    ["plate armor"] = { id = 2463, price = 10000 },
    ["magic plate armor"] = { id = 2472, price = 50000 },
    ["warrior helmet"] = { id = 2475, price = 10000 },
    ["knight armor"] = { id = 2476, price = 10000 },
    ["knight legs"] = { id = 2477, price = 10000 },
    ["strange helmet"] = { id = 2479, price = 10000 },
    ["noble armor"] = { id = 2486, price = 10000 },
    ["crown armor"] = { id = 2487, price = 20000 },
    ["crown legs"] = { id = 2488, price = 20000 },
    ["dark armor"] = { id = 2489, price = 10000 },
    ["dark helmet"] = { id = 2490, price = 10000 },
    ["crown helmet"] = { id = 2491, price = 10000 },
    ["dragon scale mail"] = { id = 2492, price = 30000 },
    ["crusader helmet"] = { id = 2497, price = 10000 },
    ["royal helmet"] = { id = 2498, price = 20000 },
    ["sandals"] = { id = 2642, price = 10000 },
    ["leather boots"] = { id = 2644, price = 10000 },
    ["steel boots"] = { id = 2645, price = 10000 },
    ["plate legs"] = { id = 2647, price = 10000 },
    ["hidden turbant"] = { id = 2660, price = 50000 },
    ["magician hat"] = { id = 2662, price = 10000 },
    ["cowl"] = { id = 2664, price = 10000 },
    ["post officers hat"] = { id = 2665, price = 10000 },
    ["tribal mask"] = { id = 3967, price = 10000 },
    ["leopard armor"] = { id = 3968, price = 10000 },
    ["horseman helmet"] = { id = 3969, price = 10000 },
    ["feather headdress"] = { id = 3970, price = 2000 },
    ["charmer's tiara"] = { id = 3971, price = 10000 },
    ["beholder helmet"] = { id = 3972, price = 10000 },
    ["platinum amulet"] = { id = 2171, price = 10000 },
    ["elven legs"] = { id = 2507, price = 10000 },
    ["lady helmet"] = { id = 2499, price = 10000 },
    ["lady armor"] = { id = 2500, price = 10000 },
    
    -- Intermediate items
    ["scytheblade"] = { id = 3963, price = 200000 },
    ["blade of doom"] = { id = 2446, price = 400000 },
    ["soul slayer"] = { id = 2408, price = 600000 },
    ["harpoon"] = { id = 3964, price = 200000 },
    ["warlords battleaxe"] = { id = 3962, price = 400000 },
    ["deaths reaper"] = { id = 2443, price = 600000 },
    ["skull splitter"] = { id = 2424, price = 200000 },
    ["heavy mace"] = { id = 2452, price = 400000 },
    ["arcane staff"] = { id = 2444, price = 600000 },
    ["dwarven armor"] = { id = 2502, price = 200000 },
    ["dwarven legs"] = { id = 2503, price = 200000 },
    ["dwarven shield"] = { id = 2504, price = 200000 },
    ["strange boots"] = { id = 2641, price = 200000 },
    ["shield of honor"] = { id = 2517, price = 200000 },
    ["golden armor"] = { id = 2471, price = 400000 },
    ["golden helmet"] = { id = 2466, price = 400000 },
    ["golden legs"] = { id = 2470, price = 400000 },
    ["golden boots"] = { id = 2646, price = 400000 },
    ["blessed shield"] = { id = 2523, price = 400000 },
    ["elven mail"] = { id = 2505, price = 600000 },
    ["crown legs"] = { id = 3982, price = 600000 },
    ["great shield"] = { id = 2522, price = 600000 },
    
    -- Expensive items
    ["war axe"] = { id = 2404, price = 1000000 },
    ["dwarven axe"] = { id = 2435, price = 1000000 },
    ["lunar staff"] = { id = 2439, price = 800000 },
    ["bloody axe"] = { id = 2449, price = 1000000 },
    ["amber staff"] = { id = 2450, price = 800000 },
    ["crystal sword"] = { id = 3965, price = 800000 },
    ["crystal wand"] = { id = 2352, price = 600000 },
    ["might ring"] = { id = 2164, price = 800000 },
    ["life ring"] = { id = 2168, price = 200000 },
    ["life crystal"] = { id = 2205, price = 200000 },
    ["lordly armor"] = { id = 2468, price = 800000 },
    ["winged helmet"] = { id = 2474, price = 1000000 },
    ["lordly legs"] = { id = 2480, price = 800000 },
    ["dragonscale legs"] = { id = 2508, price = 800000 },
    ["crown helmet"] = { id = 3983, price = 1000000 },
    ["black shield"] = { id = 2529, price = 800000 },
    ["boots of haste"] = { id = 2195, price = 1000000 },
    
    -- Special items 
    ["wooden trash"] = { id = 2250, price = 1000000 },
    ["wooden trash"] = { id = 2251, price = 1000000 },
    ["wooden trash"] = { id = 2252, price = 1000000 },
    ["wooden trash"] = { id = 2253, price = 1000000 },
    ["wooden trash"] = { id = 2254, price = 1000000 },
    ["wooden trash"] = { id = 2255, price = 1000000 },
    ["metal trash"] = { id = 2256, price = 1000000 },
    ["metal trash"] = { id = 2257, price = 1000000 },
    ["underworld essence"] = { id = 4313, price = 30000000 },
    ["golden trash"] = { id = 2258, price = 1000000 },
    ["stone rubbish"] = { id = 2259, price = 1000000 }
    
}

-- Create reverse lookup table
local itemsById = {}
for name, data in pairs(items) do
    itemsById[data.id] = name
end

-- Helper function to list items by price range
local function listItems(cid, minPrice, maxPrice)
    local text = "Items I buy in this price range: "
    local first = true
    local count = 0
    
    local rangeItems = {}
    for name, data in pairs(items) do
        if data.price >= minPrice and data.price <= maxPrice then
            table.insert(rangeItems, {name = name, data = data})
            count = count + 1
        end
    end
    
    if count == 0 then
        npcHandler:say("I don't buy any items in that price range.", cid)
        return
    end
    
    table.sort(rangeItems, function(a, b) return a.data.price < b.data.price end)
    
    for _, item in ipairs(rangeItems) do
        if not first then
            text = text .. ", "
        else
            first = false
        end
        text = text .. item.name .. " (" .. formatPrice(item.data.price) .. ")"
    end
    
    local maxLength = 1000
    while #text > 0 do
        local part = string.sub(text, 1, maxLength)
        local lastComma = string.find(string.reverse(part), ",")
        
        if #text > maxLength and lastComma then
            lastComma = #part - lastComma + 1
            part = string.sub(part, 1, lastComma)
            text = string.sub(text, lastComma + 2)
        else
            text = ""
        end
        
        npcHandler:say(part, cid)
    end
end

-- Function to handle bulk selling of items from inventory
local function offerItems(cid)
    local player = Player(cid)
    if not player then
        return false
    end
    
    local totalGold = 0
    local soldItems = {}
    
    for itemName, itemData in pairs(items) do
        local count = player:getItemCount(itemData.id)
        if count > 0 then
            if player:removeItem(itemData.id, count) then
                local itemTotal = itemData.price * count
                totalGold = totalGold + itemTotal
                soldItems[itemName] = {count = count, total = itemTotal}
            end
        end
    end
    
    if totalGold > 0 then
        local payment = givePayment(cid, totalGold)
        
        local successMsg = "Thanks! I bought: "
        local first = true
        for itemName, data in pairs(soldItems) do
            if not first then
                successMsg = successMsg .. ", "
            end
            first = false
            successMsg = successMsg .. data.count .. "x " .. itemName
        end
        
        successMsg = successMsg .. " for " .. formatPaymentMessage(payment) .. "."
        npcHandler:say(successMsg, cid)
    else
        npcHandler:say("Sorry, I couldn't find any items to buy.", cid)
    end
    
    return true
end

-- Main conversation callback
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    if not player then
        return false
    end
    
    msg = string.lower(msg)

    if msgcontains(msg, "help") then
        npcHandler:say("I buy various items. Say 'categories' to see item price ranges, or tell me the name of an item you want to sell. You can also say 'sell all' and I'll check your inventory for items I might buy.", cid)
        return true
        
    elseif msgcontains(msg, "categories") then
        npcHandler:say("I buy items in these price ranges: 'cheap' (under 50k), 'medium' (50k-500k), 'expensive' (500k-1M), and 'premium' (over 1M).", cid)
        return true
        
    elseif msgcontains(msg, "cheap") then
        listItems(cid, 0, 50000)
        return true
        
    elseif msgcontains(msg, "medium") then
        listItems(cid, 50001, 500000)
        return true
        
    elseif msgcontains(msg, "expensive") then
        listItems(cid, 500001, 1000000)
        return true
        
    elseif msgcontains(msg, "premium") then
        listItems(cid, 1000001, 999999999)
        return true
        
    elseif msgcontains(msg, "sell all") then
        return offerItems(cid)
        
    else
        -- Direct item sale without confirmation
        for itemName, itemData in pairs(items) do
            if msg == string.lower(itemName) then
                if player:getItemCount(itemData.id) > 0 then
                    if player:removeItem(itemData.id, 1) then
                        local payment = givePayment(cid, itemData.price)
                        npcHandler:say("Thank you for the " .. itemName .. "! Here's your payment: " .. formatPaymentMessage(payment) .. ".", cid)
                    end
                else
                    npcHandler:say("You don't have a " .. itemName .. " to sell me.", cid)
                end
                return true
            end
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())