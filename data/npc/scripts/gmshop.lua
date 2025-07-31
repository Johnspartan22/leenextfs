local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Declare talkState table at the top
local talkState = {}

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end
function onFocusLost(cid)           
    if talkState[cid] then
        talkState[cid] = nil
    end
end

-- Load PaymentSystem module
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Standard keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am the GM shop keeper. I can increase your health or mana for a price."
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am the Health and Mana Master."
})
keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "It is exactly |TIME|."
})

-- Base price per point
local basePricePerPoint = 10000 -- 10k gold per point

-- Table to hold the talk state for each player
local talkState = {}

-- Helper function to format the price in friendly units
local function formatPrice(value)
    if value >= 1000000000 then
        return string.format("%d billion", value / 1000000000)
    elseif value >= 1000000 then
        return string.format("%d million", value / 1000000)
    else
        return string.format("%d thousand", value / 1000)
    end
end

-- Helper function to format large numbers with commas
local function formatNumber(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Function to parse amount from message
local function parseAmount(msg)
    -- Check for "k" or "m" multipliers
    local amount = 0
    
    -- Try to match patterns like "500k" or "1m" or "1 million"
    local baseNumber, multiplier = msg:match("(%d+)%s*([km])")
    
    if baseNumber and multiplier then
        baseNumber = tonumber(baseNumber)
        if multiplier == "k" then
            amount = baseNumber * 1000
        elseif multiplier == "m" then
            amount = baseNumber * 1000000
        end
    else
        -- Check for explicit "million" or "thousand"
        baseNumber, multiplier = msg:match("(%d+)%s*([mt][hi][lo][lu][is][oa][nn]*d*)")
        
        if baseNumber and multiplier then
            baseNumber = tonumber(baseNumber)
            if multiplier:sub(1,1) == "m" then
                amount = baseNumber * 1000000
            elseif multiplier:sub(1,1) == "t" then
                amount = baseNumber * 1000
            end
        else
            -- Check for just a number
            amount = tonumber(msg:match("%d+"))
        end
    end
    
    if amount and amount > 0 then
        return amount
    end
    
    return nil
end

-- Main conversation callback
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        talkState[cid] = nil
        return false
    end

    if not msg then
        talkState[cid] = nil
        return false
    end

    msg = string.lower(msg)

    -- Reset command
    if msgcontains(msg, "reset") then
        talkState[cid] = nil
        npcHandler:say("Our conversation has been reset. How can I help you?", cid)
        return true
    end

    if msgcontains(msg, "hi") or msgcontains(msg, "hello") then
        npcHandler:say("Hiho " .. getCreatureName(cid) .. "! Welcome to the GM shop, here you can buy more hp or mana. Tell me how much you want, like '100k hp' or '1m mana'.", cid)
        talkState[cid] = nil
        return true

    elseif msgcontains(msg, "bye") or msgcontains(msg, "goodbye") then
        npcHandler:say("Good bye, " .. getCreatureName(cid) .. "!", cid)
        npcHandler:releaseFocus(cid)
        talkState[cid] = nil
        return true
    
    -- If a purchase is in confirmation stage
    elseif talkState[cid] then
        if msgcontains(msg, "yes") then
            local upgrade = talkState[cid]
            local amount = upgrade.amount
            local type = upgrade.type
            local price = amount * basePricePerPoint
            
            if PaymentSystem.canPlayerPay(cid, price) then
                if PaymentSystem.processPayment(cid, price) then
                    local player = Player(cid)
                    
                    if type == "hp" or type == "health" then
                        player:setMaxHealth(player:getMaxHealth() + amount)
                        player:addHealth(amount)
                        npcHandler:say("Your maximum health has been increased by " .. formatNumber(amount) .. " points!", cid)
                    elseif type == "mana" then
                        player:setMaxMana(player:getMaxMana() + amount)
                        player:addMana(amount)
                        npcHandler:say("Your maximum mana has been increased by " .. formatNumber(amount) .. " points!", cid)
                    end
                else
                    npcHandler:say("There was a problem processing your payment. Please try again.", cid)
                end
            else
                npcHandler:say("You don't have enough money. You need " .. formatPrice(price) .. " gold coins.", cid)
            end
            talkState[cid] = nil
            return true

        elseif msgcontains(msg, "no") then
            npcHandler:say("Alright then, come back when you're ready.", cid)
            talkState[cid] = nil
            return true
        end
    
    else
        -- Check for hp/health/mana in the message
        local type = nil
        if msgcontains(msg, "hp") or msgcontains(msg, "health") then
            type = "hp"
        elseif msgcontains(msg, "mana") then
            type = "mana"
        end
        
        if type then
            local amount = parseAmount(msg)
            
            if amount then
                local price = amount * basePricePerPoint
                
                npcHandler:say("Do you want to increase your " .. (type == "hp" and "health" or type) .. 
                              " by " .. formatNumber(amount) .. " points for " .. 
                              formatPrice(price) .. " gold coins?", cid)
                
                talkState[cid] = {amount = amount, type = type}
                return true
            else
                -- Default amount if no specific amount was given
                local defaultAmount = 100
                local price = defaultAmount * basePricePerPoint
                
                npcHandler:say("You didn't specify an amount. Do you want to increase your " .. 
                              (type == "hp" and "health" or type) .. 
                              " by " .. defaultAmount .. " points for " .. 
                              formatPrice(price) .. " gold coins? Or tell me a specific amount like '100k " .. 
                              type .. "' or '1m " .. type .."'.", cid)
                
                talkState[cid] = {amount = defaultAmount, type = type}
                return true
            end
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onFocusLost)
npcHandler:addModule(FocusModule:new())