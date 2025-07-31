function onUse(cid, item, frompos, item2, topos) 
if item.itemid == 2298 then
rand = math.random(10000000,12000000)
doPlayerAddMana(cid,rand)  
doSendMagicEffect(topos,13)   
end
return 1
end