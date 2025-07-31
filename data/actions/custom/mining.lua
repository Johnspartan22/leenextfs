function onUse(cid, item, frompos, item2, topos)
	Level = getPlayerLevel(cid)
	ClubSkill = getPlayerSkill(cid,1)
	if (item2.actionid == 5000 and Level >= 20 and ClubSkill >= 20) then
		rand = math.random(1,2000)
		if rand < 20 then
			doPlayerSendTextMessage(cid,22,"A Tunneler has appeared from the pile of rocks!")
			doSummonCreature("Tunneler", topos)
		elseif rand == 1300 then
			doPlayerSendTextMessage(cid,22,"You have found 10 Gold Nuggets!")
			doPlayerAddItem(cid,2157,10)
		elseif rand > 1995 then
			doPlayerSendTextMessage(cid,22,"You have found 10 Diamonds!")
			doPlayerAddItem(cid,2145,10)
		elseif (rand > 500 and rand < 800) then
			doPlayerSendTextMessage(cid,22,"You have found 3 crystal Coins!")
			doPlayerAddItem(cid,2160,3)
		elseif (rand > 700 and rand < 1000) then
			doPlayerSendTextMessage(cid,22,"You have found 6 crystal Coins!")
			doPlayerAddItem(cid,2160,6)
		elseif (rand > 1000 and rand < 1300) then
			doPlayerSendTextMessage(cid,22,"You have found 4 crystal Coins!")
			doPlayerAddItem(cid,2160,4)
		elseif (rand > 300 and rand < 600) then
			doPlayerSendTextMessage(cid,22,"You have found 5 crystal Coins!")
			doPlayerAddItem(cid,2160,5)
		elseif (rand > 1500 and rand < 1800) then
			doPlayerSendTextMessage(cid,22,"You have found Crafting Ore OMFG!")
			doPlayerAddItem(cid,2225,1)
		elseif (rand > 1100 and rand < 1400) then
			doPlayerSendTextMessage(cid,22,"You have found 2 crystal Coins!")
			doPlayerAddItem(cid,2160,2)
		elseif (rand > 800 and rand < 1100) then
			doPlayerSendTextMessage(cid,22,"You have lost 2000 hitpoints due to exhaustion of mining!")
			doPlayerAddHealth(cid,-2000)
		elseif (rand > 500 and rand < 800) then
			doPlayerSendTextMessage(cid,22,"You have found 10 Rubys!")
			doPlayerAddItem(cid,2147,10)
		elseif (rand > 550 and rand < 800) then
			doPlayerSendTextMessage(cid,22,"A Demon has appeared from the pile of rocks!")
			doSummonCreature("Demon", topos)
		elseif rand == 40 then
			doPlayerSendTextMessage(cid,22,"An assassin has appeared from the pile of rocks, You have a bounty on your head!!")
			doSummonCreature("assassin", topos)
		elseif rand == 20 then
			doPlayerSendTextMessage(cid,22,"A little dog has appeared from the pile of rocks!")
			doSummonCreature("dog", topos)
		elseif rand >= 1999 then
			doPlayerSendTextMessage(cid,22,"Earthquake, OMFG HIT THE DECK BITACH!")
			doPlayerAddHealth(cid,-3000)
		elseif (rand == 100 and rand < 140) then
			doPlayerSendTextMessage(cid,22,"A spider king has appeared from the pile of rocks!")
			doSummonCreature("old widow", topos)
		elseif rand == 200 then
			doPlayerSendTextMessage(cid,22,"A dragon king has appeared from the pile of rocks!")
			doSummonCreature("Dragon King", topos)
		elseif (rand >= 105 and rand < 150) then
			doRemoveItem(item.uid,1)
			doSendMagicEffect(topos,2)
			doPlayerSendTextMessage(cid,22,"Your pick has been destroyed....OWNED!")
		end
		doSendMagicEffect(topos,4)  -- Changed from 3 to 4 for yellow spark effect
		doPlayerAddSkillTry(cid,1,10)
	else
		doPlayerSendCancel(cid,"You either are not mining on the specific rock or you do not have the required level(20) or club(20) skill to mine.")
	end
return 1
end