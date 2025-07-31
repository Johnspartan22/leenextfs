function onUse(cid, item, fromPosition, itemEx, toPosition)
     if getPlayerStorageValue(cid, 59852) == -1 then
          setPlayerStorageValue(cid, 59852, 1)
          doPlayerAddItem(cid, 2229, 10)
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You found 10 flawless skulls")
     end
     return TRUE
end