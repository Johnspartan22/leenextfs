local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Load the PaymentSystem module (update the path if necessary)
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

-- Standard keywords such as job, name, and time
keywordHandler:addKeyword({'job'}, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I sell runes, wands, and rods."})
keywordHandler:addKeyword({'name'}, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I am Dark Rodo."})
keywordHandler:addKeyword({'time'}, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "It is exactly |TIME|."})

-- Items available for sale (wands, rods, etc.)
local items = {
    ['inferno'] = { id = 2187, price = 15000000 },
    ['plague'] = { id = 2188, price = 5000000 },
    ['cosmic energy'] = { id = 2189, price = 10000000 },
    ['vortex'] = { id = 2190, price = 500000 },
    ['dragonbreath'] = { id = 2191, price = 1000000 },
    ['quagmire'] = { id = 2181, price = 10000000 },
    ['snakebite'] = { id = 2182, price = 500000 },
    ['tempest'] = { id = 2183, price = 15000000 },
    ['volcanic'] = { id = 2185, price = 5000000 },
    ['moonlight'] = { id = 2186, price = 1000000 },
}

-- Runes (these support quantity purchase)
local runes = {
    ['hmm'] = { id = 2311, price = 10000 },
    ['uh'] = { id = 2273, price = 50000 },
    ['gfb'] = { id = 2304, price = 20000 },
    ['explosion'] = { id = 2313, price = 20000 },
    ['sd'] = { id = 2268, price = 100000 },
    ['manarune'] = { id = 2310, price = 10000 },
    ['mediummana'] = { id = 2261, price = 50000 },
    ['massivemana'] = { id = 2271, price = 100000 }, -- You'll need to add the correct item ID
    ['wrath'] = { id = 2300, price = 100000 },
    ['blank'] = { id = 2260, price = 5000 }
}

-- Backpack item ID (adjust as needed for your server)
local BACKPACK_ID = 1988 -- Standard brown backpack, adjust if different

-- Helper function to format price.
-- If a number is an exact multiple of one million, do not show a decimal.
local function formatPrice(value)
    if value >= 1000000 then
        if value % 1000000 == 0 then
            return string.format("%d million", value / 1000000)
        else
            return string.format("%.1f million", value / 1000000)
        end
    else
        return string.format("%d thousand", value / 1000)
    end
end

-- Main conversation callback
-- We'll use a per-cid talkState; for rune purchases, talkState stores the item name.
local talkState = {}

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = string.lower(msg)

    if msgcontains(msg, "hi") then
        npcHandler:say("Hello " .. getCreatureName(cid) .. "! I sell runes, wands, and rods. You can ask for 'runes', 'wands', 'rods', or 'bp runes' to know more.", cid)
        talkState[cid] = nil

    elseif msgcontains(msg, "bye") then
        npcHandler:say("Good bye, " .. getCreatureName(cid) .. "!", cid)
        npcHandler:releaseFocus(cid)
        talkState[cid] = nil

    elseif msgcontains(msg, "runes") then
        npcHandler:say('I sell hmms (10k), uhs (50k), gfbs (20k), explosions (20k), sds (100k), manarunes (10k), mediummana (100k), massivemana (200k), wrath (100k), and blank runes (5k). To buy, say for example "100 sd" or "bp manarune".', cid)

    elseif msgcontains(msg, "wands") then
        npcHandler:say('I sell inferno (15 million), plague (5 million), cosmic energy (10 million), vortex (500k), and dragonbreath (1 million).', cid)

    elseif msgcontains(msg, "rods") then
        npcHandler:say('I sell quagmire (10 million), snakebite (500k), tempest (15 million), volcanic (5 million), and moonlight rod (1 million).', cid)

    elseif msgcontains(msg, "bp runes") then
        npcHandler:say('I can sell backpacks full of runes. Available are: bp manarune, bp mediummana, bp massivemana. Each backpack contains 36 runes.', cid)

    else
        -- First, check for backpack purchases
        local bpRune = msg:match("^bp%s+(.+)$")
        if bpRune and runes[bpRune] then
            local runePrice = runes[bpRune].price
            local totalPrice = runePrice * 36 * 100  -- 36 runes in a backpack
            local priceText = formatPrice(totalPrice)
            npcHandler:say("Do you want to buy a backpack of " .. bpRune .. " for " .. priceText .. " gold coins?", cid)
            talkState[cid] = { 
                type = "backpack", 
                name = bpRune, 
                quantity = 36, 
                totalPrice = totalPrice 
            }
            return true
        end

        -- Then, check for individual rune or item purchases (existing code remains the same)
        local quantity, itemName = msg:match("^(%d+)%s+(.+)$")
        if quantity then
            quantity = tonumber(quantity)
        else
            quantity = 1
            itemName = msg
        end

        -- Check for rune purchase first
        local rune = runes[itemName]
        if rune then
            local totalPrice = rune.price * quantity
            local priceText = formatPrice(totalPrice)
            npcHandler:say("Do you want to buy " .. quantity .. " " .. itemName .. " for " .. priceText .. " gold coins?", cid)
            talkState[cid] = { type = "rune", name = itemName, quantity = quantity, totalPrice = totalPrice }
            return true
        end
        
        -- Then check for the regular items (wands or rods) purchase; these are one per purchase
        local item = items[itemName]
        if item then
            local priceText = formatPrice(item.price)
            npcHandler:say("Do you want to buy " .. itemName .. " for " .. priceText .. " gold coins?", cid)
            talkState[cid] = { type = "item", name = itemName, quantity = 1, totalPrice = item.price }
            return true
        end
    end

    -- Confirmation branch: if the player answers "yes" or "no" when talkState is set.
    if talkState[cid] then
        if msgcontains(msg, "yes") then
            local purchase = talkState[cid]
            -- For backpacks, runes, and regular items, use PaymentSystem integration.
            if PaymentSystem.canPlayerPay(cid, purchase.totalPrice) then
                if PaymentSystem.processPayment(cid, purchase.totalPrice) then
                    if purchase.type == "backpack" then
                        -- Create a backpack with runes
                        local backpack = doCreateItemEx(BACKPACK_ID, 1)
                        local runeId = runes[purchase.name].id
                        
                        -- Fill backpack with runes
                        for i = 1, purchase.quantity do
                            doAddContainerItem(backpack, runeId, 100)
                        end
                        
                        -- Add backpack to player's inventory
                        if doPlayerAddItemEx(cid, backpack) == RETURNVALUE_NOERROR then
                            npcHandler:say("Here is your backpack of " .. purchase.name .. ".", cid)
                        else
                            npcHandler:say("You don't have enough space in your inventory.", cid)
                            -- Refund the payment
                            PaymentSystem.refundPayment(cid, purchase.totalPrice)
                        end

                    elseif purchase.type == "rune" then
                        if doPlayerAddItem(cid, runes[purchase.name].id, purchase.quantity) then
                            npcHandler:say("Here are your " .. purchase.quantity .. " " .. purchase.name .. ".", cid)
                        else
                            npcHandler:say("You don't have enough space in your inventory.", cid)
                        end

                    elseif purchase.type == "item" then
                        if doPlayerAddItem(cid, items[purchase.name].id, 1) then
                            npcHandler:say("Here is your " .. purchase.name .. ".", cid)
                        else
                            npcHandler:say("You don't have enough space in your inventory.", cid)
                        end
                    end
                else
                    npcHandler:say("There was an error processing your payment. Please try again.", cid)
                end
            else
                npcHandler:say("You don't have enough money.", cid)
            end
            talkState[cid] = nil
            return true

        elseif msgcontains(msg, "no") then
            npcHandler:say("Alright then.", cid)
            talkState[cid] = nil
            return true
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())