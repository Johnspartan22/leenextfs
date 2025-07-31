function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Configuration
    local wallPos = {x = 1802, y = 682, z = 7}
    local wallID = 1547
    local duration = 60 * 60 * 1000 -- 60 minutes in milliseconds
    
    -- Find the wall by checking all items in the tile
    local wall = nil
    for i = 0, 255 do -- Check all possible stack positions
        wallPos.stackpos = i
        local thing = getThingfromPos(wallPos)
        if thing.itemid == wallID then
            wall = thing
            break
        end
        
        -- If we've reached the top of the stack, stop searching
        if thing.itemid == 0 then
            break
        end
    end
    
    -- If wall wasn't found, inform the player
    if not wall then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "nothing interesting happens")
        return true
    end
    
    -- Transform the switch to "on" position
    doTransformItem(item.uid, 1946)
    
    -- Remove the wall
    doRemoveItem(wall.uid)
    doSendMagicEffect(wallPos, 2)
    
    -- Send message to player
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You hear a gate open in the distance.")
    
    -- Schedule the wall to reappear after the duration
    addEvent(function()
        -- Check if we can place the wall back
        wallPos.stackpos = 0 -- Ground level
        local ground = getThingfromPos(wallPos)
        if ground.itemid ~= 0 then -- Make sure there's a ground tile
            doCreateItem(wallID, 1, wallPos)
            doSendMagicEffect(wallPos, 2)
        end
        
        -- Reset the switch back to "off" position
        doTransformItem(item.uid, 1945)
    end, duration)
    
    return true
end