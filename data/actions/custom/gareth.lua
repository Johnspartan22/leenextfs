-- Action script for examining Gareth's body
-- Place this in data/actions/scripts/ directory and register it in actions.xml

local BODY_ITEM_ID = 2317
local EVIDENCE_ITEM_ID = 2128
local QUEST_STORAGE = 567843  -- Same as questProgressStorage in the NPC script
local BODY_SEARCH_STORAGE = 567844  -- New storage to track if player has searched the body

function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Check if the player is at the right stage of the quest
    local questProgress = getPlayerStorageValue(cid, QUEST_STORAGE)
    
    if questProgress ~= 3 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You find nothing of interest.")
        return true
    end
    
    -- Check if the player has already searched the body
    local hasSearched = getPlayerStorageValue(cid, BODY_SEARCH_STORAGE)
    
    if hasSearched == 1 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have already searched this body thoroughly.")
        return true
    end
    
    -- Give the evidence item
    if doPlayerAddItem(cid, EVIDENCE_ITEM_ID, 1) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You found Gareth's guild token. You should present this to aldric.")
        setPlayerStorageValue(cid, BODY_SEARCH_STORAGE, 1)
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You found something, but you don't have enough capacity to carry it.")
    end
    
    return true
end