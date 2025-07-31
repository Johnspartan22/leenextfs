function onUse(cid, item, fromPosition, itemEx, toPosition)
    for id, tileData in pairs(readableTiles) do
        if item.actionid == (90000 + id) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, tileData.text)
            return true
        end
    end
    return true
end