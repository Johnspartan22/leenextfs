function onUse(cid, item, frompos, item2, topos)
    -- Define better pick required rocks (removed silver and gold since we'll handle them now)
    local betterPickRequired = {
        [4332] = true, -- Adamant Vein
        [4360] = true, -- Platinum Vein
        [4361] = true  -- Magic Crystal Vein
    }
    
    -- Define vein types and their depleted versions with updated success rates
    local veinTypes = {
        [4328] = {depleted = 1359, ore = 4362, name = "iron", chance = 250},    -- Iron vein -> 25% chance
        [4329] = {depleted = 1359, ore = 4363, name = "coal", chance = 250},    -- Coal vein -> 25% chance
        [4330] = {depleted = 1359, ore = 4364, name = "silver", chance = 150},  -- Silver vein -> 15% chance
        [4331] = {depleted = 1359, ore = 4365, name = "gold", chance = 100}     -- Gold vein -> 10% chance
    }
    
    -- Check if target is a valid vein
    if not veinTypes[item2.itemid] then
        doPlayerSendCancel(cid, "You can only mine from valid ore veins.")
        return false
    end
    
    -- Get or initialize mining attempts for this vein
    local key = string.format("%d-%d-%d", topos.x, topos.y, topos.z)
    if not getGlobalStorageValue(key) then
        setGlobalStorageValue(key, 0)
    end
    local attempts = getGlobalStorageValue(key)
    
    -- Mining effects
    doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MINING)
    doSendMagicEffect(topos, CONST_ME_BLOCKHIT)
    
    -- Random chance calculation (1-1000 for better control)
    local rand = math.random(1, 1000)
    
    -- Increment attempts
    attempts = attempts + 1
    setGlobalStorageValue(key, attempts)
    
    -- Check if vein should be depleted (after 3-5 attempts)
    local maxAttempts = math.random(3, 5)
    if attempts >= maxAttempts then
        -- Transform to depleted rock
        doTransformItem(item2.uid, veinTypes[item2.itemid].depleted)
        setGlobalStorageValue(key, 0) -- Reset attempts
        
        -- Schedule regeneration after 1 minute (60 seconds)
        addEvent(function()
            local tile = getTileItemById(topos, veinTypes[item2.itemid].depleted)
            if tile then
                doTransformItem(tile.uid, item2.itemid)
                doSendMagicEffect(topos, CONST_ME_MAGIC_BLUE)
            end
        end, 60 * 1000) -- 60 seconds * 1000 milliseconds
        
        doPlayerSendTextMessage(cid, 22, "The vein has been depleted!")
    end
    
    -- Success chance based on ore type
    if rand <= veinTypes[item2.itemid].chance then
        -- Add ore based on vein type
        doPlayerAddItem(cid, veinTypes[item2.itemid].ore, 1)
        doPlayerSendTextMessage(cid, 22, "You have successfully mined some " .. veinTypes[item2.itemid].name .. " ore!")
    else
        -- Additional random events with Drukus having 5% chance
        if rand <= 200 and rand > 150 and item.itemid == 2553 then -- 5% chance for Drukus when using basic pick
            local drukus = doSummonCreature("Drukus the Dwarf", topos)
            if drukus then
                -- Remove old pick
                doRemoveItem(item.uid, 1)
                
                -- Send messages
                doCreatureSay(drukus, "Seen yer was strugglin'", TALKTYPE_SAY)
                addEvent(function()
                    if isCreature(drukus) then
                        -- Give better pick
                        doPlayerAddItem(cid, 4874, 1)
                        doCreatureSay(drukus, "Listen to ther rock, it'll never steer yer wrong!", TALKTYPE_SAY)
                        
                        -- Despawn Drukus with effect
                        addEvent(function()
                            if isCreature(drukus) then
                                doSendMagicEffect(getCreaturePosition(drukus), CONST_ME_POFF)
                                doRemoveCreature(drukus)
                            end
                        end, 3000)
                    end
                end, 2000)
            end
        elseif rand == 975 then
            doPlayerSendTextMessage(cid, 22, "A Tunneler has appeared from the pile of rocks!")
            doSummonCreature("Tunneler", topos)
        elseif rand == 980 then
            doPlayerSendTextMessage(cid, 22, "You have found a crystal coin!")
            doPlayerAddItem(cid, 2160, 1)
        elseif rand == 985 then
            doPlayerSendTextMessage(cid, 22, "You have lost health due to exhaustion from mining!")
            doPlayerAddHealth(cid, -500)
        elseif rand == 990 then
            doRemoveItem(item.uid, 1)
            doSendMagicEffect(topos, 2)
            doPlayerSendTextMessage(cid, 22, "Your pick has been destroyed!")
        else
            doPlayerSendTextMessage(cid, 22, "You failed to mine the rock.")
        end
    end
    
    return true
end