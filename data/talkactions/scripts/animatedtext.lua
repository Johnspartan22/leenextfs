function onSay(player, words, param)
    if param == "" then
        return false
    end
    
    -- Simple cooldown using storage value
    local cooldownStorage = 87678  -- Choose an unused storage ID
    local cooldownTime = 0.1  -- 100ms cooldown
    
    local lastUseTime = player:getStorageValue(cooldownStorage)
    if lastUseTime > 0 and os.time() - lastUseTime < 1 then
        -- Still on cooldown (less than 1 second since last use)
        return false
    end
    
    -- Update last use time
    player:setStorageValue(cooldownStorage, os.time())
    
    -- Get the player's position
    local position = player:getPosition()
    
    -- Choose a random color from the list
    local colors = {5, 30, 35, 95, 108, 129, 143, 155, 180, 198, 210, 215}
    local randomColor = colors[math.random(#colors)]
    
    -- Send the animated text with the random color
    Game.sendAnimatedText(param, position, randomColor)
    
    return false  -- Return false to prevent the message from appearing in chat
end