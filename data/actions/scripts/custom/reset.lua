function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Send orange message to player
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Please wait for the machine to reset.")
    
    -- Return true to confirm the action was handled
    return true
end

-- Add to actions.xml:
-- <action itemid="YOUR_ITEM_ID" script="machinewait.lua"/>