local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Load the PaymentSystem script
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                    end

-- Standard keywords
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I manage bounties on players. Say 'bounty' to place one."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am the Bounty Master."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Say 'bounty' to place a bounty on another player. Available amounts range from 10 million to 10 billion gold."})

-- Global variables
local talkState = {}
local bountyAmount = {}
local bountyTarget = {}

-- Bounty options with natural language keys and display formats
local bountyOptions = {
    -- Original amounts with red skulls
    ["10m"] = {cost = 10000000, items = {id = 2320, count = 10}, display = "10 million"},
    ["20m"] = {cost = 20000000, items = {id = 2320, count = 20}, display = "20 million"},
    ["30m"] = {cost = 30000000, items = {id = 2320, count = 30}, display = "30 million"},
    ["40m"] = {cost = 40000000, items = {id = 2320, count = 40}, display = "40 million"},
    
    -- New higher amounts with flawless skulls
    ["100m"] = {cost = 100000000, items = {id = 2229, count = 1}, display = "100 million"},
    ["500m"] = {cost = 500000000, items = {id = 2229, count = 5}, display = "500 million"},
    ["1b"] = {cost = 1000000000, items = {id = 2229, count = 10}, display = "1 billion"},
    ["2b"] = {cost = 2000000000, items = {id = 2229, count = 20}, display = "2 billion"},
    ["5b"] = {cost = 5000000000, items = {id = 2229, count = 50}, display = "5 billion"},
    ["10b"] = {cost = 10000000000, items = {id = 2229, count = 100}, display = "10 billion"}
}

-- Maps for looking up options by cost or string
local bountyByInput = {}  -- For accepting various input formats
local bountyByCost = {}   -- For looking up by cost

-- Initialize the lookup maps
for key, data in pairs(bountyOptions) do
    bountyByCost[data.cost] = data
    
    -- Support multiple input formats (10m, 10 m, 10 million, etc.)
    bountyByInput[key] = data
    bountyByInput[key:gsub("m", " million")] = data
    bountyByInput[key:gsub("b", " billion")] = data
    bountyByInput[key:gsub("m", "kk")] = data
    bountyByInput[key:gsub("b", "kkk")] = data
end

function getBountyOptionsText()
    local options = {}
    for key, data in pairs(bountyOptions) do
        if key:find("m$") or key:find("b$") then
            table.insert(options, data.display)
        end
    end
    table.sort(options, function(a, b)
        local valA = tonumber(a:match("^%d+"))
        local valB = tonumber(b:match("^%d+"))
        local unitA = a:match("[mb]")
        local unitB = b:match("[mb]")
        
        if unitA == unitB then
            return valA < valB
        else
            return unitA == "m"
        end
    end)
    return table.concat(options, ", ")
end

function placeBounty(cid, target, bountyData)
    local player = Player(cid)
    if not player then
        return false, "Error: Player not found."
    end

    -- Use PaymentSystem instead of direct money removal
    if not PaymentSystem.canPlayerPay(cid, bountyData.cost) then
        return false, "You don't have enough money."
    end

    if not PaymentSystem.processPayment(cid, bountyData.cost) then
        return false, "Error processing payment."
    end

    -- Store both item_id and item_count
    db.query(string.format("INSERT INTO `bounties` (`target`, `amount`, `placed_by`, `item_id`, `item_count`) VALUES (%s, %d, %s, %d, %d)",
        db.escapeString(target:lower()), 
        bountyData.cost, 
        db.escapeString(player:getName():lower()),
        bountyData.items.id,
        bountyData.items.count))
    
    -- Clean broadcast message without the skull reference
    Game.broadcastMessage(string.format("[Bounty Hunter] %s has placed a bounty of %s on %s's head!", 
        player:getName(), bountyData.display, target), MESSAGE_STATUS_WARNING)
    return true
end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    if not player then
        return false
    end

    msg = string.lower(msg)

    -- Initialize talk state if needed
    if not talkState[cid] then
        talkState[cid] = 0
    end

    if msgcontains(msg, 'bounty') then
        local optionsText = getBountyOptionsText()
        npcHandler:say('Would you like to place a bounty? Available amounts are: ' .. optionsText .. '.', cid)
        talkState[cid] = 1
        return true

    elseif talkState[cid] == 1 then
        -- Check if the input matches any of our bounty options
        local bountyData = bountyByInput[msg]
        
        -- Try to match various formats
        if not bountyData then
            -- Try to normalize the input
            local normalized = msg:gsub("%s+", ""):gsub("million", "m"):gsub("billions?", "b")
            bountyData = bountyByInput[normalized]
        end
        
        if bountyData then
            bountyAmount[cid] = bountyData
            npcHandler:say('Who would you like to place the bounty on?', cid)
            talkState[cid] = 2
        else
            local optionsText = getBountyOptionsText()
            npcHandler:say('Please choose a valid amount: ' .. optionsText .. '.', cid)
        end
        return true

    elseif talkState[cid] == 2 then
        bountyTarget[cid] = msg
        
        -- Clean confirmation message without the skull reference
        npcHandler:say(string.format('You want to place a bounty of %s on %s? Say yes to confirm.', 
            bountyAmount[cid].display, msg), cid)
        talkState[cid] = 3
        return true

    elseif talkState[cid] == 3 then
        if msgcontains(msg, 'yes') then
            local success, error = placeBounty(cid, bountyTarget[cid], bountyAmount[cid])
            if success then
                npcHandler:say('The bounty has been placed successfully!', cid)
            else
                npcHandler:say(error, cid)
            end
        else
            npcHandler:say('Bounty placement cancelled.', cid)
        end
        
        -- Reset the conversation
        talkState[cid] = 0
        bountyAmount[cid] = nil
        bountyTarget[cid] = nil
        return true
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())