local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Load PaymentSystem module
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Items for sale with their IDs and prices
local items = {
    -- Destruction Set
    ["destruction armor"] = {id = 2503, price = 1000000},
    ["destruction legs"] = {id = 2504, price = 1000000},
    ["destruction helmet"] = {id = 2502, price = 1000000},
    ["destruction boots"] = {id = 2641, price = 1000000},
    ["destruction shield"] = {id = 2517, price = 1000000},
    
    -- Holy Set
    ["holy armor"] = {id = 2466, price = 2000000},
    ["holy helmet"] = {id = 2471, price = 2000000},
    ["holy legs"] = {id = 2470, price = 2000000},
    ["holy shield"] = {id = 2523, price = 2000000},
    ["holy boots"] = {id = 2646, price = 2000000},
    
    -- Chaos Set
    ["chaos helmet"] = {id = 2506, price = 3000000},
    ["chaos armor"] = {id = 2505, price = 3000000},
    ["chaos legs"] = {id = 2469, price = 3000000},
    ["chaos shield"] = {id = 2522, price = 3000000},
    ["chaos boots"] = {id = 3982, price = 3000000},
    
    -- Weapons
    ["enchanted arrow"] = {id = 2352, price = 3000000},
    ["scytheblade"] = {id = 3963, price = 1000000},
    ["blade of doom"] = {id = 2446, price = 2000000},
    ["soul slayer"] = {id = 2408, price = 3000000},
    ["harpoon"] = {id = 3964, price = 1000000},
    ["warlords battleaxe"] = {id = 3962, price = 2000000},
    ["deaths reaper"] = {id = 2443, price = 3000000},
    ["skull splitter"] = {id = 2424, price = 1000000},
    ["hammer of wrath"] = {id = 2444, price = 3000000},
    ["destroyer"] = {id = 2452, price = 2000000},
    
    -- Other Items
    ["brown mushroom"] = {id = 2789, price = 1000, amount = 100},
    ["green tome"] = {id = 1983, price = 500000},
    ["crafting ore"] = {id = 2225, price = 500000}
}

-- Helper function to format prices
local function formatPrice(value)
    if value >= 1000000 then
        if value % 1000000 == 0 then
            return string.format("%d million", value / 1000000)
        else
            return string.format("%.1f million", value / 1000000)
        end
    else
        return string.format("%d thousand", value / 1000)
    end
end

-- Helper function to list wares
local function listWares(cid)
    local text = "I sell: Destruction Set(1mil each), Holy Set(2mil each), Chaos Set(3mil each), Various Weapons, and other items. Which would you like to know more about?"
    npcHandler:say(text, cid)
end

-- Table to hold the talk state for each player
local talkState = {}

-- Main conversation callback
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = string.lower(msg)

    if msgcontains(msg, "hi") then
        npcHandler:say("Hello " .. getCreatureName(cid) .. "! Welcome to my shop. Say 'wares' to see what I sell.", cid)
        talkState[cid] = nil

    elseif msgcontains(msg, "bye") then
        npcHandler:say("Good bye, " .. getCreatureName(cid) .. "!", cid)
        npcHandler:releaseFocus(cid)
        talkState[cid] = nil

    elseif msgcontains(msg, "wares") then
        listWares(cid)
    
    -- If a purchase is in confirmation stage...
    elseif talkState[cid] then
        if msgcontains(msg, "yes") then
            local itemName = talkState[cid]
            local item = items[itemName]
            if item then
                if PaymentSystem.canPlayerPay(cid, item.price) then
                    if PaymentSystem.processPayment(cid, item.price) then
                        local amount = item.amount or 1
                        if doPlayerAddItem(cid, item.id, amount) then
                            npcHandler:say("Here is your " .. itemName .. ". Thank you for your purchase!", cid)
                        else
                            npcHandler:say("You don't have enough space in your inventory.", cid)
                            -- Refund the payment if inventory is full
                            PaymentSystem.returnPayment(cid, item.price)
                        end
                    else
                        npcHandler:say("There was a problem processing your payment. Please try again.", cid)
                    end
                else
                    npcHandler:say("You don't have enough money. The price is " .. formatPrice(item.price) .. " gold.", cid)
                end
            end
            talkState[cid] = nil
            return true

        elseif msgcontains(msg, "no") then
            npcHandler:say("Alright then.", cid)
            talkState[cid] = nil
            return true
        end

    else
        -- Check if the message matches any item name
        for itemName, itemData in pairs(items) do
            if msg == itemName then
                local priceText = formatPrice(itemData.price)
                npcHandler:say("Do you want to buy " .. itemName .. " for " .. priceText .. " gold?", cid)
                talkState[cid] = itemName
                return true
            end
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())