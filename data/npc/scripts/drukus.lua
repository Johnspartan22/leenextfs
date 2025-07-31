local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Greet callback: you can customize this if you want extra logic before focusing the player.
local function greetCallback(cid)
    -- You can check if the player is in range if needed.
    npcHandler.topic[cid] = 0  -- initialize conversation topic for this player
    return true
end

-- Main conversation callback using the new style and state storage.
local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    msg = msg:lower()
    local player = Player(cid)
    if not player then
        return false
    end

    -- In state 0 we check for keywords.
    if npcHandler.topic[cid] == 0 then
        if msgcontains(msg, "rock") or msgcontains(msg, "stone") then
            npcHandler:say("Aye, the rocks speak to those who listen carefully!", cid)
            npcHandler.topic[cid] = 0
            return true
        elseif msgcontains(msg, "help") then
            npcHandler:say("I can only speak of the stones and the ways of nature, mortal.", cid)
            npcHandler.topic[cid] = 0
            return true
        elseif msgcontains(msg, "bye") or msgcontains(msg, "goodbye") then
            npcHandler:say("Farewell, adventurer.", cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = nil
            return true
        else
            -- Default response if nothing specific is caught.
            npcHandler:say("Speak plainly, mortal. Say 'rock' if you wish to hear the stone's tale, or 'help' if you are lost.", cid)
            return true
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())