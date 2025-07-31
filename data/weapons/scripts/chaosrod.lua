local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_WEAPON_BIGROCK)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -3.25, 0, -8.35, 0) 
local area = createCombatArea({
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
})
combat:setArea(area)

function onUseWeapon(player, variant)
    return combat:execute(player, variant)
end