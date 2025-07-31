function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Check if the item being used is a bucket
    if item.itemid ~= 2005 then
        return false
    end
    
    -- Check if it's a water bucket (typically type 1 or a specific actionid)
    -- You may need to adjust this check based on your server's implementation
    if item.type ~= 1 then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_SMALL, "This bucket is empty.")
        return true
    end
    
    -- List of fire item IDs to check against
    local fireItems = {
        1488, 1489, 1490, 1491, -- Common fire IDs
        1492, 1493, 1494,       -- More fire variations
        1500, 1501              -- Campfires
        -- Add any other fire item IDs your server uses
    }
    
    -- Check if the target item is a fire
    local isFireItem = false
    for _, fireId in ipairs(fireItems) do
        if itemEx.itemid == fireId then
            isFireItem = true
            break
        end
    end
    
    -- If the target is not a fire, show an error message
    if not isFireItem then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_SMALL, "You can only pour water on fire.")
        return true
    end
    
    -- Remove the fire
    doRemoveItem(itemEx.uid)
    
    -- Show a poff effect (EFFECT_POFF = 2)
    doSendMagicEffect(toPosition, 2)
    
    -- Transform water bucket to empty bucket (same ID but type 0)
    doTransformItem(item.uid, 2005, 0)
    
    -- Send message to player
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You extinguished the fire.")
    
    return true
end