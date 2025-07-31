local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Global talkState for the current token selection
local talkState = nil

-- Tokens available for sale (prices in gold coins)
local tokens = {
    ['5'] = { id = 2274, cost = 5000000 },      -- 5 million token
    ['10'] = { id = 2275, cost = 10000000 },    -- 10 million token
    ['20'] = { id = 2276, cost = 20000000 },    -- 20 million token
    ['30'] = { id = 2270, cost = 30000000 },    -- 30 million token
    ['50'] = { id = 2280, cost = 50000000 },    -- 50 million token
    ['100'] = { id = 2281, cost = 100000000 }   -- 100 million token
}

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Load PaymentSystem module (adjust path as necessary)
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Helper function: formats large numbers.
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

-- Register standard keywords.
keywordHandler:addKeyword({'job'}, StdModule.say, { 
    npcHandler = npcHandler, 
    onlyFocus = true, 
    text = "I exchange money for tokens. I accept Flawless Skulls (100kk), Chipped Skulls (1kk), and regular money." 
})
keywordHandler:addKeyword({'name'}, StdModule.say, { 
    npcHandler = npcHandler, 
    onlyFocus = true, 
    text = "I am Token Seller." 
})
keywordHandler:addKeyword({'help'}, StdModule.say, { 
    npcHandler = npcHandler, 
    onlyFocus = true, 
    text = "I sell tokens for breaking down money. I offer tokens of 5, 10, 20, 30, 50, and 100 million. Just say the number (like '5') to buy one." 
})
keywordHandler:addKeyword({'time'}, StdModule.say, { 
    npcHandler = npcHandler, 
    onlyFocus = true, 
    text = "It is |TIME|." 
})

-- Main conversation callback.
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    msg = string.lower(msg)

    if msgcontains(msg, "hi") then
        npcHandler:say("Welcome " .. getCreatureName(cid) .. "! What token would you like? You can say 5, 10, 20, 30, 50, or 100.", cid)
        talkState = nil

    elseif msgcontains(msg, "bye") then
        npcHandler:say("Good bye, " .. getCreatureName(cid) .. "!", cid)
        npcHandler:releaseFocus(cid)
        talkState = nil

    else
        -- Check if the player's message contains one of the token keys.
        for key, data in pairs(tokens) do
            if msgcontains(msg, key) then
                local price_text = formatPrice(data.cost)
                npcHandler:say("Do you want to buy a " .. key .. " million token for " .. price_text .. " gold coins?", cid)
                talkState = key  -- store the token key
                return true
            end
        end

        -- If the player is in confirmation stage.
        if talkState and msgcontains(msg, "yes") then
            local data = tokens[talkState]
            if data then
                if PaymentSystem.canPlayerPay(cid, data.cost) then
                    if PaymentSystem.processPayment(cid, data.cost) then
                        if doPlayerAddItem(cid, data.id, 1) then
                            npcHandler:say("Here is your " .. talkState .. " million token!", cid)
                        else
                            npcHandler:say("You don't have enough space in your inventory.", cid)
                        end
                    else
                        npcHandler:say("There was an error processing your payment. Please try again.", cid)
                    end
                else
                    npcHandler:say("You don't have enough money. Remember you can use Flawless Skulls, Chipped Skulls, or regular money.", cid)
                end
            end
            talkState = nil
            return true

        elseif talkState and msgcontains(msg, "no") then
            npcHandler:say("Alright then.", cid)
            talkState = nil
            return true
        end
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())