local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Load PaymentSystem module (adjust path if necessary)
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I own this Shop. I sell Bows, Crossbows, Arrows, and Bolts."
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am Perac."
})
keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "It is exactly |TIME|."
})

-- Items available for sale. For items sold in fixed quantities (e.g. arrows, bolts), 'count' is defined.
local items = {
    bow = {id = 2456, price = 15000000},         -- 15 million
    crossbow = {id = 2455, price = 25000000},      -- 25 million
    arrow = {id = 2544, price = 3000000, count = 100},   -- 3 million for 100
    bolt = {id = 2543, price = 6000000, count = 100},    -- 6 million for 100
    power = {id = 2547, price = 12000000, count = 100}   -- 12 million for 100 power bolts
}

-- Helper function to format price. If the price is an exact multiple of one million, it shows "10 million".
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

-- We'll use a per-cid talkState to store the currently selected item.
local talkState = {}

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = string.lower(msg)

    if msgcontains(msg, 'hi') then
        npcHandler:say('Welcome ' .. getCreatureName(cid) .. '! What can I do for you?', cid)
        talkState[cid] = nil

    elseif msgcontains(msg, 'bye') then
        npcHandler:say('Good bye, ' .. getCreatureName(cid) .. '!', cid)
        npcHandler:releaseFocus(cid)
        talkState[cid] = nil

    else
        -- Loop through our items table and check if the message contains one of our item names.
        for item_name, item_data in pairs(items) do
            if msgcontains(msg, item_name) then
                local price_text = formatPrice(item_data.price)
                local quantity_text = item_data.count and string.format("%d ", item_data.count) or "a "
                npcHandler:say(string.format('Do you want to buy %s%s for %s gold coins?', quantity_text, item_name, price_text), cid)
                talkState[cid] = item_name
                return true
            end
        end

        -- Confirmation branch: if the player already selected an item.
        if talkState[cid] and msgcontains(msg, 'yes') then
            local selected = items[talkState[cid]]
            if selected then
                local count = selected.count or 1
                if PaymentSystem.canPlayerPay(cid, selected.price) then
                    -- Process payment first – funds are deducted as defined by your PaymentSystem.
                    if PaymentSystem.processPayment(cid, selected.price) then
                        if doPlayerAddItem(cid, selected.id, count) then
                            npcHandler:say('Here you are.', cid)
                        else
                            npcHandler:say("Sorry, you don't have enough space in your inventory.", cid)
                        end
                    else
                        npcHandler:say('There was an error processing your payment. Please try again.', cid)
                    end
                else
                    npcHandler:say("You don't have enough money.", cid)
                end
            end
            talkState[cid] = nil
            return true
        end
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())