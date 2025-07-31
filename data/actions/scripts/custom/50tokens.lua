function onUse(cid, item, fromPosition, itemEx, toPosition)
     if getPlayerStorageValue(cid, 59852) == -1 then
          setPlayerStorageValue(cid, 59852, 1)
          doPlayerAddItem(cid, 2151, 50)
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You found 50 Underworld Tokens")
     end
     return TRUE
end