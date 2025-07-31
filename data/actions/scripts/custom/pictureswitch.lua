function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Wall position to remove (replace with your actual wall coordinates)
    local wallPos = {x = 2173, y = 1028, z = 8, stackpos = 1}
    
    -- Wall ID (replace with your actual wall ID)
    local wallID = 1060
    
    -- Duration for the wall to stay removed (5 minutes = 300 seconds)
    local duration = 15 * 60
    
    -- Check if the wall exists
    local wall = getThingfromPos(wallPos)
    if wall.itemid == 0 or wall.itemid ~= wallID then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "nothing interesting happens.")
        return true
    end
    
    -- Remove the wall
    doRemoveItem(wall.uid)
    
    -- Show effects
    doSendMagicEffect(wallPos, CONST_ME_POFF)
    doSendMagicEffect(toPosition, CONST_ME_MAGIC_BLUE) -- Effect at the picture
    
    -- Send message to player
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You found a hidden switch behind the picture. You hear a loud rumbling noise as a wall crumbles.")
    
    -- Make a rumbling sound in the area (optional)
    for x = -5, 5 do
        for y = -5, 5 do
            local pos = {x = toPosition.x + x, y = toPosition.y + y, z = toPosition.z}
            doSendMagicEffect(pos, CONST_ME_GROUNDSHAKER)
        end
    end
    
    -- Schedule the wall to reappear after the duration
    addEvent(function()
        -- Check if the position is empty before creating a new wall
        local currentTile = getThingfromPos(wallPos)
        if currentTile.itemid == 0 then
            doCreateItem(wallID, 1, wallPos)
            doSendMagicEffect(wallPos, CONST_ME_POFF)
        end
    end, duration * 1000)
    
    return true
end