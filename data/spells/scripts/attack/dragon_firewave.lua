local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_TELEPORT)

-- Using predefined directional areas
-- AREA_WAVE4 and AREADIAGONAL_WAVE4 are directional area constants in newer OTX versions
combat:setArea(createCombatArea(AREA_WAVE4, AREADIAGONAL_WAVE4))

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end