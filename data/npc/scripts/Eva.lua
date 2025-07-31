local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Constants for skull values and IDs
local FLAWLESS_SKULL_VALUE = 100000000  -- 100 million (kk)
local CHIPPED_SKULL_VALUE = 1000000     -- 1 million (kk)


-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Helper function to format large numbers
local function formatNumber(amount)
    if amount >= 1000000000 then
        local billions = math.floor(amount / 1000000000)
        return billions .. " billion"
    elseif amount >= 1000000 then
        local millions = math.floor(amount / 1000000)
        return millions .. " million"
    else
        return tostring(amount)
    end
end

-- Helper function to parse amount from message
local function parseAmount(msg)
    local billion = msg:match("(%d+)%s*billion")
    if billion then
        return tonumber(billion) * 1000000000
    end
    local million = msg:match("(%d+)%s*million")
    if million then
        return tonumber(million) * 1000000
    end
    return tonumber(msg)
end

-- Helper function to get total funds including skulls
local function getPlayerTotalFunds(cid)
    local flawless = getPlayerItemCount(cid, ITEM_FLAWLESS_SKULL) or 0
    local chipped = getPlayerItemCount(cid, ITEM_CHIPPED_SKULL) or 0
    local money = getPlayerMoney(cid) or 0
    return (flawless * FLAWLESS_SKULL_VALUE) + (chipped * CHIPPED_SKULL_VALUE) + money
end

-- Conversation callback
function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local player = Player(cid)
    if not player then
        return false
    end

    msg = msg:lower()

    -- Basic responses
    if msgcontains(msg, 'job') then
        npcHandler:say("I work in this bank. I can handle your bank account.", cid)
    elseif msgcontains(msg, 'name') then
        npcHandler:say("I am Eva.", cid)
    elseif msgcontains(msg, 'time') then
        npcHandler:say("It is exactly " .. os.date('%X') .. ".", cid)
    
    -- Show account balance
    elseif msgcontains(msg, 'balance') then
        npcHandler:say("Your account balance is " .. formatNumber(player:getBankBalance()) .. " gold.", cid)
    
    -- Deposit all funds
    elseif msgcontains(msg, 'deposit all') then
        local totalFunds = getPlayerTotalFunds(cid)
        if totalFunds > 0 then
            if PaymentSystem.processPayment(cid, totalFunds) then
                player:setBankBalance(player:getBankBalance() + totalFunds)
                npcHandler:say("You have deposited " .. formatNumber(totalFunds) .. " gold.", cid)
            else
                npcHandler:say("There was an error processing your deposit.", cid)
            end
        else
            npcHandler:say("You don't have any money to deposit.", cid)
        end

    -- Deposit specific amount
    elseif msgcontains(msg, 'deposit') then
        npcHandler:say("Please tell me how much gold you would like to deposit.", cid)
        npcHandler.topic[cid] = 1

    elseif npcHandler.topic[cid] == 1 then
        local amount = parseAmount(msg)
        if not amount then
            npcHandler:say("Please tell me a valid amount.", cid)
            return true
        end
        
        if not PaymentSystem.canPlayerPay(cid, amount) then
            npcHandler:say("You don't have enough funds.", cid)
        else
            if PaymentSystem.processPayment(cid, amount) then
                player:setBankBalance(player:getBankBalance() + amount)
                npcHandler:say("You have deposited " .. formatNumber(amount) .. " gold.", cid)
            else
                npcHandler:say("There was an error processing your deposit.", cid)
            end
        end
        npcHandler.topic[cid] = 0

    -- Withdraw funds
    elseif msgcontains(msg, 'withdraw') then
        npcHandler:say("Please tell me how much gold you would like to withdraw.", cid)
        npcHandler.topic[cid] = 2

    elseif npcHandler.topic[cid] == 2 then
        local amount = parseAmount(msg)
        if not amount then
            npcHandler:say("Please tell me a valid amount.", cid)
            return true
        end
        
        if amount > player:getBankBalance() then
            npcHandler:say("You don't have enough gold in your bank account.", cid)
        else
            -- Calculate how many of each denomination to give
            local remaining = amount
            local items = {}
            
            -- First, calculate Flawless Skulls (100kk each)
            if remaining >= FLAWLESS_SKULL_VALUE then
                local flawlessCount = math.floor(remaining / FLAWLESS_SKULL_VALUE)
                remaining = remaining - (flawlessCount * FLAWLESS_SKULL_VALUE)
                table.insert(items, {id = ITEM_FLAWLESS_SKULL, count = flawlessCount})
            end
            
            -- Then, calculate Chipped Skulls (1kk each)
            if remaining >= CHIPPED_SKULL_VALUE then
                local chippedCount = math.floor(remaining / CHIPPED_SKULL_VALUE)
                remaining = remaining - (chippedCount * CHIPPED_SKULL_VALUE)
                table.insert(items, {id = ITEM_CHIPPED_SKULL, count = chippedCount})
            end
            
            -- Check if player has enough capacity and space
            local totalWeight = 0
            for _, item in ipairs(items) do
                local itemWeight = getItemWeight(item.id) * item.count
                totalWeight = totalWeight + itemWeight
            end
            
            if player:getFreeCapacity() < totalWeight then
                npcHandler:say("You don't have enough capacity to carry that much gold.", cid)
                return true
            end
            
            -- Process the withdrawal
            local canWithdraw = true
            
            -- Give items
            for _, item in ipairs(items) do
                if not player:addItem(item.id, item.count) then
                    canWithdraw = false
                    break
                end
            end
            
            -- Give remaining coins if any
            if remaining > 0 and canWithdraw then
                if not doPlayerAddMoney(cid, remaining) then
                    canWithdraw = false
                end
            end
            
            if canWithdraw then
                player:setBankBalance(player:getBankBalance() - amount)
                
                -- Create withdrawal message
                local withdrawMessage = "Here you are with "
                local itemDescriptions = {}
                
                for _, item in ipairs(items) do
                    if item.id == ITEM_FLAWLESS_SKULL then
                        table.insert(itemDescriptions, item.count .. " flawless skull" .. (item.count > 1 and "s" or ""))
                    elseif item.id == ITEM_CHIPPED_SKULL then
                        table.insert(itemDescriptions, item.count .. " chipped skull" .. (item.count > 1 and "s" or ""))
                    end
                end
                
                if remaining > 0 then
                    table.insert(itemDescriptions, formatNumber(remaining) .. " gold coins")
                end
                
                withdrawMessage = withdrawMessage .. table.concat(itemDescriptions, ", ") .. "."
                npcHandler:say(withdrawMessage, cid)
            else
                npcHandler:say("I cannot complete this withdrawal. Please make sure you have enough capacity and space in your inventory.", cid)
                -- Return any items that might have been given before the error
                for _, item in ipairs(items) do
                    player:removeItem(item.id, item.count)
                end
            end
        end
        npcHandler.topic[cid] = 0
    end
    
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())