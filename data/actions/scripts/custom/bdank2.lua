function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Configuration
    local wallPos = {x = 1837, y = 645, z = 8, stackpos = 1}
    local wallID = 1498
    local duration = 60 * 60 * 1000 -- 60 minutes in milliseconds
    
    -- Check the current state of the wall
    local wall = getThingfromPos(wallPos)
    
    -- If the wall is already gone, inform the player
    if wall.itemid == 0 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "nothing interesting happens")
        return true
    end
    
    -- If something else is in the wall position (not our wall), do nothing
    if wall.itemid ~= wallID then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "nothing interesting happens")
        return true
    end
    
    -- Transform the switch to "on" position
    doTransformItem(item.uid, 1946)
    
    -- Remove the wall
    doRemoveItem(wall.uid)
    doSendMagicEffect(wallPos, 2)
    
    -- Send message to player
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You hear a loud crack like lightning in the distance")
    
    -- Schedule the wall to reappear after the duration
    addEvent(function()
        -- Check if the position is empty before creating a new wall
        local currentTile = getThingfromPos(wallPos)
        if currentTile.itemid == 0 then
            doCreateItem(wallID, 1, wallPos)
            doSendMagicEffect(wallPos, 2)
        end
        
        -- Reset the switch back to "off" position
        doTransformItem(item.uid, 1945)
    end, duration)
    
    return true
end