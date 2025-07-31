local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_POFF)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -0.9, 0, -1.5, 0)

local arr = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local area = createCombatArea(arr)
setCombatArea(combat, area)

function onCastSpell(cid, var)
    local centerpos = {x = getCreaturePosition(cid).x, y = getCreaturePosition(cid).y, z = getCreaturePosition(cid).z}
    local level = getPlayerLevel(cid)
    local maglv = getPlayerMagLevel(cid)
    local minDmg = (level * 8 + maglv * 7) * 4.5 - 30
    local maxDmg = (level * 8 + maglv * 7) * 7.0 - 30
    doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, centerpos, area, -minDmg, -maxDmg, CONST_ME_POFF)
    return true
end
