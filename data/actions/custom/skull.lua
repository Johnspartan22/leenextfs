function onUse(cid, item, frompos, item2, topos)
   	if item.itemid == 2320 and item.type == 100 then
   		doRemoveItem(item.uid,item.type)
   		doPlayerAddItem(cid,2229,1)
   		doPlayerSendTextMessage(cid,22,"You have changed 100 chipped skulls into 1 flawless skull")
   	elseif item.itemid == 2320 and item.type < 100 then
   		doRemoveItem(item.uid,1)
   		doPlayerAddItem(cid,2160,100)
   		doPlayerSendTextMessage(cid,22,"You have changed 1 chipped skull into 100 crystal coins")
   	end
   end
