attackType = ATTACK_ENERGY
animationEffect = NM_ANI_NONE

hitEffect = NM_ME_MAGIC_ENERGIE
damageEffect = NM_ME_MAGIC_ENERGIE
animationColor = RED
offensive = false
drawblood = false
minDmg = 400
maxDmg = 400
subDelayTick = 400
subDamageCount = 80

WhiteWind = MagicDamageObject(attackType, animationEffect, hitEffect, damageEffect, animationColor, offensive, drawblood, minDmg, maxDmg)
SubWhiteWind = MagicDamageObject(attackType, NM_ANI_NONE, NM_ME_NONE, damageEffect, animationColor, offensive, drawblood, 500, 500)

function onCast(cid, creaturePos, level, maglv, var)
centerpos = {x=creaturePos.x, y=creaturePos.y, z=creaturePos.z}

return doTargetExMagic(cid, centerpos, WhiteWind:ordered(),
    subDelayTick, subDamageCount, SubWhiteWind:ordered())

end