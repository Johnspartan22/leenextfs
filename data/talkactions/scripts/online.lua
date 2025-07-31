function onSay(player, words, param)
    if player:getExhaustion(1000) <= 0 then
        player:setExhaustion(1000, 2)
        local hasAccess = player:getGroup():getAccess()
        local players = Game.getPlayers()
        local playerCount = 0
        local validPlayers = {}
        
        -- First, filter out GMs, Gods, and CMs and count valid players
        for _, targetPlayer in ipairs(players) do
            local group = targetPlayer:getGroup():getId()
            -- Assuming group IDs: 1 = normal player, 2+ = special groups (GM, God, CM)
            -- Adjust these numbers according to your group IDs
            if group == 1 and (hasAccess or not targetPlayer:isInGhostMode()) then
                playerCount = playerCount + 1
                table.insert(validPlayers, targetPlayer)
            end
        end

        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, playerCount .. " players online.")

        local i = 0
        local msg = ""
        for k, targetPlayer in ipairs(validPlayers) do
            if i > 0 then
                msg = msg .. ", "
            end
            msg = msg .. targetPlayer:getName()
            i = i + 1

            if i == 10 then
                if k == #validPlayers then
                    msg = msg .. "."
                else
                    msg = msg .. ","
                end
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
                msg = ""
                i = 0
            end
        end

        if i > 0 then
            msg = msg .. "."
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
        end
        return false
    else
        player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You\'re exhausted for: '..player:getExhaustion(1000)..' seconds.')
    end
end