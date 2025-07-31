local playerCooldowns = {}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local playerGUID = getPlayerGUID(cid)
    local currentTime = os.time()
    
    -- Check if player is on cooldown
    if playerCooldowns[playerGUID] and currentTime < playerCooldowns[playerGUID] then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have already gotten your rewards.")
        return true
    end
    
    -- Give rewards
    if doPlayerAddItem(cid, 2320, 100) then  -- Crystal Coin
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have received a reward!")
        -- Set cooldown for 1 hour
        playerCooldowns[playerGUID] = currentTime + 3600
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your backpack is full.")
    end
    
    return true
end

-- Clean up old data periodically
function cleanOldData()
    local currentTime = os.time()
    for guid, cooldownTime in pairs(playerCooldowns) do
        if cooldownTime < currentTime then
            playerCooldowns[guid] = nil
        end
    end
end

addEvent(cleanOldData, 3600000) -- Run cleanup every hour