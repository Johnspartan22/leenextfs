-- Define rewards configuration table based on positions
local chestConfigs = {
    -- Format: ["x,y,z"] = { config }
    ["152,54,6"] = {
        requiredTokens = 2,
        tokenId = 2151,
        rewardId = 4845,
        rewardAmount = 1,
        description = "an outfit doll"  -- Optional: add description for messages
    },
    ["154,54,6"] = {
        requiredTokens = 5,
        tokenId = 2151,
        rewardId = 2331,
        rewardAmount = 1,
        description = "a mystery box"
    }, ["156,54,6"] = {
        requiredTokens = 650,
        tokenId = 2151,
        rewardId = 2298,
        rewardAmount = 1,
        description = "a 10 million manarune"
    }, ["168,54,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 2403,
        rewardAmount = 1,
        description = "a vanguard warblade"
    },["164,54,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 4366,
        rewardAmount = 1,
        description = "vanguard boots"
    },["162,54,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 2495,
        rewardAmount = 1,
        description = "vanguard greaves"
    },["158,54,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 2493,
        rewardAmount = 1,
        description = "a vanguard helmet"
    },["160,54,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 2494,
        rewardAmount = 1,
        description = "a vanguard armor"
    },["166,54,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 2520,
        rewardAmount = 1,
        description = "a vanguard shield"
    },["168,51,6"] = {
        requiredTokens = 75,
        tokenId = 2151,
        rewardId = 4367,
        rewardAmount = 1,
        description = "a key crate"
    },["166,51,6"] = {
        requiredTokens = 2,
        tokenId = 2151,
        rewardId = 4389,
        rewardAmount = 1,
        description = "a lucky potion"
    },["164,51,6"] = {
        requiredTokens = 1000,
        tokenId = 2151,
        rewardId = 4390,
        rewardAmount = 1,
        description = "midnight's cupcake"
    },["156,51,6"] = {
        requiredTokens = 1,
        tokenId = 2151,
        rewardId = 4352,
        rewardAmount = 1,
        description = "a rare candy"
    },["154,51,6"] = {
        requiredTokens = 350,
        tokenId = 2151,
        rewardId = 2229,
        rewardAmount = 100,
        description = "100 flawless skulls"
    },["152,51,6"] = {
        requiredTokens = 2,
        tokenId = 2151,
        rewardId = 3940,
        rewardAmount = 1,
        description = "an underworld backpack"
    },["156,45,6"] = {
        requiredTokens = 300,
        tokenId = 2151,
        rewardId = 4337,
        rewardAmount = 1,
        description = "an underworld hood"
    },["158,45,6"] = {
        requiredTokens = 300,
        tokenId = 2151,
        rewardId = 4338,
        rewardAmount = 1,
        description = "an underworld robe"
    },["160,45,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 4339,
        rewardAmount = 1,
        description = "an underworld staff"
    },["162,45,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 4340,
        rewardAmount = 1,
        description = "underworld leggings"
    },["164,45,6"] = {
        requiredTokens = 100,
        tokenId = 2151,
        rewardId = 4341,
        rewardAmount = 1,
        description = "underworld boots"
    },
    -- Add more chest configurations as needed
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Create position key
    local posKey = fromPosition.x .. "," .. fromPosition.y .. "," .. fromPosition.z
    
    -- Get the chest configuration based on position
    local config = chestConfigs[posKey]
    
    -- Check if this position has a valid configuration
    if not config then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "This chest is not properly configured.")
        return false
    end
    
    -- Check if player has enough tokens
    if getPlayerItemCount(cid, config.tokenId) >= config.requiredTokens then
        -- Remove tokens
        if doPlayerRemoveItem(cid, config.tokenId, config.requiredTokens) then
            -- Give reward item
            if doPlayerAddItem(cid, config.rewardId, config.rewardAmount) then
                local message = string.format("You have exchanged %d tokens for %s.", 
                    config.requiredTokens,
                    config.description or "your reward"
                )
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, message)
                return true
            else
                -- If inventory is full, return the tokens
                doPlayerAddItem(cid, config.tokenId, config.requiredTokens)
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You don't have enough space in your inventory.")
                return false
            end
        end
    else
        local message = string.format("You need %d underworld tokens to get %s.", 
            config.requiredTokens,
            config.description or "this reward"
        )
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, message)
        return false
    end
    
    return true
end