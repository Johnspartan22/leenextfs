function onUse(cid, item, fromPosition, itemEx, toPosition)
    local rewards = {2092, 2087, 2091, 2090, 2089, 2088, 2086} -- List of item IDs to be given as rewards
    local reward = rewards[math.random(1, #rewards)] -- Randomly select a reward
    local count = 1 -- Number of items to give

    doPlayerAddItem(cid, reward, count) -- Give the player the reward
    doRemoveItem(item.uid, 1) -- Remove the mystery box

    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have received a key!") -- Send a message to the player
    return true
end