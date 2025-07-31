-- In lib.lua or a new keys.lua file
local KEY_DESTINATIONS = {
    [2086] = { -- Replace with your actual key IDs
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
    [2090] = { -- Added Golgotha key
        position = Position(486, 290, 7),
        text = "Im outta here! Golgotha Here I come"
    }
}

function useKeyOfPower(player, keyId)
    if not player then return false end
    
    local keyData = KEY_DESTINATIONS[keyId]
    if not keyData then return false end
    
    local playerId = player:getId()
    
    -- Check for active dungeons
    local dungeonIds = {2176, 2177} -- E and D rank dungeons
    for _, dungeonId in ipairs(dungeonIds) do
        local isActive = player:getStorageValue(DUNGEON_ACTIVE_PREFIX + playerId + dungeonId)
        if isActive == 1 then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cannot key out of the dungeon.")
            return false
        end
    end
    
    -- If no active dungeon, proceed with normal key functionality
    player:say(keyData.text, TALKTYPE_SAY)
    
    -- Get player's current position and teleport
    local playerPos = player:getPosition()
    playerPos:sendMagicEffect(13)
    player:teleportTo(keyData.position)
    keyData.position:sendMagicEffect(11)
    
    -- Send confirmation message
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have used a key of power.")
    
    return true
end

-- Then in each key script, you would just need this:
function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    return useKeyOfPower(player, item.itemid)
end