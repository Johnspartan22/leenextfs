function onUse(cid, item, fromPosition, itemEx, toPosition)
    local rewards = {2160, 2152, 2148, 2229, 2369, 2667, 2274, 2276, 2272, 1294} -- List of item IDs to be given as rewards
    local reward = rewards[math.random(1, #rewards)] -- Randomly select a reward
    local count = 1 -- Number of items to give

    doPlayerAddItem(cid, reward, count) -- Give the player the reward
    doRemoveItem(item.uid, 1) -- Remove the mystery box

    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have received a reward!") -- Send a message to the player
    return true
end