function onUse(cid, item, frompos, item2, topos)
if item.itemid == 2274 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,5)

elseif item.itemid == 2275 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,10)

elseif item.itemid == 2276 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,20)

elseif item.itemid == 2280 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,50)


elseif item.itemid == 2281 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,100)

elseif item.itemid == 2270 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,30)

elseif item.itemid == 2283 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,50)


elseif item.itemid == 2272 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,50)

elseif item.itemid == 2284 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,50)

elseif item.itemid == 2294 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,50)


elseif item.itemid == 2296 then

  doRemoveItem(item.uid,1)
  doPlayerAddItem(cid,2320,50)



end
  	doPlayerSendTextMessage(cid,22,"You have cashed in your gm token.")
end
