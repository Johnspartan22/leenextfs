function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Configuration
    local wallPos = {x = 2180, y = 1020, z = 8, stackpos = 1} -- Replace with your wall coordinates
    local wallID = 1061 -- Replace with your wall ID (1544 is a common wall ID in Tibia)
    local duration = 15 * 60 * 1000 -- 5 minutes in milliseconds
    
    -- Check if the wall exists
    local wall = getThingfromPos(wallPos)
    if wall.itemid == 0 or wall.itemid ~= wallID then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "nothing interesting happens")
        return true
    end
    
    -- Transform the switch to "on" position
    doTransformItem(item.uid, 1946) -- 1946 is typically the "on" state for levers
    
    -- Remove the wall
    doRemoveItem(wall.uid)
    doSendMagicEffect(wallPos, 2) -- Magic effect (2 is blue puff)
    
    -- Send message to player
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "with a loud rumbling noise part of the wall crumbles.")
    
    -- Schedule the wall to reappear after 5 minutes
    addEvent(function()
        -- Check if the position is empty before creating a new wall
        local currentTile = getThingfromPos(wallPos)
        if currentTile.itemid == 0 then
            doCreateItem(wallID, 1, wallPos)
            doSendMagicEffect(wallPos, 2) -- Magic effect when wall reappears
        end
        
        -- Reset the switch back to "off" position
        doTransformItem(item.uid, 1945) -- 1945 is typically the "off" state for levers
    end, duration)
    
    return true
end