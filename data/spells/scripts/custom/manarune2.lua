local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)

function onCastSpell(cid, var)

mana = math.random(130000, 130000)
doPlayerAddMana(cid, mana)  

	return doCombat(cid, combat, var)
end  