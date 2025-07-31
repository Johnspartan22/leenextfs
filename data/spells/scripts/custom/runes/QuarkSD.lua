area = {
 {0, 0, 1, 1, 1, 0, 0},
 {0, 1, 1, 1, 1, 1, 0},
 {1, 1, 1, 1, 1, 1, 1},
 {1, 1, 1, 1, 1, 1, 1},
 {1, 1, 1, 1, 1, 1, 1},
 {0, 1, 1, 1, 1, 1, 0},
 {0, 0, 1, 1, 1, 0, 0}
 }
 
 attackType = ATTACK_PHYSICAL
 needDirection = false
 areaEffect = NM_ME_MORT_AREA
 animationEffect = NM_ANI_SUDDENDEATH
 
 hitEffect = NM_ME_MORT_AREA
 damageEffect = NM_ME_DRAW_BLOOD
 animationColor = RED
 offensive = true
 drawblood = true
 
 GreatFireballObject = MagicDamageObject(attackType, animationEffect, hitEffect, damageEffect, animationColor, offensive, drawblood, 0, 0)
 
 function onCast(cid, creaturePos, level, maglv, var)
 centerpos = {x=creaturePos.x, y=creaturePos.y, z=creaturePos.z}
 
 GreatFireballObject.minDmg = (level * 6 + maglv *6) * 2.40
 GreatFireballObject.maxDmg = (level * 6 + maglv *6) * 2.75
 
 return doAreaMagic(cid, centerpos, needDirection, areaEffect, area, GreatFireballObject:ordered())
 end
