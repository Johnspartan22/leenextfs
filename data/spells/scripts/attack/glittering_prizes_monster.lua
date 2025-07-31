local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)
combat:setArea(createCombatArea(AREA_SQUARE5X5))

local condition = Condition(CONDITION_POISON)
condition:setParameter(CONDITION_PARAM_DELAYED, true)
condition:addDamage(5, 2000, -5)
condition:addDamage(4, 2000, -4)
condition:addDamage(3, 2000, -3)
condition:addDamage(2, 2000, -2)
condition:addDamage(1, 2000, -1)

-- Function to spawn crystal coins in area
local function spawnCoinsInArea(position, area)
    for y = -5, 5 do
        for x = -5, 5 do
            local pos = Position(position.x + x, position.y + y, position.z)
            if pos:isValid() then
                -- Create crystal coin (ID: 2160)
                local coin = Game.createItem(2160, 1, pos)
                if coin then
                    -- Remove the coin after 60 seconds
                    addEvent(function()
                        if coin then
                            coin:remove()
                        end
                    end, 60000)
                end
            end
        end
    end
end

function onCastSpell(creature, variant)
    local position = creature:getPosition()
    
    -- Execute combat effect
    combat:execute(creature, variant)
    
    -- Add poison condition to affected creatures
    local spectators = Game.getSpectators(position, false, true, 5, 5, 5, 5)
    for _, target in ipairs(spectators) do
        if target:isPlayer() or target:isMonster() then
            target:addCondition(condition:clone())
        end
    end
    
    -- Spawn crystal coins
    spawnCoinsInArea(position, area)
    
    return true
end