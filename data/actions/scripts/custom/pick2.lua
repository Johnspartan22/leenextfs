function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Define vein types and their depleted versions with updated success rates
    local veinTypes = {
        [4328] = {depleted = 1359, ore = 4362, name = "iron", chance = 250},    -- Iron vein -> 25% chance
        [4329] = {depleted = 1359, ore = 4363, name = "coal", chance = 250},    -- Coal vein -> 25% chance
        [4330] = {depleted = 1359, ore = 4364, name = "silver", chance = 150},  -- Silver vein -> 15% chance
        [4331] = {depleted = 1359, ore = 4365, name = "gold", chance = 100}     -- Gold vein -> 10% chance
    }
    
    -- Check if target is a valid vein
    if not target or not target.itemid or not veinTypes[target.itemid] then
        player:sendCancelMessage("You can only mine from valid ore veins.")
        return false
    end
    
    -- Store values we need for later
    local currentItemId = target.itemid
    local veinData = veinTypes[currentItemId]
    
    -- Mining effects
    player:getPosition():sendMagicEffect(CONST_ME_MINING)
    toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
    
    -- Get or initialize mining attempts for this vein
    local key = toPosition.x .. "-" .. toPosition.y .. "-" .. toPosition.z
    local attempts = tonumber(Game.getStorageValue(key)) or 0
    
    -- Increment attempts
    attempts = attempts + 1
    Game.setStorageValue(key, attempts)
    
    -- Random chance calculation (1-1000 for better control)
    local rand = math.random(1, 1000)
    
    -- Check if vein should be depleted (after 3-5 attempts)
    local maxAttempts = math.random(3, 5)
    if attempts >= maxAttempts then
        -- Transform to depleted rock
        if target and target:isItem() then
            target:transform(veinData.depleted)
            Game.setStorageValue(key, 0) -- Reset attempts
            
            -- Schedule regeneration after 1 minute (60 seconds)
            addEvent(function()
                local tile = Tile(toPosition)
                if tile then
                    local depleted = tile:getItemById(veinData.depleted)
                    if depleted then
                        depleted:transform(currentItemId)
                        toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                    end
                end
            end, 60 * 1000) -- 60 seconds * 1000 milliseconds
            
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The vein has been depleted!")
        end
    end
    
    -- Success chance based on ore type
    if rand <= veinData.chance then
        -- Add ore based on vein type
        player:addItem(veinData.ore, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have successfully mined some " .. veinData.name .. " ore!")
    else
        -- Additional random events (Tunneler removed)
        if rand == 980 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a crystal coin!")
            player:addItem(2160, 1)
        elseif rand == 985 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have lost health due to exhaustion from mining!")
            player:addHealth(-500)
        elseif rand == 990 then
            item:remove(1)
            toPosition:sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your pick has been destroyed!")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You failed to mine the rock.")
        end
    end
    
    return true
end