local config = {
    t = 2176, -- ITEM THAT YOU WILL USE
    p = {x=3123, y=3155, z=8}, -- WHERE THE HELL AM I GOING
    exitCoords = {x=3165, y=3158, z=9}, -- COORDINATES THAT CLEAR PLAYER FROM ACTIVE LIST
    rewardsRoom = {x=3028, y=3030, z=7}, -- COORDINATES FOR THE REWARDS ROOM
    requiredItems = {2122, 2125, 2126, 2127, 2124, 2129},
    cooldownTime = 180000, -- Cooldown time in milliseconds (3 minutes)
    portalOpenTime = 60000, -- Time until portal disappears (1 minute)
    dungeonTimeLimit = 900000  -- Time limit inside dungeon (15 minutes)
}

local playerCooldowns = {}
local portalPosition = nil
local activePlayers = {}

local function showExitEffect()
    doSendMagicEffect(config.exitCoords, 47)
    if next(activePlayers) then
        addEvent(showExitEffect, 2000)
    end
end

function removePortal()
    if portalPosition then
        local portal = getTileItemById(portalPosition, config.t)
        if portal.uid > 0 then
            doRemoveItem(portal.uid)
        end
        portalPosition = nil
    end
end

function exitDungeon(cid)
    if isPlayer(cid) and activePlayers[cid] then
        doTeleportThing(cid, {x=160, y=52, z=7})
        doSendMagicEffect({x=160, y=52, z=7}, 10)
        doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] Your time in the dungeon has expired!")
        activePlayers[cid] = nil
    end
end

function startDungeonTimer(cid)
    addEvent(function()
        exitDungeon(cid)
    end, config.dungeonTimeLimit)
    
    -- Set up position checker that runs every second
    for i = 1, config.dungeonTimeLimit/1000 do
        addEvent(function()
            if isPlayer(cid) and activePlayers[cid] then
                local pos = getPlayerPosition(cid)
                if pos.x == config.exitCoords.x and pos.y == config.exitCoords.y and pos.z == config.exitCoords.z then
                    doTeleportThing(cid, config.rewardsRoom)
                    doSendMagicEffect(config.rewardsRoom, 10)
                    activePlayers[cid] = nil
                    doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] You have exited the dungeon safely.")
                end
            end
        end, i * 1000)
    end
    
    -- Warning at 5 minutes remaining
    addEvent(function()
        if isPlayer(cid) and activePlayers[cid] then
            doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] Warning: 5 minutes remaining in dungeon!")
        end
    end, config.dungeonTimeLimit - 300000)
    
    -- Warning at 2 minutes remaining
    addEvent(function()
        if isPlayer(cid) and activePlayers[cid] then
            doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] Warning: 2 minutes remaining in dungeon!")
        end
    end, config.dungeonTimeLimit - 120000)
    
    -- Warning at 1 minute remaining
    addEvent(function()
        if isPlayer(cid) and activePlayers[cid] then
            doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] Warning: 1 minute remaining in dungeon!")
        end
    end, config.dungeonTimeLimit - 60000)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if item.itemid == config.t then
        local currentTime = os.time() * 1000
        local playerId = getPlayerGUID(cid)
        
        if not portalPosition then
            portalPosition = fromPosition
        end
        
        if playerCooldowns[playerId] and currentTime < playerCooldowns[playerId] then
            doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] You must wait before re-entering.")
            return true
        end
        
        local hasRequiredItem = false
        for _, itemId in ipairs(config.requiredItems) do
            if getPlayerItemCount(cid, itemId) > 0 then
                hasRequiredItem = true
                break
            end
        end
        
        if hasRequiredItem then
            doTeleportThing(cid, config.p)
            doSendMagicEffect(config.p, 10)
            doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] You have entered an E rank Dungeon. You have 15 minutes to complete it!")
            playerCooldowns[playerId] = currentTime + config.cooldownTime
            activePlayers[cid] = true
            
            -- Start showing the exit effect
            showExitEffect()
            
            startDungeonTimer(cid)
            
            addEvent(function()
                removePortal()
            end, config.portalOpenTime)
        else
            doPlayerSendTextMessage(cid, 18, "[DUNGEON SYSTEM] You must be at least an E rank Adventurer to enter this dungeon.")
        end
    end
    
    return true
end