-- Author: 		Rodrigo (Nottinghster) - (OTLand, OTFans, XTibia, OTServBR)
-- Country:		Brazil
-- From: 		Tibia World RPG OldSchool
-- Email: 		god.rodrigo@hotmail.com
-- Compiler:	Tibia World Script Maker (Action)

function onUse(cid, item, frompos, item2, topos)
	if isPremium(cid) == TRUE then
		if item.itemid == 2148 and item.type == 100 then
			doChangeTypeItem(item.uid, item.type-item.type)
			doPlayerAddItem(cid, 2152, 1)
			doSendAnimatedText(frompos, "$$$", 89)
		elseif item.itemid == 2152 and item.type == 100 then
			doChangeTypeItem(item.uid, item.type-item.type)
			doPlayerAddItem(cid, 2160, 1)
			doSendAnimatedText(frompos, "$$$", 65)
		elseif item.itemid == 2152 and item.type < 100 then
			doChangeTypeItem(item.uid, item.type-1)
			doPlayerAddItem(cid, 2148, 100)
			doSendAnimatedText(frompos, "$$$", 210)
		elseif item.itemid == 2160 and item.type == 100 then
			doChangeTypeItem(item.uid, item.type-item.type)
			doPlayerAddItem(cid, 2320, 1)
			doSendAnimatedText(frompos, "$$$", 89)
		elseif item.itemid == 2320 and item.type == 100 then
			doChangeTypeItem(item.uid, item.type-item.type)
			doPlayerAddItem(cid, 2229, 1)
			doSendAnimatedText(frompos, "$$$", 89)
		elseif item.itemid == 2229 then
			doChangeTypeItem(item.uid, item.type-1)
			doPlayerAddItem(cid, 2320, 100)
			doSendAnimatedText(frompos, "$$$", 89)
		elseif item.itemid == 2320 then
			doChangeTypeItem(item.uid, item.type-1)
			doPlayerAddItem(cid, 2160, 100)
			doSendAnimatedText(frompos, "$$$", 89)
		elseif item.itemid == 2160 then
			doChangeTypeItem(item.uid, item.type-1)
			doPlayerAddItem(cid, 2152, 100)
			doSendAnimatedText(frompos, "$$$", 89)
		end
	else
		doPlayerSendCancel(cid, "Only premium players can change gold.")
	end		

	return TRUE
end
