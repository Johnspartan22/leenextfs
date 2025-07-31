local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)
-- Comment out or remove the line that creates item 1487
-- setCombatParam(combat, COMBAT_PARAM_CREATEITEM, 1487)

local area = createCombatArea({{1}})
setCombatArea(combat, area)

local minDamage = 2000000
local maxDamage = 3000000

function onGetFormulaValues(cid, level, maglevel)
    local min = minDamage
    local max = maxDamage
    return -min, -max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local condition = createConditionObject(CONDITION_FIRE)
setConditionParam(condition, CONDITION_PARAM_DELAYED, true)

-- Set damage over time for 10 ticks, 2 seconds interval
local totalTicks = 10
local tickInterval = 2000
local damagePerTick = -(minDamage + maxDamage) / (2 * totalTicks)

addDamageCondition(condition, totalTicks, tickInterval, damagePerTick)

setCombatCondition(combat, condition)

function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
