local SKILL_FISHING = 6
local useWorms = TRUE
local ITEM_WORM = 3976  -- Worms item ID
local COOLDOWN_TIME = 60  -- 60 seconds cooldown
local waterIds = {493, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625}

-- Define different types of rods with their respective fish types
local rods = {
    [4369] = {  -- Normal Rod
        fishTypes = {
            {itemId = 2667, minSkill = 0},    -- Normal Fish
            {itemId = 4375, minSkill = 6},    -- Sardine
        }
    },
    [4370] = {  -- skilled Rod
        fishTypes = {
          {itemId = 4376, minSkill = 15},   -- blue gill
          {itemId = 4377, minSkill = 20},   -- rock fish
        }
    },
    [4371] = {  -- Expert anglers rod
        fishTypes = {
         {itemId = 4378, minSkill = 25},    -- Sail fish
         {itemId = 4381, minSkill = 30},   -- large gold fish
        }
    },
    [4372] = {  -- Expert anglers rod
        fishTypes = {
         {itemId = 4380, minSkill = 40},   -- red snapper
         {itemId = 4379, minSkill = 45},   -- blue snapper
        }
    },
    [4373] = {  -- legendary anglers rod
        fishTypes = {
    	 {itemId = 4382, minSkill = 70},   -- Rainbow Trout
    	 {itemId = 4384, minSkill = 80},   -- Shark
    	 {itemId = 4383, minSkill = 90},   -- Golden KOi
        }
    }
}

-- Table to track player cooldowns
local playerCooldowns = {}

-- Function to attempt catching a fish
local function attemptCatchFish(cid, startPosition, rodId)
    -- Check if player has moved from the start position
    if getPlayerPosition(cid).x ~= startPosition.x or getPlayerPosition(cid).y ~= startPosition.y then
        
        return  -- Exit the function if player moved
    end

    local playerSkill = getPlayerSkill(cid, SKILL_FISHING)
    local caughtFish = false

    

    for _, fish in ipairs(rods[rodId].fishTypes) do
        if playerSkill >= fish.minSkill and math.random(1, 100) <= playerSkill then
            doPlayerAddItem(cid, fish.itemId, 1)
            caughtFish = true
            
            break
        end
    end

    -- Add skill if a fish was caught
    if caughtFish then

        doPlayerAddSkillTry(cid, SKILL_FISHING, 1)
        
    end
end

-- Ripple effect function that attempts to catch a fish
function createRippleEffect(cid, position, startPosition, duration, interval, rodId)
    local times = math.floor(duration / interval) -- Total times ripple occurs
    for i = 1, times do
        addEvent(function()
            -- Check if player moved before each ripple
            if getPlayerPosition(cid).x == startPosition.x and getPlayerPosition(cid).y == startPosition.y then
                doSendMagicEffect(position, CONST_ME_LOSEENERGY)
                attemptCatchFish(cid, startPosition, rodId)
            else
                
                return  -- Stop fishing if the player moved
            end
        end, i * interval * 1000)
    end
end

-- Main fishing function
function onUse(cid, item, frompos, item2, topos)
    local currentTime = os.time()

    -- Check if the player has triggered fishing in the past 60 seconds
    if playerCooldowns[cid] and (currentTime - playerCooldowns[cid]) < COOLDOWN_TIME then
        local remainingTime = COOLDOWN_TIME - (currentTime - playerCooldowns[cid])
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "You need to wait " .. remainingTime .. " seconds before fishing again.")
        return FALSE
    end

    if isInArray(waterIds, item2.itemid) == TRUE then
                if item2.itemid ~= 493 then  -- Exclude wells
            -- Check if player needs worms and has them
            if useWorms == FALSE or (useWorms == TRUE and doPlayerRemoveItem(cid, ITEM_WORM, 1)) then
                -- Set the player's fishing cooldown
                playerCooldowns[cid] = currentTime

                -- Store the player's starting position
                local startPosition = getPlayerPosition(cid)

                -- Create ripple effect and attempt to catch fish during each ripple
                createRippleEffect(cid, topos, startPosition, 60, 5, item.itemid)  -- Ripple effect every second for 10 seconds
                doSendMagicEffect(getPlayerPosition(cid), CONST_ME_NEWFISHING)
		doSendMagicEffect(topos, CONST_ME_LOSEENERGY)
            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "You need worms to fish.")
                return FALSE
            end
        end
        return TRUE
    end
    return FALSE
end
