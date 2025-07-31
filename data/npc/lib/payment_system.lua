-- Payment System for NPC transactions with mixed currency change for OTX 3.8

-- Ensure these constants are defined somewhere (in your XML or another config):
-- ITEM_FLAWLESS_SKULL = (your flawless skull item id)
-- ITEM_CHIPPED_SKULL   = (your chipped skull item id)

local VAL_FLAWLESS = 100000000
local VAL_CHIPPED  = 1000000

PaymentSystem = {}

-- Function to check if the player has enough overall funds.
PaymentSystem.canPlayerPay = function(cid, amount)
   local flawless_count = getPlayerItemCount(cid, ITEM_FLAWLESS_SKULL)
   local chipped_count  = getPlayerItemCount(cid, ITEM_CHIPPED_SKULL)
   local money          = getPlayerMoney(cid)
   
   local total_value = (flawless_count * VAL_FLAWLESS) + (chipped_count * VAL_CHIPPED) + money
   return total_value >= amount
end

-- Helper function to return change in mixed currency.
PaymentSystem.giveChange = function(cid, change)
   print("DEBUG: Giving change of " .. change .. " to player " .. cid)
   
   -- Calculate number of flawless skulls to give back
   local numFlawless = math.floor(change / VAL_FLAWLESS)
   change = change - (numFlawless * VAL_FLAWLESS)
   print("DEBUG: Flawless skulls: " .. numFlawless .. ", remaining: " .. change)
   
   -- Calculate number of chipped skulls to give back
   local numChipped = math.floor(change / VAL_CHIPPED)
   change = change - (numChipped * VAL_CHIPPED)
   print("DEBUG: Chipped skulls: " .. numChipped .. ", remaining: " .. change)

   if numFlawless > 0 then
      print("DEBUG: Adding " .. numFlawless .. " flawless skulls")
      doPlayerAddItem(cid, ITEM_FLAWLESS_SKULL, numFlawless)
   end
   if numChipped > 0 then
      print("DEBUG: Adding " .. numChipped .. " chipped skulls")
      doPlayerAddItem(cid, ITEM_CHIPPED_SKULL, numChipped)
   end
   if change > 0 then
      print("DEBUG: Adding " .. change .. " gold coins")
      doPlayerAddMoney(cid, change)
   end
   
   print("DEBUG: Change distribution complete")
end

-- Process payment: first use coins; if not enough, use skull items.
-- If an item's full value is not completely needed, provide change in mixed currency.
PaymentSystem.processPayment = function(cid, amount)
   -- Use available coins first
   local coins = getPlayerMoney(cid)
   if coins >= amount then
      doPlayerRemoveMoney(cid, amount)
      return true
   end

   -- Remove all coins and set remainder to be covered by skull items.
   doPlayerRemoveMoney(cid, coins)
   local remaining = amount - coins

   -- Process in order: flawless skulls then chipped skulls.
   local denominations = {
      { item = ITEM_FLAWLESS_SKULL, value = VAL_FLAWLESS },
      { item = ITEM_CHIPPED_SKULL,  value = VAL_CHIPPED }
   }
   
   for _, denom in ipairs(denominations) do
      local count = getPlayerItemCount(cid, denom.item)
      while remaining > 0 and count > 0 do
         -- Check if one unit of this denomination overpays the remainder
         if remaining < denom.value then
            -- Remove one item
            doPlayerRemoveItem(cid, denom.item, 1)
            -- Calculate overpayment (change) to return
            local change = denom.value - remaining
            PaymentSystem.giveChange(cid, change)
            remaining = 0  -- Payment complete
            count = count - 1
         else
            -- Use whole items without overpaying
            local numNeeded = math.floor(remaining / denom.value)
            if numNeeded > count then
               numNeeded = count
            end
            if numNeeded > 0 then
               doPlayerRemoveItem(cid, denom.item, numNeeded)
               remaining = remaining - (numNeeded * denom.value)
               count = count - numNeeded
            else
               break  -- No more items to reduce remaining cost in this denomination
            end
         end
      end
      if remaining == 0 then
         break  -- Payment fully processed
      end
   end

   -- If after processing denominations the remaining cost is 0 then the payment succeeded.
   return (remaining == 0)
end

return PaymentSystem
