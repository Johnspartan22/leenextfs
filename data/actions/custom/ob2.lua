function onUse(cid, item, frompos, item2, topos)
piece1pos = {x=930, y=338, z=7, stackpos=255}
getpiece1 = getThingfromPos(piece1pos)
playerpos = getPlayerPosition(cid)
nplayer1pos = {x=1003, y=343, z=7}
 
if item.uid == 6367 and item.itemid == 1945 and getpiece1.itemid == 2346 then
      playerpos = getPlayerPosition(cid)
            doSendMagicEffect(playerpos,2)
      doTeleportThing(cid,nplayer1pos)
            doSendMagicEffect(nplayer1pos,11)
 doRemoveItem(getpiece1.uid,1)
 else
doPlayerSendTextMessage(cid,22,"Sorry, you need the right item.")
end
return 1
end