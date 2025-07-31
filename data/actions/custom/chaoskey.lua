function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if not player then return false end
    
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
    player:say("Im outta here! Chaos City Here I come", TALKTYPE_SAY)
    
    -- Get player's current position
    local playerPos = player:getPosition()
    
    -- Define temple coordinates
    local temple = Position(137, 77, 7)
    
    -- Create teleport effect at both locations
    playerPos:sendMagicEffect(13)
    player:teleportTo(temple)
    temple:sendMagicEffect(11)
    
    -- Send confirmation message to player
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have used a key of power.")
    
    return true
end