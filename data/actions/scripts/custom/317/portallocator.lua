function getDirectionTo(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    
    -- Calculate direction (fixed north/south for Tibia coordinate system)
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

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Define the item ID you want to find
    local searchItemId = 2176  -- Example: Crystal Coin ID
    
    -- Get player's position
    local playerPos = player:getPosition()
    
    -- Find the nearest item with the specified ID
    local foundItem = nil
    local foundPos = nil
    local minDistance = math.huge
    
    -- Search in a smaller radius for better performance
    local searchRadius = 274
    for x = -searchRadius, searchRadius do
        for y = -searchRadius, searchRadius do
            local searchPos = Position(playerPos.x + x, playerPos.y + y, playerPos.z)
            local tile = Tile(searchPos)
            
            if tile then
                -- More defensive checking of items
                local items = tile:getItems()
                if items then
                    for i = 1, #items do
                        local currentItem = items[i]
                        if currentItem and currentItem:getId() == searchItemId then
                            local distance = math.max(math.abs(x), math.abs(y))
                            if distance < minDistance then
                                minDistance = distance
                                foundItem = currentItem
                                foundPos = searchPos
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- If item was found, send direction message
    if foundItem then
        local distance = getDistance(playerPos, foundPos)
        local direction = getDirectionTo(playerPos, foundPos)
        local message = ""
        
        -- Check if on different floor
        if foundPos.z > playerPos.z then
            message = "The item is on a higher level"
        elseif foundPos.z < playerPos.z then
            message = "The item is on a lower level"
        else
            if distance == "beside" then
                message = "The item is standing next to you"
            else
                message = string.format("The item is %s to the %s", distance, direction)
            end
        end
        
        player:sendTextMessage(MESSAGE_INFO_DESCR, message)
        Position(playerPos):sendMagicEffect(CONST_ME_MAGIC_BLUE)
        return true
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "No item of this type could be found.")
        Position(playerPos):sendMagicEffect(CONST_ME_POFF)
        return true
    end
end