function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.uid == 7000 then
        if item.itemid == 1945 then
            -- Define possible player positions
            local playerPositions = {
                Position(194, 118, 9),
                Position(193, 118, 9),
                Position(192, 118, 9),
                Position(191, 118, 9)
            }

            -- Define teleport destinations
            local teleportPositions = {
                Position(194, 118, 10),
                Position(193, 118, 10),
                Position(192, 118, 10),
                Position(191, 118, 10)
            }

            -- Find all players in the quest area
            local players = {}
            for i, pos in ipairs(playerPositions) do
                local creature = Tile(pos):getTopCreature()
                if creature and creature:isPlayer() then
                    table.insert(players, creature)
                end
            end

            -- Check if there's at least one player
            if #players > 0 then
                -- Check if all present players are eligible
                local canDoQuest = true
                for _, participant in ipairs(players) do
                    if participant:getStorageValue(7000) ~= -1 then
                        canDoQuest = false
                        break
                    end
                end

                if canDoQuest then
                    -- Teleport all participating players
                    for i, participant in ipairs(players) do
                        -- Show effect at original position
                        participant:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
                        
                        -- Teleport player
                        participant:teleportTo(teleportPositions[i])
                        
                        -- Show effect at destination
                        teleportPositions[i]:sendMagicEffect(CONST_ME_TELEPORT)
                    end

                    -- Transform the lever
                    item:transform(1946)

                    -- Reset the lever after a delay
                    addEvent(function()
                        item:transform(1945)
                    end, 2000)  -- 2000 ms = 2 seconds
                else
                    player:sendCancelMessage("Somebody in your team has already done this quest.")
                end
            else
                player:sendCancelMessage("At least one player needs to be present.")
            end
        elseif item.itemid == 1946 then
            if player:getGroup():getAccess() then
                item:transform(1945)
            else
                player:sendCancelMessage("Sorry, not possible.")
            end
        end
    end
    return true
end