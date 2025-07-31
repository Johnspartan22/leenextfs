function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Define positions for the gates
    local preGatePos = {x = 1693, y = 693, z = 8, stackpos = 1}
    local mainGatePos = {x = 1693, y = 690, z = 8, stackpos = 1}
    
    -- Storage keys for puzzle steps and busy state
    local PUZZLE_STORAGE = 89541  -- Tracks which step the puzzle is on
    local busyStorage = 89542     -- Used to mark the current switch as “busy”

    -- Map each switch (by actionid) to a step number
    local switchMapping = {
        [3401] = 1,  -- First switch
        [3402] = 2,  -- Second switch
        [3403] = 3,  -- Third switch
        [3404] = 4   -- Fourth switch
    }

    -- Retrieve the current step for the player; if not set, defaults to 0
    local currentStep = getPlayerStorageValue(cid, PUZZLE_STORAGE)
    if currentStep < 0 then 
        currentStep = 0 
    end

    -- Determine the switch number based on its actionid
    local switchNumber = switchMapping[item.actionid]
    if not switchNumber then 
        return false 
    end

    -- Check if the switch is busy (already processing a use), and if so, ignore new uses.
    if getPlayerStorageValue(cid, busyStorage) == 1 then
        return true
    end
    setPlayerStorageValue(cid, busyStorage, 1)

    -- Immediately change switch's appearance to the "on" state (itemid 1946)
    doTransformItem(item.uid, 1946)

    -- Helper function to reset the switch back to its "off" state after a delay
    local function resetSwitchState()
        doTransformItem(item.uid, 1945)
        setPlayerStorageValue(cid, busyStorage, -1)  -- Clear busy flag
    end

    -- Process puzzle logic according to the current step and which switch was used:
    
    -- First switch should be used at step 0 (set to step 1)
    if currentStep == 0 and switchNumber == 1 then
        local preGate = getThingfromPos(preGatePos)
        if preGate.itemid > 0 then
            doRemoveItem(preGate.uid)
        end
        doSendMagicEffect(preGatePos, 2)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "A distant echo of grinding metal resounds through the dungeon.")
        setPlayerStorageValue(cid, PUZZLE_STORAGE, 1)
        addEvent(resetSwitchState, 2000)
        return true

    -- Third switch should be used at step 1 (advance to step 2)
    elseif currentStep == 1 and switchNumber == 3 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The gears of an ancient mechanism groan into motion, then fall silent.")
        setPlayerStorageValue(cid, PUZZLE_STORAGE, 2)
        addEvent(resetSwitchState, 2000)
        return true

    -- Second switch should be used at step 2 (advance to step 3)
    elseif currentStep == 2 and switchNumber == 2 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "A sharp click pierces the air, as if another piece of the puzzle has fallen into place.")
        setPlayerStorageValue(cid, PUZZLE_STORAGE, 3)
        addEvent(resetSwitchState, 2000)
        return true

    -- Fourth switch should be used at step 3 (final switch: open final gate and reset puzzle)
    elseif currentStep == 3 and switchNumber == 4 then
        local mainGate = getThingfromPos(mainGatePos)
        if mainGate.itemid > 0 then
            doRemoveItem(mainGate.uid)
        end
        doSendMagicEffect(mainGatePos, 1)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The final lock disengages with a thunderous clang, revealing the path ahead.")
        setPlayerStorageValue(cid, PUZZLE_STORAGE, 0)  -- Reset puzzle steps
        addEvent(resetSwitchState, 2000)

        -- Schedule a delayed event to close the gates after 2 minutes (120000 ms)
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
        end, 2 * 60 * 1000)
        
        return true

    -- Any other switch press that doesn’t match the current step resets the puzzle.
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "A deafening crash echoes through the chamber as the mechanism snaps back into place, resetting your progress.")
        setPlayerStorageValue(cid, PUZZLE_STORAGE, 0)
        
        -- Replace the preGate if it was removed.
        local preGate = getThingfromPos(preGatePos)
        if preGate.itemid == 0 then
            doCreateItem(1544, 1, preGatePos)
        end
        
        -- Replace the mainGate if it was removed.
        local mainGate = getThingfromPos(mainGatePos)
        if mainGate.itemid == 0 then
            doCreateItem(1544, 1, mainGatePos)
        end

        addEvent(resetSwitchState, 2000)
        return true
    end
end