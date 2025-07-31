-- Define the tracker ranks and their corresponding trackable portal IDs
local trackerConfig = {
    -- Each key is the tracker item ID, and the value is a table of portal IDs it can track
    [2129] = {2176},                         -- E rank tracker: tracks only E rank portal
    [2127] = {2176, 2177},                   -- D rank tracker: tracks E and D rank portals
    [2126] = {2176, 2177, 2178},             -- C rank tracker: tracks E, D, and C rank portals
    [2125] = {2176, 2177, 2178, 2179},       -- B rank tracker: tracks E, D, C, and B rank portals
    [2124] = {2176, 2177, 2178, 2179, 2180}, -- A rank tracker: tracks E, D, C, B, and A rank portals
    [2123] = {2176, 2177, 2178, 2179, 2180, 2181} -- S rank tracker: tracks all portals
}

-- Portal rank names for better messages
local portalRankNames = {
    [2176] = "E",
    [2177] = "D",
    [2178] = "C",
    [2179] = "B",
    [2180] = "A",
    [2181] = "S"
}

-- Cooldown storage
local COOLDOWN_STORAGE = 34921  -- Choose a unique storage value
local COOLDOWN_TIME = 5  -- Cooldown in seconds

function getDirectionTo(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    
    -- Calculate direction (fixed north/south for Tibia coordinate system)
    if dx == 0 and dy < 0 then return "south"
    elseif dx == 0 and dy > 0 then return "north"
    elseif dx > 0 and dy == 0 then return "west"
    elseif dx < 0 and dy == 0 then return "east"
    elseif dx > 0 and dy < 0 then return "south-west"
    elseif dx < 0 and dy < 0 then return "south-east"
    elseif dx > 0 and dy > 0 then return "north-west"
    elseif dx < 0 and dy > 0 then return "north-east"
    end
    return ""
end

function getDistance(pos1, pos2)
    local dx = math.abs(pos1.x - pos2.x)
    local dy = math.abs(pos1.y - pos2.y)
    local distance = math.sqrt(dx * dx + dy * dy)
    
    if distance < 4 then
        return "beside"
    elseif distance < 100 then
        return "close"
    elseif distance < 274 then
        return "far"
    else
        return "very far"
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Check cooldown
    local currentTime = os.time()
    local lastUseTime = player:getStorageValue(COOLDOWN_STORAGE)
    
    if lastUseTime > 0 and currentTime - lastUseTime < COOLDOWN_TIME then
        local remainingTime = COOLDOWN_TIME - (currentTime - lastUseTime)
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Your tracker is recharging. Please wait %d seconds.", remainingTime))
        return false
    end
    
    -- Get the tracker ID to determine which portals to track
    local trackerId = item:getId()
    
    -- Check if this is a valid tracker
    if not trackerConfig[trackerId] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "This item is not a valid tracker.")
        return false
    end
    
    -- Get the list of portal IDs this tracker can find
    local trackablePortalIds = trackerConfig[trackerId]
    
    -- Get player's position
    local playerPos = player:getPosition()
    
    -- Find the nearest trackable portal
    local foundPortal = nil
    local foundPos = nil
    local foundPortalId = nil
    local minDistance = math.huge
    
    -- Search in a radius and include multiple floors
    local searchRadius = 274
    local zRange = 2  -- Search 2 floors up and down
    
    for z = -zRange, zRange do
        local searchZ = playerPos.z + z
        if searchZ >= 0 and searchZ <= 15 then  -- Validate z range (0-15 is typical in Tibia)
            for x = -searchRadius, searchRadius do
                for y = -searchRadius, searchRadius do
                    local searchPos = Position(playerPos.x + x, playerPos.y + y, searchZ)
                    local tile = Tile(searchPos)
                    
                    if tile then
                        local items = tile:getItems()
                        if items then
                            for i = 1, #items do
                                local currentItem = items[i]
                                if currentItem then
                                    local currentItemId = currentItem:getId()
                                    -- Check if this item ID is in our list of trackable portals
                                    for _, portalId in ipairs(trackablePortalIds) do
                                        if currentItemId == portalId then
                                            -- Calculate 3D distance (including z-factor)
                                            local distance = math.max(math.abs(x), math.abs(y)) + (math.abs(z) * 25)  -- Z difference counts more
                                            if distance < minDistance then
                                                minDistance = distance
                                                foundPortal = currentItem
                                                foundPos = searchPos
                                                foundPortalId = portalId
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Set cooldown after search (regardless of result)
    player:setStorageValue(COOLDOWN_STORAGE, currentTime)
    
    -- If portal was found, send direction message
    if foundPortal then
        local distance = getDistance(playerPos, foundPos)
        local direction = getDirectionTo(playerPos, foundPos)
        local portalRank = portalRankNames[foundPortalId] or "Unknown"
        local message = ""
        
        -- Check if on different floor
        if foundPos.z < playerPos.z then
            message = string.format("An %s rank portal is on a higher level", portalRank)
        elseif foundPos.z > playerPos.z then
            message = string.format("An %s rank portal is on a lower level", portalRank)
        else
            if distance == "beside" then
                message = string.format("An %s rank portal is next to you", portalRank)
            else
                message = string.format("An %s rank portal is %s to the %s", portalRank, distance, direction)
            end
        end
        
        player:sendTextMessage(MESSAGE_INFO_DESCR, message)
        Position(playerPos):sendMagicEffect(CONST_ME_MAGIC_GREEN)
        return true
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "No portals in range.")
        Position(playerPos):sendMagicEffect(CONST_ME_POFF)
        return true
    end
end