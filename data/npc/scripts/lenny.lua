local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions 
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)    end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()               end

-- Load PaymentSystem module (adjust the path if necessary)
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Standard responses for common keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I run the Outfit Lottery."
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am Lucky Lenny."
})
keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "It is exactly |TIME|."
})

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
    
    if msgcontains(msg, 'hi') then
        npcHandler:say('Hello ' .. getCreatureName(cid) .. '! I run the Outfit Lottery.', cid)
        npcHandler.focus = cid
        npcHandler.topic[cid] = 0

    elseif msgcontains(msg, 'bye') then
        npcHandler:say('Good bye, ' .. getCreatureName(cid) .. '!', cid)
        npcHandler.focus = 0
        npcHandler.topic[cid] = nil

    elseif msgcontains(msg, 'ticket') then
        -- The purchase branch: supports "ticket" or "lottery ticket"
        local ticketData = { id = 4845, price = 300000000 }
        
        -- Debug message (optional):
        npcHandler:say("Let me check your funds for a lottery ticket...", cid)
        
        if PaymentSystem.canPlayerPay(cid, ticketData.price) then
            -- Process the payment BEFORE awarding the ticket.
            if PaymentSystem.processPayment(cid, ticketData.price) then
                if doPlayerAddItem(cid, ticketData.id, 1) then
                    npcHandler:say("Here is your lottery ticket. Good luck!", cid)
                else
                    npcHandler:say("You don't have enough space in your inventory.", cid)
                    -- Optional: Refund the payment here if necessary.
                end
            else
                npcHandler:say("There was a problem processing your payment.", cid)
            end
        else
            npcHandler:say("You do not have enough funds.", cid)
        end
        
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())