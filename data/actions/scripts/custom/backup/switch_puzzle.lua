function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Local constants
    local preGatePos = {x = 1693, y = 693, z = 8, stackpos = 1}
    local mainGatePos = {x = 1693, y = 690, z = 8, stackpos = 1}
    local PUZZLE_STORAGE = 89541  -- Storage for puzzle state
    
    local switchMapping = {
        [3401] = 1,  -- First switch
        [3402] = 2,  -- Second switch
        [3403] = 3,  -- Third switch
        [3404] = 4   -- Fourth switch
    }

    -- Get current step from storage
    local currentStep = getPlayerStorageValue(cid, PUZZLE_STORAGE)
    if currentStep < 0 then currentStep = 0 end

    local switchNumber = switchMapping[item.actionid]
    if not switchNumber then 
        return false 
    end
    
    -- Toggle switch state with delay
if item.itemid == 1945 then  -- Switch OFF state
    addEvent(function()
        doTransformItem(item.uid, 1946)
    end, 2000)
        
        -- First switch (opens first gate)
        if currentStep == 0 and switchNumber == 1 then
            local preGate = getThingfromPos(preGatePos)
            doRemoveItem(getThingfromPos(preGatePos).uid)
            doSendMagicEffect(preGatePos, 2)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "A distant echo of grinding metal resounds through the dungeon.")
            setPlayerStorageValue(cid, PUZZLE_STORAGE, 1)
            addEvent(function() -- Delay before switch returns
                doTransformItem(item.uid, 1945)
            end, 2000)
            return true
        end
        
        -- Third switch
        if currentStep == 1 and switchNumber == 3 then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The gears of an ancient mechanism groan into motion, then fall silent.")
            setPlayerStorageValue(cid, PUZZLE_STORAGE, 2)
            addEvent(function()
                doTransformItem(item.uid, 1945)
            end, 2000)
            return true
        end
        
        -- Second switch
        if currentStep == 2 and switchNumber == 2 then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "A sharp click pierces the air, as if another piece of the puzzle has fallen into place.")
            setPlayerStorageValue(cid, PUZZLE_STORAGE, 3)
            addEvent(function()
                doTransformItem(item.uid, 1945)
            end, 2000)
            return true
        end
        
        -- Fourth switch (opens final gate)
        if currentStep == 3 and switchNumber == 4 then
            local mainGate = getThingfromPos(mainGatePos)
            doRemoveItem(mainGate.uid)
            doSendMagicEffect(mainGatePos, 1)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The final lock disengages with a thunderous clang, revealing the path ahead.")
            setPlayerStorageValue(cid, PUZZLE_STORAGE, 0)  -- Reset puzzle
            
            addEvent(function() -- Switch return delay
                doTransformItem(item.uid, 1945)
            end, 2000)
            
            -- Set delayed gate closure
            addEvent(function()
                local preGate = getThingfromPos(preGatePos)
                if preGate.itemid == 0 then
                    doCreateItem(1544, 1, preGatePos)
                end
                
                local mainGate = getThingfromPos(mainGatePos)
                if mainGate.itemid == 0 then
                    doCreateItem(1544, 1, mainGatePos)
                end
                
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The gates slam shut with an ominous finality, sealing the chamber once more.")
            end, 2 * 60 * 1000)  -- 2 minutes in milliseconds
            
            return true
        end
        
        -- Wrong switch - reset everything
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "A deafening crash echoes through the chamber as the mechanism snaps back into place, resetting your progress")
        setPlayerStorageValue(cid, PUZZLE_STORAGE, 0)
        
        -- Replace gates
        local preGate = getThingfromPos(preGatePos)
        if preGate.itemid == 0 then
            doCreateItem(1544, 1, preGatePos)
        end
        
        local mainGate = getThingfromPos(mainGatePos)
        if mainGate.itemid == 0 then
            doCreateItem(1544, 1, mainGatePos)
        end
        
        addEvent(function() -- Switch return delay even on wrong switch
            doTransformItem(item.uid, 1945)
        end, 2000)
        
    end
    
    return true
end