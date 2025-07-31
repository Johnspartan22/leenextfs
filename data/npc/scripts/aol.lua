local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Load the PaymentSystem script
local PaymentSystem = dofile("data/npc/lib/payment_system.lua")

function onCreatureAppear(cid)
    npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
    npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
    npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
    npcHandler:onThink()
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    if not player then
        return false
    end

    msg = msg:lower()

    if msgcontains(msg, 'hi') then
        npcHandler:say('Hello ' .. player:getName() .. '! I sell amulets of loss, labels, and parcels.', cid)
    elseif msgcontains(msg, 'bye') then
        npcHandler:say('Good bye, ' .. player:getName() .. '!', cid)
        npcHandler:releaseFocus(cid)
    elseif msgcontains(msg, 'job') then
        npcHandler:say('I work in this Depot. I sell amulets of loss, labels, and parcels, and keep the depot clean for you.', cid)
    elseif msgcontains(msg, 'name') then
        npcHandler:say('I am Dufi.', cid)
    elseif msgcontains(msg, 'time') then
        npcHandler:say('It is exactly ' .. os.date('%X') .. '.', cid)
    else
        local items = {
            ['aol'] = {id = 2173, price = 50000},
            ['amulet of loss'] = {id = 2173, price = 50000},
            ['label'] = {id = 2599, price = 5},
            ['parcel'] = {id = 2595, price = 10}
        }

        local item = items[msg]
        if item then
            -- Check if the player has sufficient funds via our PaymentSystem
            if PaymentSystem.canPlayerPay(cid, item.price) then
                -- First remove the money (or the conversion of items→money) from the player
                if PaymentSystem.processPayment(cid, item.price) then
                    -- Only after the payment is processed, try to add the item.
                    if player:addItem(item.id, 1) then
                        npcHandler:say('Here is your ' .. ItemType(item.id):getName() .. '.', cid)
                    else
                        npcHandler:say('You don\'t have enough space in your inventory for the item.', cid)
                        -- Optional: Here, you might implement a refund mechanism if needed.
                    end
                else
                    npcHandler:say('An error occurred processing your payment.', cid)
                end
            else
                npcHandler:say('You do not have enough funds.', cid)
            end
            return true
        end
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())