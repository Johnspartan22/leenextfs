--[[
	PvP Aerna v0.1
	by Shawak
]]--

local corpse_ids = {
	3065, -- famale 
	3058  -- male
}

---------------------------
local arena = {------------
---------------------------
-- Put your pvp areas here:

{main_pos = {x = 162, y = 73, z = 4}, frompos = {x = 147, y = 63, z = 4, topos = {x = 167, y = 71, z = 4},


} -------------------------

function onStatsChange(cid, attacker, type, combat, value)
	if combat == COMBAT_HEALING then
		return true
	end

	if getCreatureHealth(cid) > value then
		return true
	end

	local arenaID = 0
	for i = 1, #arena do
		if isInRange(getCreaturePosition(cid), arena[i].frompos, arena[i].topos) then
			arenaID = i
			break
		end
		if i == #arena then
			return true
		end 
	end

	local corpse = doCreateItem((corpse_ids[getPlayerSex(cid)+1]), 1, getPlayerPosition(cid))
	doSetItemSpecialDescription(corpse, "You recognize "..getCreatureName(cid)..". He was killed by "..(isMonster(attacker) and "a "..string.lower(getCreatureName(attacker)) or isCreature(attacker) and getCreatureName(attacker) or "a field item")..".\n[PvP Arena Kill]")

	doTeleportThing(cid, arena[arenaID].main_pos)
	doSendMagicEffect(getCreaturePosition(cid), 10)

	doRemoveConditions(cid)
	doCreatureAddHealth(cid, getCreatureMaxHealth(cid) - getCreatureHealth(cid))
	doCreatureAddMana(cid, getCreatureMaxMana(cid) - getCreatureMana(cid))

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You got killed by "..(isMonster(attacker) and "a "..string.lower(getCreatureName(attacker)) or isCreature(attacker) and getCreatureName(attacker) or "a field item").." in a pvp arena.")
	if isPlayer(attacker) then
		doPlayerSendTextMessage(attacker, MESSAGE_STATUS_CONSOLE_BLUE, "You killed "..getCreatureName(cid).." in a pvp arena.")
	end
	return false
end