function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Make the player say something before teleporting
    doCreatureSay(cid, "Im outta here! Garden Grove Here I come", TALKTYPE_SAY)
    
    -- Get player's current position
    local playerPos = getCreaturePosition(cid)
    
    -- Define temple coordinates
    local temple = {x=144, y=193, z=7}
    
    -- Create teleport effect at both locations
    doSendMagicEffect(playerPos, 13)
    doTeleportThing(cid, temple)
    doSendMagicEffect(temple, 11)
    
    -- Send confirmation message to player
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have used a key of power.")
    
    return true
end