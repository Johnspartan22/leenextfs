local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink()
    npcHandler:onThink()
end

-- Load PaymentSystem module (adjust path if necessary)
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Standard keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can help you broadcast messages to all players."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am Shanti."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is exactly |TIME|."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "To broadcast a message, say 'broadcast', then type your message. It costs 3 million gold coins."})

-- Global variable to store conversation state
local talkState = 0

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = string.lower(msg)

    if msgcontains(msg, 'broadcast') then
        npcHandler:say('Broadcasting a message costs 3 million gold coins. Please type the message you want to broadcast.', cid)
        talkState = 1
        return true

    elseif talkState == 1 then
        if msg ~= '' then
            local messageToBroadcast = "Shanti '" .. getPlayerName(cid) .. "': " .. msg
            if PaymentSystem.canPlayerPay(cid, 3000000) then
                if PaymentSystem.processPayment(cid, 3000000) then
                    broadcastMessage(messageToBroadcast)
                    npcHandler:say('Your message has been broadcasted.', cid)
                else
                    npcHandler:say('There was an error processing your payment.', cid)
                end
            else
                npcHandler:say('You do not have enough money.', cid)
            end
        else
            npcHandler:say('You did not provide a message.', cid)
        end
        talkState = 0
        return true
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())