-- Complete Door File
-- Made for 7.6
-- By Doom Stone

function onUse(cid, item, frompos, item2, topos)

	if item.actionid == 0 then
		if (item.itemid == 1209 or item.itemid == 1231 or item.itemid == 1249 or item.itemid == 2544 or item.itemid == 3544 or item.itemid == 4913) then
			doTransformItem(item.uid, item.itemid+2)
			
		elseif (item.itemid == 1210 or item.itemid == 1219 or item.itemid == 1223 or item.itemid == 1227 or item.itemid == 1232 or item.itemid == 1237 or item.itemid == 1241 or item.itemid == 1245 or item.itemid == 1250 or item.itemid == 1255 or item.itemid == 1259 or item.itemid == 1539 or item.itemid == 3545 or item.itemid == 3547 or item.itemid == 3549 or item.itemid == 3551 or item.itemid == 4914 or item.itemid == 5082) then
			doTransformItem(item.uid, item.itemid+1)
			
		elseif (item.itemid == 1211 or item.itemid == 1220 or item.itemid == 1224 or item.itemid == 1228 or item.itemid == 1233 or item.itemid == 1238 or item.itemid == 1242 or item.itemid == 1246 or item.itemid == 1251 or item.itemid == 1256 or item.itemid == 1260 or item.itemid == 1540 or item.itemid == 3546 or item.itemid == 3548 or item.itemid == 3550 or item.itemid == 3552 or item.itemid == 4915 or item.itemid == 5083) then
			doorpos = {x=frompos.x, y=frompos.y, z=frompos.z, stackpos=253}
			getplayer = getThingfromPos(doorpos)
			if getplayer.itemid > 0 then
				npos = {x=frompos.x + 1, y=frompos.y, z=frompos.z}
				doTeleportThing(getplayer.uid, npos)
				doTransformItem(item.uid, item.itemid - 1)
			else
				doTransformItem(item.uid, item.itemid - 1)
			end
			
			
		elseif (item.itemid == 1212 or item.itemid == 1234 or item.itemid == 1252 or item.itemid == 3535 or item.itemid == 4916) then
			doTransformItem(item.uid, item.itemid + 2)
			
		elseif (item.itemid == 1213 or item.itemid == 1221 or item.itemid == 1225 or item.itemid == 1229 or item.itemid == 1235 or item.itemid == 1239 or item.itemid == 1243 or item.itemid == 1247 or item.itemid == 1253 or item.itemid == 1257 or item.itemid == 1261 or item.itemid == 1541 or item.itemid == 3536 or item.itemid == 3538 or item.itemid == 3540 or item.itemid == 3542 or item.itemid == 4917 or item.itemid == 5084) then
			doTransformItem(item.uid, item.itemid + 1)
		
		elseif (item.itemid == 1214 or item.itemid == 1222 or item.itemid == 1226 or item.itemid == 1230 or item.itemid == 1236 or item.itemid == 1240 or item.itemid == 1244 or item.itemid == 1248 or item.itemid == 1254 or item.itemid == 1258 or item.itemid == 1262 or item.itemid == 1542 or item.itemid == 3537 or item.itemid == 3539 or item.itemid == 3541 or item.itemid == 3543 or item.itemid == 4918 or item.itemid == 5085) then
			doorpos = {x=frompos.x, y=frompos.y, z=frompos.z, stackpos=253}
			getplayer = getThingfromPos(doorpos)
			if getplayer.itemid > 0 then
				npos = {x=frompos.x, y=frompos.y + 1, z=frompos.z}
				doTeleportThing(getplayer.uid, npos)
				doTransformItem(item.uid, item.itemid - 1)
			else
				doTransformItem(item.uid, item.itemid - 1)
			end
			
			
		elseif item.itemid == 1634 or item.itemid == 1636 or item.itemid == 1638 or item.itemid == 1640 then
			doTransformItem(item.uid, item.itemid + 1)
			
		elseif item.itemid == 1635 or item.itemid == 1637 or item.itemid == 1639 or item.itemid == 1641 then
			doTransformItem(item.uid, item.itemid - 1)
		else
			return 0
		end
		
	elseif item.actionid > 0 then
		level = item.actionid - 1000	-- Action ID's below 100 are reserved
		if level > 0 then
			if (getPlayerLevel(cid) >= level) then
				pos = getPlayerPosition(cid)
				
				if pos.x == topos.x then
					if pos.y < topos.y then
						pos.y = topos.y + 1
					else
						pos.y = topos.y - 1
					end
				elseif pos.y == topos.y then
					if pos.x < topos.x then
						pos.x = topos.x + 1
					else
						pos.x = topos.x - 1
					end
				else
					doPlayerSendTextMessage(cid, 22, 'Stand in front of the door.')
					return 1
				end
				doTeleportThing(cid, pos)
				doSendMagicEffect(topos, 13)
			else
				doPlayerSendTextMessage(cid, 22, 'You need level ' .. level .. ' to pass this door.')
			end
		
			return 1
		else
			return 0
		end
	end
	
	return 1
end