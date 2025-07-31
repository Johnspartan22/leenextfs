-- Create a table to track AFK players
local afkPlayers = {}

-- Register the !afk command
function onSay(cid, words, param)
    local player = Player(cid)
    if not player then
        return false
    end

    local playerId = player:getId()

    -- If player is already AFK, disable AFK mode
    if afkPlayers[playerId] then
        removeAfk(playerId)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are no longer AFK.")
        return false
    end

    -- Enable AFK mode
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You are now AFK.")

    -- Store the player's current position
    local startPosition = player:getPosition()

    -- Function to display AFK message
    local function showAfkMessage(pid)
        local afkPlayer = Player(pid)
        if afkPlayer and afkPlayers[pid] then
            afkPlayer:say("<AFK>", TALKTYPE_MONSTER_SAY)
            afkPlayers[pid].messageEvent = addEvent(showAfkMessage, 3000, pid) -- Keep repeating every 3 seconds
        end
    end

    -- Function to check if the player moved
    local function checkAfkMovement(pid, startPos)
        local afkPlayer = Player(pid)
        if afkPlayer then
            local currentPos = afkPlayer:getPosition()
            if currentPos.x ~= startPos.x or currentPos.y ~= startPos.y or currentPos.z ~= startPos.z then
                removeAfk(pid)
                afkPlayer:sendTextMessage(MESSAGE_INFO_DESCR, "You are no longer AFK due to movement.")
                return
            end
            afkPlayers[pid].movementEvent = addEvent(checkAfkMovement, 1000, pid, startPos)
        end
    end

    -- Store AFK status and start both events
    afkPlayers[playerId] = {
        messageEvent = addEvent(showAfkMessage, 3000, playerId),
        movementEvent = addEvent(checkAfkMovement, 1000, playerId, startPosition)
    }

    return false
end

-- Function to remove AFK status
function removeAfk(playerId)
    if afkPlayers[playerId] then
        if afkPlayers[playerId].messageEvent then
            stopEvent(afkPlayers[playerId].messageEvent)
        end
        if afkPlayers[playerId].movementEvent then
            stopEvent(afkPlayers[playerId].movementEvent)
        end
        afkPlayers[playerId] = nil
    end
end

-- Clear AFK status when the player logs out
function onLogout(cid)
    local player = Player(cid)
    if player then
        removeAfk(player:getId())
    end
    return true
end
