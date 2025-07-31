function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Create a unique storage key based on the item's unique ID
    local storageKey = 42110 + item.uid
    
    -- Get the current time
    local currentTime = os.time()
    
    -- Get the cooldown expiration time from global storage
    local cooldownUntil = getGlobalStorageValue(storageKey)
    if cooldownUntil == -1 then cooldownUntil = 0 end
    
    -- Check if the locker is on cooldown (20 minutes = 1200 seconds)
    if cooldownUntil > currentTime then
        -- Send message that nothing was found
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You don't find anything interesting.")
        return true
    end
    
    -- Set the new cooldown time (current time + 20 minutes)
    setGlobalStorageValue(storageKey, currentTime + 1200)
    
    -- Create a bucket (ID 2005, type 0 for empty bucket)
    if doPlayerAddItem(cid, 2005, 0) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You search the locker and found a bucket.")
        doSendMagicEffect(fromPosition, CONST_ME_MAGIC_BLUE)
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You search the locker and found a bucket, but you don't have enough capacity to carry it.")
    end
    
    return true
end