function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local rewardTable = {
        [5006] = {itemId = 2458, text = "You have found a piece of the blessed set."}, -- Blessed Shield
        [5007] = {itemId = 2196, text = "You have found a piece of the blessed set."}, -- Blessed Amulet
        [5008] = {itemId = 2541, text = "You have found a piece of the blessed set."}, -- Blessed Shield
        [5009] = {itemId = 2648, text = "You have found a piece of the blessed set."}  -- Blessed Legs
    }

    local reward = rewardTable[item.uid]
    if reward then
        if player:getStorageValue(5010) == -1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, reward.text)
            player:addItem(reward.itemId, 1)
            player:setStorageValue(5010, 1)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
        end
        return true
    end
    return false
end