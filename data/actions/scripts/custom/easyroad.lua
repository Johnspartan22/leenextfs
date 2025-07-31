function onUse(cid, item, frompos, item2, topos)
    local piece1pos = {x=24, y=24, z=8, stackpos=255}
    local getpiece1 = getThingfromPos(piece1pos)  -- Fixed function name to lowercase 'f'
    local playerpos = getPlayerPosition(cid)
    local nplayer1pos = {x=346, y=383, z=8}
    
    -- Debug messages to help troubleshoot
    doPlayerSendTextMessage(cid, 22, "ActionID: " .. item.actionid)
    doPlayerSendTextMessage(cid, 22, "ItemID: " .. item.itemid)
    
    if getpiece1 then
        doPlayerSendTextMessage(cid, 22, "Altar item ID: " .. getpiece1.itemid)
    else
        doPlayerSendTextMessage(cid, 22, "No item found on altar")
    end
    
    -- Check for actionid 6370 and that it's a lever (itemid 1945)
    if item.actionid == 6370 and item.itemid == 1945 and getpiece1 and getpiece1.itemid == 2194 then
        doSendMagicEffect(playerpos, 2)
        doTeleportThing(cid, nplayer1pos)
        doSendMagicEffect(nplayer1pos, 10)
        doRemoveItem(getpiece1.uid, 1)
    else
        doPlayerSendTextMessage(cid, 22, "Sorry, you need the right item.")
    end
    return 1
end