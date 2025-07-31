local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Constants for skull values and IDs
local VAL_FLAWLESS = 100000000     -- 100kk
local VAL_CHIPPED = 1000000        -- 1kk

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Helper Functions
local function formatPrice(value)
    if value >= 1000000 then
        return string.format("%.1f million", value / 1000000)
    elseif value >= 1000 then
        return string.format("%d thousand", value / 1000)
    else
        return tostring(value)
    end
end

local function givePayment(cid, amount)
    local numFlawless = math.floor(amount / VAL_FLAWLESS)
    amount = amount - (numFlawless * VAL_FLAWLESS)
    
    local numChipped = math.floor(amount / VAL_CHIPPED)
    amount = amount - (numChipped * VAL_CHIPPED)

    if numFlawless > 0 then
        doPlayerAddItem(cid, ITEM_FLAWLESS_SKULL, numFlawless)
    end
    if numChipped > 0 then
        doPlayerAddItem(cid, ITEM_CHIPPED_SKULL, numChipped)
    end
    if amount > 0 then
        doPlayerAddMoney(cid, amount)
    end
    
    return {
        flawless = numFlawless,
        chipped = numChipped,
        coins = amount
    }
end

local function formatPaymentMessage(payment)
    local parts = {}
    if payment.flawless > 0 then
        table.insert(parts, payment.flawless .. " flawless skull" .. (payment.flawless > 1 and "s" or ""))
    end
    if payment.chipped > 0 then
        table.insert(parts, payment.chipped .. " chipped skull" .. (payment.chipped > 1 and "s" or ""))
    end
    if payment.coins > 0 then
        table.insert(parts, payment.coins .. " gold coins")
    end
    return table.concat(parts, ", ")
end

-- Define gems to buy with their IDs and prices
local gems = {
    ["blackpearl"] = { id = 2144, price = 1000 },
    ["whitepearl"] = { id = 2143, price = 1000 },
    ["smalldiamond"] = { id = 2145, price = 1000 },
    ["smallsapphire"] = { id = 2146, price = 1000 },
    ["smallruby"] = { id = 2147, price = 1000 },
    ["smallemerald"] = { id = 2149, price = 1000 },
    ["smallamethyst"] = { id = 2150, price = 1000 },
    ["talon"] = { id = 2151, price = 2000 },
    ["violetgem"] = { id = 2153, price = 400000 },
    ["yellowgem"] = { id = 2154, price = 500000 },
    ["bigemerald"] = { id = 2155, price = 500000 },
    ["bigruby"] = { id = 2156, price = 200000 },
    ["bluegem"] = { id = 2158, price = 300000 },
    ["royalamulet"] = { id = 2139, price = 500000 },
    ["pheonixamulet"] = { id = 2141, price = 500000 },
    ["scarabcoin"] = { id = 2159, price = 5000 },
    ["brooch"] = { id = 4873, price = 5000 },
    ["goldnugget"] = { id = 2157, price = 5000 }
}

-- Add bulk purchases
local function addBulkGems()
    local bulkGems = {}
    -- Add 10x versions
    for name, info in pairs(gems) do
        -- Only add bulk for certain gems as in original script
        if name == "whitepearl" or name == "smalldiamond" or name == "smallsapphire" or
           name == "smallruby" or name == "smallemerald" or name == "smallamethyst" or
           name == "talon" or name == "goldnugget" or name == "scarabcoin" or name == "blackpearl" then
            
            local bulkName = "10" .. name
            bulkGems[bulkName] = {
                id = info.id,
                count = 10,
                price = info.price * 10
            }
        end
    end
    
    -- Add 100x versions
    for name, info in pairs(gems) do
        -- Only add bulk for certain gems as in original script
        if name == "whitepearl" or name == "smalldiamond" or name == "smallsapphire" or
           name == "smallruby" or name == "smallemerald" or name == "smallamethyst" or
           name == "talon" or name == "goldnugget" or name == "scarabcoin" or name == "blackpearl" then
            
            local bulkName = "100" .. name
            bulkGems[bulkName] = {
                id = info.id,
                count = 100,
                price = info.price * 100
            }
        end
    end
    
    return bulkGems
end

local bulkGems = addBulkGems()

-- Standard greeting
keywordHandler:addKeyword({'hi'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Arrrrr! I buy Gems Only!! Please State the gem you would like to sell with no spaces. Like so: smalldiamond, smallruby, whitepearl, blackpearl, talon, violetgem, bigruby, bigemerald, goldnugget, scarabcoin, bluegem, brooch. And with that said, I buy as many gems and as many types of gems as possible! Also use 10smalldiamond and 100smalldiamond, 10smallemerald 100smallemerald. And so on."
})

keywordHandler:addKeyword({'hello'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Arrrrr! I buy Gems Only!! Please State the gem you would like to sell with no spaces. Like so: smalldiamond, smallruby, whitepearl, blackpearl, talon, violetgem, bigruby, bigemerald, goldnugget, scarabcoin, bluegem, brooch. And with that said, I buy as many gems and as many types of gems as possible! Also use 10smalldiamond and 100smalldiamond, 10smallemerald 100smallemerald. And so on."
})

keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am a gem buyer. I will buy all your precious gems for good prices!"
})

keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I'm Jack, the gem trader."
})

keywordHandler:addKeyword({'bye'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Good bye, adventurer!",
    reset = true
})

keywordHandler:addKeyword({'farewell'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Good bye, adventurer!",
    reset = true
})

-- Function to create a sell callback for a gem
local function createSellCallback(gemName)
    return function(cid, message, keywords, parameters, node)
        if not npcHandler:isFocused(cid) then
            return false
        end
        
        local gemInfo
        local count = 1
        local bulkName = nil
        
        -- Check if this is a bulk purchase
        if bulkGems[gemName] then
            gemInfo = bulkGems[gemName]
            count = gemInfo.count
            bulkName = gemName
        else
            gemInfo = gems[gemName]
        end
        
        if not gemInfo then
            return false
        end
        
        local player = Player(cid)
        if not player then
            return false
        end
        
        if player:getItemCount(gemInfo.id) >= count then
            if player:removeItem(gemInfo.id, count) then
                local payment = givePayment(cid, gemInfo.price)
                
                local desc = count > 1 and count .. "x " .. gemName:gsub("^%d+", "") or gemName
                npcHandler:say("Thank you for the " .. desc .. "! Here's your payment: " .. formatPaymentMessage(payment) .. ".", cid)
            else
                npcHandler:say("Sorry, you don't have " .. (count > 1 and count .. " " or "a ") .. gemName:gsub("^%d+", "") .. " to sell.", cid)
            end
            return true
        else
            npcHandler:say("Sorry, you don't have " .. (count > 1 and count .. " " or "a ") .. gemName:gsub("^%d+", "") .. " to sell.", cid)
            return true
        end
    end
end

-- Register callbacks for all gems
for gemName, _ in pairs(gems) do
    keywordHandler:addKeyword({gemName}, createSellCallback(gemName))
end

-- Register callbacks for bulk gems
for bulkName, _ in pairs(bulkGems) do
    keywordHandler:addKeyword({bulkName}, createSellCallback(bulkName))
end

-- Function to handle the "gems" command - list all gems
keywordHandler:addKeyword({'gems'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I buy the following gems: blackpearl, whitepearl, smalldiamond, smallsapphire, smallruby, smallemerald, smallamethyst, talon, violetgem, yellowgem, bigemerald, bigruby, bluegem, royalamulet, pheonixamulet, scarabcoin, brooch, and goldnugget."
})

-- Function to handle the "bulk" command - explain bulk purchase
keywordHandler:addKeyword({'bulk'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "You can sell me multiple gems at once by saying '10' or '100' followed by the gem name, like '10smalldiamond' or '100blackpearl'. This works for most common gems."
})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    
    local player = Player(cid)
    if not player then
        return false
    end
    
    msg = string.lower(msg)
    
    -- If none of the keywords matched, inform the player
    npcHandler:say("I only buy gems. Say 'gems' to see what I buy or 'bulk' to learn about bulk sales.", cid)
    
    return true
end)

npcHandler:addModule(FocusModule:new())