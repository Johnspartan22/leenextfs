function onUse(cid, item, frompos, item2, topos) 
if item.itemid == 4380 then
rand = math.random(500000,1200000)
doPlayerAddMana(cid,rand)  
doSendMagicEffect(topos,13)   
doPlayerSendTextMessage(cid,22,"The magical fish has restored some of your mana...")
doRemoveItem(item.uid,1)
end
return 1
end