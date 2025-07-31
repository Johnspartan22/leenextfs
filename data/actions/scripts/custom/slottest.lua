-- Function to check if player can afford
function canPlayerPay(cid, amount)
    local flawless_count = getPlayerItemCount(cid, ITEM_FLAWLESS_SKULL)
    local chipped_count = getPlayerItemCount(cid, ITEM_CHIPPED_SKULL)
    local money = getPlayerMoney(cid)
    
    -- Calculate total value
    local total_value = (flawless_count * 100000000) + (chipped_count * 1000000) + money
    return total_value >= amount
end

function handleMoneyRemoval(cid, cost)
    if not canPlayerPay(cid, cost) then
        return false
    end

    local remaining_cost = cost
    
    -- Try regular money first (lowest denomination)
    local money = getPlayerMoney(cid)
    if money > 0 then
        local moneyToRemove = math.min(money, remaining_cost)
        doPlayerRemoveMoney(cid, moneyToRemove)
        remaining_cost = remaining_cost - moneyToRemove
        
        if remaining_cost == 0 then
            return true
        end
    end
    
    -- Try Chipped Skulls next
    local chipped_count = getPlayerItemCount(cid, ITEM_CHIPPED_SKULL)
    if chipped_count > 0 and remaining_cost >= 100000 then
        local skulls_needed = math.min(chipped_count, math.ceil(remaining_cost / 1000000))
        if doPlayerRemoveItem(cid, ITEM_CHIPPED_SKULL, skulls_needed) then
            local change = (skulls_needed * 1000000) - remaining_cost
            if change > 0 then
                doPlayerAddMoney(cid, change)
            end
            remaining_cost = 0
            return true
        end
    end
    
    -- Try Flawless Skulls last (highest denomination)
    local flawless_count = getPlayerItemCount(cid, ITEM_FLAWLESS_SKULL)
    if flawless_count > 0 and remaining_cost >= 1000000 then
        local skulls_needed = math.min(flawless_count, math.ceil(remaining_cost / 100000000))
        if doPlayerRemoveItem(cid, ITEM_FLAWLESS_SKULL, skulls_needed) then
            local change = (skulls_needed * 100000000) - remaining_cost
            if change > 0 then
                -- Give change as chipped skulls and money
                local chipped_skulls = math.floor(change / 1000000)
                local remaining_money = change % 1000000
                if chipped_skulls > 0 then
                    doPlayerAddItem(cid, ITEM_CHIPPED_SKULL, chipped_skulls)
                end
                if remaining_money > 0 then
                    doPlayerAddMoney(cid, remaining_money)
                end
            end
            return true
        end
    end
    
    return false
end

function addLargeMoney(cid, amount)
    -- Add Flawless Skulls
    local flawless_skulls = math.floor(amount / 100000000)
    if flawless_skulls > 0 then
        doPlayerAddItem(cid, ITEM_FLAWLESS_SKULL, flawless_skulls)
        amount = amount % 100000000
    end
    
    -- Add Chipped Skulls
    local chipped_skulls = math.floor(amount / 1000000)
    if chipped_skulls > 0 then
        doPlayerAddItem(cid, ITEM_CHIPPED_SKULL, chipped_skulls)
        amount = amount % 1000000
    end
    
    -- Add remaining money
    if amount > 0 then
        doPlayerAddMoney(cid, amount)
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Cost per spin
    local spinCost = 10000000  -- 10 million
    local regularWinAmount = 20000000 -- 20 million
    local jackpotAmount = 1000000000 -- 1 billion (1000 million)
    
    -- Check if player can afford the spin
    if not canPlayerPay(cid, spinCost) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You need 10 million gold to play the slot machine.")
        return false
    end
    
    -- Remove the money
    if not handleMoneyRemoval(cid, spinCost) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "There was an error processing your payment.")
        return false
    end
    
    -- Send magic effect
    doSendMagicEffect(fromPosition, 43)
    
    -- Generate random number between 1 and 10000 (for more precision with rare events)
    local chance = math.random(1, 10000)
    
    -- Set winning chances
    local jackpotChance = 1     -- 0.01% chance (1 in 10,000)
    local regularWinChance = 4200  -- 9% chance (900 in 10,000)
    
    -- Create table of losing item IDs
    local losingItems = {4334, 4335, 4336}
    
    -- Store position for reset
    local itemPos = {x = fromPosition.x, y = fromPosition.y, z = fromPosition.z}
    local originalItemId = 4388  -- Original slot machine ID
    local transformedItemId
    
    -- Check for jackpot win (very rare)
    if chance <= jackpotChance then
        -- Player wins jackpot
        transformedItemId = 4333
        doTransformItem(item.uid, transformedItemId)
        
        -- Add jackpot amount using skulls and money
        addLargeMoney(cid, jackpotAmount)
        
        -- Send win message
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "MEGA JACKPOT! You won 1000 million gold!")
        
        -- Broadcast the win to all players
        doBroadcastMessage(getCreatureName(cid) .. " just won the MEGA JACKPOT of 1000 million gold on the slot machine!", MESSAGE_STATUS_WARNING)
    
    -- Check for regular win
    elseif chance <= (jackpotChance + regularWinChance) then
        -- Player wins regular prize
        transformedItemId = 4333
        doTransformItem(item.uid, transformedItemId)
        
        -- Add regular win amount
        addLargeMoney(cid, regularWinAmount)
        
        -- Send win message
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Congratulations! You won 20 million gold!")
    
    else
        -- Player loses
        transformedItemId = losingItems[math.random(1, #losingItems)]
        doTransformItem(item.uid, transformedItemId)
        
        -- Send lose message
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Sorry, better luck next time!")
    end
    
    -- Schedule reset after 3 seconds using position
    addEvent(function()
        -- Transform back to original
        local thing = getTileItemById(itemPos, transformedItemId)
        if thing.uid > 0 then
            doTransformItem(thing.uid, originalItemId)
        end
    end, 3000)
    
    return true
end