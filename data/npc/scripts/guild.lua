local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Initialize talkState table
npcHandler.talkState = {}

-- OTServ event handling functions
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Storage values
local questStorage = 546789 -- Change this storage value as needed
local questProgressStorage = 567843 -- Storage for tracking quest progress
local guildrepstorage = 554325 -- Storage for tracking guild reputation

-- Quest requirements and rewards
local questRequirements = {
    -- Quest 3 (E Rank)
    [5] = {essence = 25, certificate = 2329, rank = "E", previousReward = 2129}, -- Ruby necklace from initial quest
    -- Quest 4 (D Rank)
    [7] = {essence = 50, certificate = 2329, rank = "D", previousReward = 2127}, -- E rank reward
    -- Quest 5 (C Rank)
    [9] = {essence = 100, certificate = 2329, rank = "C", previousReward = 2126}, -- D rank reward
    -- Quest 6 (B Rank)
    [11] = {essence = 200, certificate = 2329, rank = "B", previousReward = 2124}, -- C rank reward
    -- Quest 7 (A Rank)
    [13] = {essence = 500, certificate = 2329, rank = "A", previousReward = 2125} -- B rank reward
}

-- Quest rewards
local questRewards = {
    -- Quest 3 (E Rank)
    [5] = {exp = 5000, item = 2127, itemCount = 1, repIncrease = 50, name = "E Rank Token"},
    -- Quest 4 (D Rank)
    [7] = {exp = 10000, item = 2126, itemCount = 1, repIncrease = 100, name = "C Rank Token"},
    -- Quest 5 (C Rank)
    [9] = {exp = 20000, item = 2124, itemCount = 1, repIncrease = 150, name = "B Rank Token"},
    -- Quest 6 (B Rank)
    [11] = {exp = 40000, item = 2125, itemCount = 1, repIncrease = 200, name = "A Rank Token"},
    -- Quest 7 (A Rank)
    [13] = {exp = 80000, item = 2122, itemCount = 1, repIncrease = 300, name = "S Rank Token"}
}

-- Basic keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I work for the Adventurer's Guild. I offer quests and give out rewards."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am Aldric."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is exactly |TIME|."})

-- Function to handle the quest
local function questCallback(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    
    -- Initialize talkState for this player if needed
    if npcHandler.talkState[cid] == nil then
        npcHandler.talkState[cid] = 0
    end
    
    local questProgress = getPlayerStorageValue(cid, questProgressStorage)
    
    -- Initial quests (unchanged)
    if questProgress < 1 then
        npcHandler:say('Ah, so you want to become an adventurer? First, you must prove yourself capable. Bring me a magic stone from a gazer.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 1)
    elseif questProgress == 1 then
        npcHandler:say('Did you bring me the magic stone?', cid)
        npcHandler.talkState[cid] = 1
    elseif questProgress == 2 then
        npcHandler:say('Good work with the magic stone. Now I have a more serious task. One of our guild members went missing while investigating a cave to the north. I need you to find evidence of what happened to him. His name is Gareth.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 3)
    elseif questProgress == 3 then
        npcHandler:say('Have you found any evidence of Gareth in the northern cave?', cid)
        npcHandler.talkState[cid] = 2
    
    -- New quests start here
    elseif questProgress == 4 then
        npcHandler:say('Now that you\'re a member of the guild, it\'s time to prove your worth. Bring me 25 Underworld Essence, a certificate of completion from an E rank dungeon, and your guild token.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 5)
    elseif questProgress == 5 then
        npcHandler:say('Have you brought the 25 Underworld Essence, the E rank dungeon certificate, and your guild token?', cid)
        npcHandler.talkState[cid] = 3
    elseif questProgress == 6 then
        npcHandler:say('Well done on the E rank dungeon. Now I need you to tackle a D rank dungeon. Bring me 50 Underworld Essence, a certificate of completion from a D rank dungeon, and your D Rank Token.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 7)
    elseif questProgress == 7 then
        npcHandler:say('Have you brought the 50 Underworld Essence, the D rank dungeon certificate, and your D Rank Token?', cid)
        npcHandler.talkState[cid] = 4
    elseif questProgress == 8 then
        npcHandler:say('Impressive work on the D rank dungeon. Let\'s see if you can handle a C rank dungeon. Bring me 100 Underworld Essence, a certificate of completion from a C rank dungeon, and your C Rank Token.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 9)
    elseif questProgress == 9 then
        npcHandler:say('Have you brought the 100 Underworld Essence, the C rank dungeon certificate, and your C Rank Token?', cid)
        npcHandler.talkState[cid] = 5
    elseif questProgress == 10 then
        npcHandler:say('You\'re proving to be quite capable. Now for a real challenge - a B rank dungeon. Bring me 200 Underworld Essence, a certificate of completion from a B rank dungeon, and your B Rank Token.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 11)
    elseif questProgress == 11 then
        npcHandler:say('Have you brought the 200 Underworld Essence, the B rank dungeon certificate, and your B Rank Token?', cid)
        npcHandler.talkState[cid] = 6
    elseif questProgress == 12 then
        npcHandler:say('Outstanding! You\'re among our elite members now. Let\'s see if you can conquer an A rank dungeon. Bring me 500 Underworld Essence, a certificate of completion from an A rank dungeon, and your A Rank Token.', cid)
        setPlayerStorageValue(cid, questProgressStorage, 13)
    elseif questProgress == 13 then
        npcHandler:say('Have you brought the 500 Underworld Essence, the A rank dungeon certificate, and your A Rank Token?', cid)
        npcHandler.talkState[cid] = 7
    elseif questProgress == 14 then
        npcHandler:say('You have completed all challenges and proven yourself to be one of the greatest adventurers in our guild\'s history. I have no more tasks for you, but the world is full of adventures waiting to be had.', cid)
    end
    return true
end

-- Register the quest keyword
keywordHandler:addKeyword({'quest'}, questCallback, {})
keywordHandler:addKeyword({'mission'}, questCallback, {}) -- Alternative keyword

local function yesCallback(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    
    -- Initialize talkState for this player if needed
    if npcHandler.talkState[cid] == nil then
        npcHandler.talkState[cid] = 0
    end
    
    -- Original quests
    if npcHandler.talkState[cid] == 1 then
        if doPlayerRemoveItem(cid, 4393, 1) then -- Magic stone
            npcHandler:say('Well done. You\'ve passed the first test. I have another task for you. Say "quest" to learn more.', cid)
            setPlayerStorageValue(cid, questProgressStorage, 2)
            doPlayerAddExp(cid, 1000)
        else
            npcHandler:say('You don\'t have a magic stone. Come back when you have one.', cid)
        end
        npcHandler.talkState[cid] = 0
        return true
    elseif npcHandler.talkState[cid] == 2 then
        if doPlayerRemoveItem(cid, 2128, 1) then -- Gareth's evidence
            doPlayerAddItem(cid, 2129, 1) -- Ruby necklace (guild token)
            setPlayerStorageValue(cid, questStorage, 1)
            setPlayerStorageValue(cid, questProgressStorage, 4)
            setPlayerStorageValue(cid, guildrepstorage, 100)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have joined the Adventurers Guild.")
            doPlayerAddExp(cid, 2000)
            
            npcHandler:say('This confirms our worst fears. Poor Gareth... Your bravery and dedication have proven you worthy. You are now officially a member of the Adventurer\'s Guild. Take this guild token as a symbol of your membership. I have more tasks for you if you\'re interested.', cid)
        else
            npcHandler:say('You haven\'t found any evidence yet. The northern cave is dangerous, but we need to know what happened to Gareth.', cid)
        end
        npcHandler.talkState[cid] = 0
        return true
    
    -- New quests
    elseif npcHandler.talkState[cid] >= 3 and npcHandler.talkState[cid] <= 7 then
        local questStage = (npcHandler.talkState[cid] - 3) * 2 + 5 -- Maps talkState 3-7 to questProgress 5,7,9,11,13
        local req = questRequirements[questStage]
        local reward = questRewards[questStage]
        
        -- Check if player has the required items including previous reward
        if doPlayerRemoveItem(cid, 4313, req.essence) and 
           doPlayerRemoveItem(cid, req.certificate, 1) and 
           doPlayerRemoveItem(cid, req.previousReward, 1) then
            
            -- Give rewards
            doPlayerAddItem(cid, reward.item, reward.itemCount)
            setPlayerStorageValue(cid, questProgressStorage, questStage + 1)
            local currentRep = getPlayerStorageValue(cid, guildrepstorage)
            setPlayerStorageValue(cid, guildrepstorage, currentRep + reward.repIncrease)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your reputation with the Adventurer's Guild has increased!")
            doPlayerAddExp(cid, reward.exp)
            
            if questStage == 13 then -- A rank is the final quest
                npcHandler:say('Extraordinary! You\'ve conquered the A rank dungeon and proven yourself to be one of our most elite members. Your reputation in the guild has reached its peak. You have completed all my tasks and earned your place among the greatest adventurers. Take this A Rank Medal as proof of your accomplishment.', cid)
            else
                npcHandler:say('Excellent work! You\'ve proven your skill in the ' .. req.rank .. ' rank dungeon. Your reputation in the guild has increased, and here\'s your ' .. reward.name .. '. Keep it safe, as you\'ll need it for your next assignment.', cid)
            end
        else
            npcHandler:say('You don\'t have all the required items. I need ' .. req.essence .. ' Underworld Essence, a certificate from a ' .. req.rank .. ' rank dungeon, and your previous rank medal.', cid)
        end
        npcHandler.talkState[cid] = 0
        return true
    end
    
    return false
end

-- Register yes response
keywordHandler:addKeyword({'yes'}, yesCallback, {})

-- Add no callback
local function noCallback(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    
    -- Initialize talkState for this player if needed
    if npcHandler.talkState[cid] == nil then
        npcHandler.talkState[cid] = 0
    end
    
    if npcHandler.talkState[cid] >= 1 and npcHandler.talkState[cid] <= 7 then
        npcHandler:say('Come back when you\'re ready to help the guild.', cid)
        npcHandler.talkState[cid] = 0
        return true
    end
    return false
end

-- Register no response
keywordHandler:addKeyword({'no'}, noCallback, {})

function creatureSayCallback(cid, type, msg)
    -- Initialize talk state if needed
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    
    -- Initialize talkState for this player if needed
    if npcHandler.talkState[cid] == nil then
        npcHandler.talkState[cid] = 0
    end
    
    -- Debug message to help troubleshoot
    if msgcontains(msg, 'quest') then
        npcHandler:say('You mentioned a quest. If you want to take on a quest, simply say "quest" to me.', cid)
        return true
    end
    
    return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())