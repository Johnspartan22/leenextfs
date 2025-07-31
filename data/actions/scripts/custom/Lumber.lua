function onUse(cid, item, frompos, item2, topos)
if
item2.itemid == 2703 then
rand = math.random(1,2000)
if rand < 900 then
doPlayerAddItem(cid,2194,1)
doSendMagicEffect(topos,4)
else
doPlayerSendCancel(cid,"You cannot lumber here.")
end
return 1
end
end