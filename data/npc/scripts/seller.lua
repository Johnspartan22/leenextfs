local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Load PaymentSystem module (adjust the path if necessary)
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Standard keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler, onlyFocus = true, text = "I own this Shop. I sell lots of goods."
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler, onlyFocus = true, text = "I am Seller."
})
keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler, onlyFocus = true, text = "It is exactly |TIME|."
})

-- Items for sale along with their prices (in gold coins)
local items = {
    rope = { id = 2120, price = 100000 },           -- 100k
    shovel = { id = 2554, price = 100000 },           -- 100k
    ["fishing rod"] = { id = 2580, price = 1000000 },-- 10M
    pick = { id = 4874, price = 10000000 },           -- 10M
    backpack = { id = 1988, price = 200000 },           -- 200k
    ["check player rune"] = { id = 2269, price = 1000000 }, -- 1M
    ["lumberjacking axe"] = { id = 2386, price = 1000000 }  -- 1M
}

-- Helper function to format the price in friendly units
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

-- Helper function to list wares (now without prices)
local function listWares(cid)
    local text = "I sell: "
    local first = true
    for name, _ in pairs(items) do
        if not first then
            text = text .. ", "
        else
            first = false
        end
        text = text .. name
    end
    npcHandler:say(text .. ".", cid)
end

-- Table to hold the talk state (the selected item) for each player (by cid)
local talkState = {}

-- Main conversation callback
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = string.lower(msg)

    if msgcontains(msg, "hi") then
        npcHandler:say("Hello " .. getCreatureName(cid) .. "! Welcome to my shop. If you'd like to see my wares, say 'wares'.", cid)
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
                        if doPlayerAddItem(cid, item.id, 1) then
                            npcHandler:say("Here is your " .. itemName .. ". I've also given you any change you were owed.", cid)
                        else
                            npcHandler:say("You don't have enough space in your inventory.", cid)
                        end
                    else
                        npcHandler:say("There was a problem processing your payment. Please try again.", cid)
                    end
                else
                    npcHandler:say("You don't have enough money.", cid)
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
        -- Check if the message matches any item name exactly.
        for itemName, itemData in pairs(items) do
            if msg == itemName then
                local priceText = formatPrice(itemData.price)
                npcHandler:say("Do you want to buy a " .. itemName .. " for " .. priceText .. " gold coins?", cid)
                talkState[cid] = itemName
                return true
            end
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())