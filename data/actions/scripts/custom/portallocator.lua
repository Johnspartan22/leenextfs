-- Define the tracker ranks and their corresponding trackable portal IDs
local trackerConfig = {
    -- Each key is the tracker item ID, and the value is a table of portal IDs it can track
    [2129] = {2176},                         -- E rank tracker: tracks only E rank portal
    [2127] = {2176, 2177},                   -- D rank tracker: tracks E and D rank portals
    [2126] = {2176, 2177, 2178},             -- C rank tracker: tracks E, D, and C rank portals
    [2125] = {2176, 2177, 2178, 2179},       -- B rank tracker: tracks E, D, C, and B rank portals
    [2124] = {2176, 2177, 2178, 2179, 2180}, -- A rank tracker: tracks E, D, C, B, and A rank portals
    [2122] = {2176, 2177, 2178, 2179, 2180, 2174} -- S rank tracker: tracks all portals
}

-- Portal rank names for better messages
local portalRankNames = {
    [2176] = "E",
    [2177] = "D",
    [2178] = "C",
    [2179] = "B",
    [2180] = "A",
    [2174] = "S"
}

-- Cooldown storage
local COOLDOWN_STORAGE = 34921  -- Choose a unique storage value
local COOLDOWN_TIME = 2  -- Cooldown in seconds

-- Helper functions
function getDirectionTo(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    
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

function formatPortalMessage(playerPos, portalPos, portalRank, distance, direction)
    local floorDiff = playerPos.z - portalPos.z
    local baseMsg = string.format("The %s rank portal", portalRank)
    
    if floorDiff < 0 then  -- Changed from > to <
        if distance == "beside" then
            return string.format("%s is on a lower level", baseMsg)
        else
            return string.format("%s is %s to the %s on a lower level", baseMsg, distance, direction)
        end
    elseif floorDiff > 0 then  -- Changed from < to >
        if distance == "beside" then
            return string.format("%s is on a higher level", baseMsg)
        else
            return string.format("%s is %s to the %s on a higher level", baseMsg, distance, direction)
        end
    else
        if distance == "beside" then
            return string.format("%s is right next to you", baseMsg)
        else
            return string.format("%s is %s to the %s", baseMsg, distance, direction)
        end
    end
end

function findNearestPortal(playerPos, trackablePortalIds)
    local nearestPortal = nil
    local minDistance = math.huge

    for _, portal in ipairs(ACTIVE_PORTALS) do
        for _, trackableId in ipairs(trackablePortalIds) do
            if portal.id == trackableId then
                local dx = math.abs(playerPos.x - portal.pos.x)
                local dy = math.abs(playerPos.y - portal.pos.y)
                local dz = math.abs(playerPos.z - portal.pos.z) * 15
                local distance = math.sqrt(dx * dx + dy * dy) + dz

                if distance < minDistance then
                    minDistance = distance
                    nearestPortal = portal
                end
            end
        end
    end
    
    return nearestPortal
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Cooldown check
    local currentTime = os.time()
    local lastUseTime = player:getStorageValue(COOLDOWN_STORAGE)
    
    if lastUseTime > 0 and currentTime - lastUseTime < COOLDOWN_TIME then
        local remainingTime = COOLDOWN_TIME - (currentTime - lastUseTime)
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Your tracker is recharging. Please wait %d seconds.", remainingTime))
        return false
    end

    local trackerId = item:getId()
    if not trackerConfig[trackerId] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "This item is not a valid tracker.")
        return false
    end

    local trackablePortalIds = trackerConfig[trackerId]
    local playerPos = player:getPosition()
    local nearestPortal = findNearestPortal(playerPos, trackablePortalIds)
    
    -- Set cooldown
    player:setStorageValue(COOLDOWN_STORAGE, currentTime)

    if nearestPortal then
        local distance = getDistance(playerPos, nearestPortal.pos)
        local direction = getDirectionTo(playerPos, nearestPortal.pos)
        local portalRank = portalRankNames[nearestPortal.id] or "Unknown"
        
        local message = formatPortalMessage(playerPos, nearestPortal.pos, portalRank, distance, direction)
        player:sendTextMessage(MESSAGE_INFO_DESCR, message)
        Position(playerPos):sendMagicEffect(CONST_ME_MAGIC_GREEN)
        return true
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "No portals in range.")
        Position(playerPos):sendMagicEffect(CONST_ME_POFF)
        return true
    end
end