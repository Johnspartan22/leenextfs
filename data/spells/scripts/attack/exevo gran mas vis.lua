local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, NM_ME_EXPLOSION_AREA)

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

area = {
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    }
local area = createCombatArea(arr)
setCombatArea(combat, area)

function onCastSpell(cid, var)
    local centerpos = {x = getCreaturePosition(cid).x, y = getCreaturePosition(cid).y, z = getCreaturePosition(cid).z}
    local level = getPlayerLevel(cid)
    local maglv = getPlayerMagLevel(cid)
    
    -- Calculate base damage as in the original script
    local minDmg = (level * 7 + maglv * 6) * 4.0
    local maxDmg = (level * 7 + maglv * 6) * 4.3 
    
    -- Apply item multipliers
    local multiplier = getDamageMultiplier(cid)
    minDmg = math.floor(minDmg * multiplier)
    maxDmg = math.floor(maxDmg * multiplier)
    
    doAreaCombatHealth(cid, COMBAT_PHYSICALDAMAGE, centerpos, area, -minDmg, -maxDmg, NM_ME_EXPLOSION_AREA)
    return true
end