local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -0.9, 0, -1.5, 0)

local helmetMultipliers = {
   [2656] = 2.0,
   [4337] = 3.0,
   [2663] = 1.5
}
local armorMultipliers = {
   [2656] = 2.0,
   [4338] = 3.0,
   [2465] = 1.3
}
local necklaceMultipliers = {
   [2161] = 1.1,
   [2162] = 1.2,
   [2163] = 1.3
}
local ringMultipliers = {
   [2123] = 1.3,
   [2124] = 1.2,
   [2125] = 1.1
}

function getDamageMultiplier(cid)
   local multiplier = 1.0
   
   local helmet = getPlayerSlotItem(cid, CONST_SLOT_HEAD)
   if helmet and helmetMultipliers[helmet.itemid] then
       multiplier = multiplier * helmetMultipliers[helmet.itemid]
   end
   
   local armor = getPlayerSlotItem(cid, CONST_SLOT_ARMOR)
   if armor and armorMultipliers[armor.itemid] then
       multiplier = multiplier * armorMultipliers[armor.itemid]
   end
   
   local necklace = getPlayerSlotItem(cid, CONST_SLOT_NECKLACE)
   if necklace and necklaceMultipliers[necklace.itemid] then
       multiplier = multiplier * necklaceMultipliers[necklace.itemid]
   end
   
   local ring = getPlayerSlotItem(cid, CONST_SLOT_RING)
   if ring and ringMultipliers[ring.itemid] then
       multiplier = multiplier * ringMultipliers[ring.itemid]
   end
   
   return multiplier
end

local arr = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local area = createCombatArea(arr)
setCombatArea(combat, area)

function onCastSpell(cid, var)
    local centerpos = {x = getCreaturePosition(cid).x, y = getCreaturePosition(cid).y, z = getCreaturePosition(cid).z}
    local level = getPlayerLevel(cid)
    local maglv = getPlayerMagLevel(cid)
    
    -- Calculate base damage as in the original script
    local minDmg = 2000
    local maxDmg = 2999
    
    -- Apply item multipliers
    local multiplier = getDamageMultiplier(cid)
    minDmg = math.floor(minDmg * multiplier)
    maxDmg = math.floor(maxDmg * multiplier)
    
    doAreaCombatHealth(cid, COMBAT_LIFEDRAIN, centerpos, area, -minDmg, -maxDmg, CONST_ME_MAGIC_RED)
    return true
end
