function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid) -- Convert cid to player object
    if not player then
        return false
    end

    -- Create drunk condition
    local condition = Condition(CONDITION_DRUNK)
    condition:setParameter(CONDITION_PARAM_TICKS, 60000) -- Duration in milliseconds (60 seconds)
    
    -- Add the condition to the player
    player:addCondition(condition)
    
    -- Remove the item
    item:remove(1)
    
    -- Send message to player
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You feel drunk!")
    return true
end