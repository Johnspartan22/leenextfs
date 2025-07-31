DUNGEON_ACTIVE_PREFIX = 91000

local function getActiveStorage(playerId, dungeonId, dungeonSpecificId)
    return DUNGEON_ACTIVE_PREFIX + playerId + dungeonId + string.byte(dungeonSpecificId)
end

local KEY_DESTINATIONS = {
    [2086] = {
        position = Position(137, 77, 7),
        text = "Im outta here! Chaos City Here I come"
    },
    [2092] = {
        position = Position(743, 121, 7),
        text = "Im outta here! OB Hallz Here I come"
    },
    [2089] = {
        position = Position(479, 81, 7),
        text = "Im outta here! Ancient City Here I come"
    },
    [2091] = {
        position = Position(126, 337, 8),
        text = "Im outta here! Battle Grounds Here I come"
    },
    [2087] = {
        position = Position(144, 193, 7),
        text = "Im outta here! Garden Grove Here I come"
    },
    [2088] = {
        position = Position(286, 53, 7),
        text = "Im outta here! Iceland Here I come"
    },
    [2090] = {
        position = Position(486, 290, 7),
        text = "Im outta here! Golgotha Here I come"
    }
}

function useKeyOfPower(player, keyId)
    if not player then return false end
    
    local keyData = KEY_DESTINATIONS[keyId]
    if not keyData then return false end
    
    local playerId = player:getId()
    
    -- Check for active dungeons using the same storage system as your dungeon script
    local dungeonRanks = {
        {id = 2176, dungeons = {"E1", "E2"}},
        {id = 2177, dungeons = {"D1", "D2"}},
        {id = 2178, dungeons = {"C1", "C2"}}
    }

    for _, rank in ipairs(dungeonRanks) do
        for _, dungeonId in ipairs(rank.dungeons) do
            local isActive = player:getStorageValue(getActiveStorage(playerId, rank.id, dungeonId))
            if isActive == 1 then
                player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cannot use keys while in a dungeon!")
                return false
            end
        end
    end
    
    -- If no active dungeon, proceed with normal key functionality
    player:say(keyData.text, TALKTYPE_SAY)
    
    local playerPos = player:getPosition()
    playerPos:sendMagicEffect(13)
    player:teleportTo(keyData.position)
    keyData.position:sendMagicEffect(11)
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have used a key of power.")
    
    return true
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    return useKeyOfPower(player, item.itemid)
end