local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Load the PaymentSystem from its location.
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

function onCreatureAppear(cid)
    npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
    npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
    npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
    npcHandler:onThink()
end

-- Travel function using PaymentSystem instead of direct money removal.
local function travel(cid, message, keywords, parameters, node)
    local player = Player(cid)
    if not player then
        return false
    end

    if not npcHandler:isFocused(cid) then
        return false
    end

    if parameters.cost > 0 then
        -- Check if the player can pay the travel cost using PaymentSystem.
        if not PaymentSystem.canPlayerPay(cid, parameters.cost) then
            npcHandler:say("You don't have enough funds.", cid)
            return false
        end
        -- Process the payment. This will take coins and/or item currency and return change if needed.
        if not PaymentSystem.processPayment(cid, parameters.cost) then
            npcHandler:say("There was a problem processing your payment.", cid)
            return false
        end
    end

    player:teleportTo(parameters.pos)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    npcHandler:say("Have a nice trip!", cid)
    return true
end

-- Travel destinations
local destinations = {
    ["garden grove"] = {
        cost = 170,
        pos = Position(113, 210, 7),
        text = "Do you want to go to GG for 170 gold coins?"
    },
    ["ancient city"] = {
        cost = 130,
        pos = Position(500, 198, 6),
        text = "Do you want to go to AC for 130 gold coins?"
    },
    ["iceland"] = {
        cost = 90,
        pos = Position(287, 57, 7),
        text = "Do you want to go to Iceland for 90 gold coins?"
    },
    ["nyssport"] = {
        cost = 150,
        pos = Position(1723, 897, 6),
        text = "Do you want to go to Nyssport for 150 gold coins?"
    },
    ["chaos"] = {
        cost = 120,
        pos = Position(205, 51, 6),
        text = "Do you want to go to Chaos City for 120 gold coins?"
    }
}

-- Add travel keywords
for destination, info in pairs(destinations) do
    local travelNode = keywordHandler:addKeyword({destination}, StdModule.say, {
        npcHandler = npcHandler,
        text = info.text
    })
    
    travelNode:addChildKeyword({'yes'}, travel, {
        npcHandler = npcHandler,
        cost = info.cost,
        pos = info.pos
    })
    
    travelNode:addChildKeyword({'no'}, StdModule.say, {
        npcHandler = npcHandler,
        text = "Maybe another time.",
        reset = true
    })
end

-- Basic keywords
keywordHandler:addKeyword({'passage'}, StdModule.say, {
    npcHandler = npcHandler,
    text = "I can take you to {GG}, {AC}, {Iceland}, {Nyssport}, or {Chaos City}."
})

keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    text = "I am the captain of this ship."
})

keywordHandler:addKeyword({'captain'}, StdModule.say, {
    npcHandler = npcHandler,
    text = "I am the captain of this ship."
})

-- Greeting and farewell messages
npcHandler:setMessage(MESSAGE_GREET, "Welcome aboard, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:addModule(FocusModule:new())