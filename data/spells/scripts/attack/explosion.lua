local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_EXPLOSION)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setArea(createCombatArea(AREA_CROSS1X1))

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


function onGetFormulaValues(cid, level, maglevel)
    local multiplier = getDamageMultiplier(cid)
    local min = -(level * 4 + maglevel * 11) * 2.5 * multiplier
    local max = -(level * 4 + maglevel * 11) * 3.1 * multiplier
    return min, max
end


combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end