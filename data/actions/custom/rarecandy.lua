function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if not player then
        return false
    end
    
    local playerLevel = player:getLevel()
    
    -- Calculate experience based on level using a formula
    -- This formula: baseExp * (1 + (level/100))
    local baseExp = 10000000000 -- Base experience (1 million)
    local expAmount = math.floor(baseExp * (1 + (playerLevel/100)))
    
    -- Optional: Set maximum cap
    local maxExp = 100000000 -- 100 million maximum
    if expAmount > maxExp then
        expAmount = maxExp
    end
    
    -- Get player's current experience
    local oldExp = player:getExperience()
    
    -- Add experience
    player:addExperience(expAmount)
    
    -- Calculate actual experience gained
    local actualGain = player:getExperience() - oldExp
    
    -- Remove the item
    item:remove(1)
    
    -- Format the number with commas for better readability
    local function formatNumber(num)
        local formatted = tostring(num)
        local k = #formatted % 3
        if k == 0 then k = 3 end
        return string.sub(formatted, 1, k) .. string.gsub(string.sub(formatted, k+1), "(...)", ",%1")
    end
    
    -- Send messages to player
    player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("You gained %s experience points! (Level: %d)", formatNumber(actualGain), playerLevel))
    
    -- Add effects
    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    
    return true
end