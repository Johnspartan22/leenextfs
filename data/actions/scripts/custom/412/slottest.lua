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
    
    -- Try Flawless Skulls first
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
    
    -- Try Chipped Skulls
    local chipped_count = getPlayerItemCount(cid, ITEM_CHIPPED_SKULL)
    if chipped_count > 0 and remaining_cost >= 100000 then
        local skulls_needed = math.min(chipped_count, math.ceil(remaining_cost / 1000000))
        if doPlayerRemoveItem(cid, ITEM_CHIPPED_SKULL, skulls_needed) then
            local change = (skulls_needed * 1000000) - remaining_cost
            if change > 0 then
                doPlayerAddMoney(cid, change)
            end
            return true
        end
    end
    
    -- Try regular money
    if doPlayerRemoveMoney(cid, cost) then
        return true
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
    local winAmount = 70000000 -- 70 million
    
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
    
    -- Generate random number between 1 and 100
    local chance = math.random(1, 100)
    
    -- Set winning chance (5% chance to win)
    local winningChance = 9
    
    -- Create table of losing item IDs
    local losingItems = {4334, 4335, 4336}
    
    -- Store position for reset
    local itemPos = {x = fromPosition.x, y = fromPosition.y, z = fromPosition.z}
    local originalItemId = 4388  -- Original slot machine ID
    local transformedItemId
    
    -- Check if player won
    if chance <= winningChance then
        -- Player wins
        transformedItemId = 4333
        doCreateItem(transformedItemId, 1, fromPosition)
        doRemoveItem(item.uid)
        
        -- Add winning amount using skulls and money
        addLargeMoney(cid, winAmount)
        
        -- Send win message
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Congratulations! You won 70 million gold!")
    else
        -- Player loses
        transformedItemId = losingItems[math.random(1, #losingItems)]
        doCreateItem(transformedItemId, 1, fromPosition)
        doRemoveItem(item.uid)
        
        -- Send lose message
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Sorry, better luck next time!")
    end
    
    -- Schedule reset after 3 seconds using position
    addEvent(function()
        -- Remove the transformed item and create the original
        local thing = getTileItemById(itemPos, transformedItemId)
        if thing.uid > 0 then
            doRemoveItem(thing.uid)
            doCreateItem(originalItemId, 1, itemPos)
        end
    end, 3000)
    
    return true
end