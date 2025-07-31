local drunk = Condition(CONDITION_DRUNK)
drunk:setParameter(CONDITION_PARAM_TICKS, 60000)

local poison = Condition(CONDITION_POISON)
poison:setParameter(CONDITION_PARAM_DELAYED, true)
poison:setParameter(CONDITION_PARAM_MINVALUE, -50)
poison:setParameter(CONDITION_PARAM_MAXVALUE, -120)
poison:setParameter(CONDITION_PARAM_STARTVALUE, -5)
poison:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
poison:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local fluidMessage = {
	[3] = 'Aah...',
	[4] = 'Urgh!',
	[5] = 'Mmmh.',
	[7] = 'Aaaah...',
	[10] = 'Aaaah...',
	[11] = 'Urgh!',
	[13] = 'Urgh!',
	[15] = 'Aah...',
	[19] = 'Urgh!',
	[43] = 'Aaaah...'
}

-- Custom water sources that aren't defined in the ItemType:getFluidSource()
local customWaterSources = {
    [1369] = 1, -- Fountain (water type 1)
    [1427] = 1  -- Another water source (water type 1)
    -- Add more custom water sources as needed
}

-- Special fire that should respawn
local specialFire = {
    position = Position(2181, 1030, 8),
    itemid = 1492, -- Default fire ID, will be updated when extinguished
    respawnTime = 10 * 60 -- 10 minutes in seconds
}

local function graveStoneTeleport(cid, fromPosition, toPosition)
	local player = Player(cid)
	if not player then
		return true
	end

	player:teleportTo(toPosition)
	player:say('Muahahahaha..', TALKTYPE_MONSTER_SAY, false, player)
	fromPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
	toPosition:sendMagicEffect(CONST_ME_MORTAREA)
end

-- List of fire item IDs to check against
local fireItems = {
    1488, 1489, 1490, 1491, -- Common fire IDs
    1492, 1493, 1494,       -- More fire variations
    1500, 1501              -- Campfires
    -- Add any other fire item IDs your server uses
}

function onUse(player, item, fromPosition, target, toPosition)
	local targetType = ItemType(target.itemid)
	if targetType:isFluidContainer() then
		if target.type == 0 and item.type ~= 0 then
			target:transform(target.itemid, item.type)
			item:transform(item.itemid, 0)
			return true
		elseif target.type ~= 0 and item.type == 0 then
			target:transform(target.itemid, 0)
			item:transform(item.itemid, target.type)
			return true
		end
	end

    -- Check if target is a fire and the fluid is water (type 1)
    local isFireItem = false
    for _, fireId in ipairs(fireItems) do
        if target.itemid == fireId then
            isFireItem = true
            break
        end
    end
    
    if isFireItem and item.type == 1 then
        -- Check if this is our special fire that should respawn
        local isSpecialFire = (toPosition.x == specialFire.position.x and 
                              toPosition.y == specialFire.position.y and 
                              toPosition.z == specialFire.position.z)
        
        -- Store the fire ID if it's the special fire (for respawning the correct fire)
        if isSpecialFire then
            specialFire.itemid = target.itemid
        end
        
        -- Remove the fire
        target:remove()
        
        -- Show a poff effect
        toPosition:sendMagicEffect(CONST_ME_POFF)
        
        -- Empty the container
        item:transform(item.itemid, 0)
        
        -- Send message to player
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You extinguished the fire.")
        
        -- Schedule respawn if this is the special fire
        if isSpecialFire then
            addEvent(function()
                local tile = Tile(specialFire.position)
                if tile then
                    -- Only respawn if there's no fire already
                    local hasFireItem = false
                    for _, fireId in ipairs(fireItems) do
                        if tile:getItemById(fireId) then
                            hasFireItem = true
                            break
                        end
                    end
                    
                    if not hasFireItem then
                        Game.createItem(specialFire.itemid, 1, specialFire.position)
                        specialFire.position:sendMagicEffect(CONST_ME_FIREAREA)
                    end
                end
            end, specialFire.respawnTime * 1000)
        end
        
        return true
    end

	if target.itemid == 1 then
		if item.type == 0 then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, 'It is empty.')

		elseif target.uid == player.uid then
			if isInArray({3, 15, 43}, item.type) then
				player:addCondition(drunk)

			elseif item.type == 4 then
				player:addCondition(poison)

			elseif item.type == 7 then
				player:addMana(math.random(50, 150))
				fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)

			elseif item.type == 10 then
				player:addHealth(60)
				fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end

			player:say(fluidMessage[item.type] or 'Gulp.', TALKTYPE_MONSTER_SAY)
			item:transform(item.itemid, 0)
		else
			local pool = Game.createItem(2016, item.type, toPosition)
			if pool then
				pool:decay()
			end
			item:transform(item.itemid, 0)
		end

	else
		-- Check for custom water sources first
		local customFluidType = customWaterSources[target.itemid]
		if customFluidType and item.type == 0 then
			-- Fill the container with water
			item:transform(item.itemid, customFluidType)
			toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
			return true
		end

		local fluidSource = targetType:getFluidSource()
		if fluidSource ~= 0 then
			item:transform(item.itemid, fluidSource)

		elseif item.type == 0 then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, 'It is empty.')

		else
			if item.type == 2 and target.actionid == 2023 then
				toPosition.y = toPosition.y + 1
				local creatures, destination = Tile(toPosition):getCreatures(), Position(32791, 32332, 10)
				if #creatures == 0 then
					graveStoneTeleport(player.uid, fromPosition, destination)
				else
					local creature
					for i = 1, #creatures do
						creature = creatures[i]
						if creature and creature:isPlayer() then
							graveStoneTeleport(creature.uid, toPosition, destination)
						end
					end
				end

			else
				if toPosition.x == CONTAINER_POSITION then
					toPosition = player:getPosition()
				end

				local pool = Game.createItem(2016, item.type, toPosition)
				if pool then
					pool:decay()
				end
			end
			item:transform(item.itemid, 0)
		end
	end

	return true
end