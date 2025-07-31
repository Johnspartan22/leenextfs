function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if not player then
        return false
    end
    
    -- Check if player has the reward storage value
    local rewardStorage = 95001  -- Unique storage value for this specific chest
    local storageValue = player:getStorageValue(rewardStorage)
    
    if storageValue == 1 then
        -- Give rewards
        if player:addItem(2329, 1) then  -- Crystal Coin
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received a reward!")
            -- Reset the storage value to 0 after giving reward
            player:setStorageValue(rewardStorage, 0)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your backpack is full.")
        end
    elseif storageValue == 0 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already gotten your rewards.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are not eligible for this reward yet.")
    end
    
    return true
end