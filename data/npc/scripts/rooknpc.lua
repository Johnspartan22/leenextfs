local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Storage keys to mark if a player has already received tutorial items
local STORAGE_FISHING = 100001
local STORAGE_MINING  = 100002

-- Greeting callback: initial greeting message
local function greetCallback(cid)
    npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Underworld. I am your guide, Boris. I can teach you about fishing and mining. If you would rather go to the mainland, go through the portal to the north.")
    npcHandler.topic[cid] = 0
    return true
end

-- Main conversation callback
function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = string.lower(msg)
    local player = Player(cid)
    if not player then return false end

    -- Initial state: topic = 0; player must choose a subject.
    if npcHandler.topic[cid] == 0 then
        if msgcontains(msg, "fishing") then
            if getPlayerStorageValue(cid, STORAGE_FISHING) == 1 then
                npcHandler:say("It appears you have already received your fishing rod. Now, go try it by the water!", cid)
                npcHandler.topic[cid] = 0
            else
                npcHandler:say("Fishing is a delicate art. Would you like me to teach you the art of fishing? (yes/no)", cid)
                npcHandler.topic[cid] = 1
            end
            return true
        elseif msgcontains(msg, "mining") then
            if getPlayerStorageValue(cid, STORAGE_MINING) == 1 then
                npcHandler:say("You already possess a pickaxe. Now go find some ore veins!", cid)
                npcHandler.topic[cid] = 0
            else
                npcHandler:say("Mining offers treasures hidden within the earth. Would you like to learn about mining? (yes/no)", cid)
                npcHandler.topic[cid] = 2
            end
            return true
        elseif msgcontains(msg, "mainland") then
            npcHandler:say("Very well, mortal. Follow the portal to the north to reach the mainland.", cid)
            npcHandler:releaseFocus(cid)
            return true
        else
            npcHandler:say("I can teach you about fishing or mining. Which would you like?", cid)
            return true
        end

    -- Fishing branch: state 1
    elseif npcHandler.topic[cid] == 1 then
        if msgcontains(msg, "yes") then
            -- Prevent giving duplicate rod even if they dropped it.
            if getPlayerStorageValue(cid, STORAGE_FISHING) ~= 1 then
                doPlayerAddItem(cid, 4369, 1)  -- Give Fishing Rod (ID 4369)
                doPlayerAddItem(cid, 3976, 50)   -- Give 50 units of bait (ID 3976)
                setPlayerStorageValue(cid, STORAGE_FISHING, 1)
            end
            doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
            npcHandler:say("Take this fishing rod and these baits. Now, go to the water to the southwest and cast your line. Patience is key in fishing... now go fish!", cid)
            npcHandler.topic[cid] = 0
            return true
        elseif msgcontains(msg, "no") then
            npcHandler:say("Very well. Would you prefer to learn about mining instead?", cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say("Please answer 'yes' if you wish to learn fishing, or 'no' if not.", cid)
            return true
        end

    -- Mining branch: state 2
    elseif npcHandler.topic[cid] == 2 then
        if msgcontains(msg, "yes") then
            if getPlayerStorageValue(cid, STORAGE_MINING) ~= 1 then
                doPlayerAddItem(cid, 4874, 1)  -- Give Pickaxe (ID 4874)
                setPlayerStorageValue(cid, STORAGE_MINING, 1)
            end
            doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
            npcHandler:say("Take this pickaxe. Now, venture east to find rocky ore veins and use your pickaxe to mine them. Each strike brings you closer to hidden treasures.", cid)
            npcHandler.topic[cid] = 0
            return true
        elseif msgcontains(msg, "no") then
            npcHandler:say("Very well. If you change your mind about mining, just let me know.", cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say("Please answer 'yes' if you wish to learn mining, or 'no' if not.", cid)
            return true
        end
    end

    return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())