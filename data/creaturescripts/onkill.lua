-- creaturescripts/scripts/onkill.lua

function onKill(cid, target, lastHit)
    if not isPlayer(cid) then
        return true
    end
    
    if not isMonster(target) then
        return true
    end
    
    -- Check if player has an active task
    local taskActive = getPlayerStorageValue(cid, 980150) -- STORAGE.TASK_ACTIVE
    if taskActive ~= 1 then
        return true
    end
    
    -- Load TaskManager and process the kill
    local status, err = pcall(function()
        local TaskManager = dofile('data/npc/lib/task/task_manager.lua')
        if not TaskManager then
            error("Failed to load TaskManager")
            return
        end
        
        local taskManager = TaskManager:new()
        if not taskManager then
            error("Failed to create TaskManager instance")
            return
        end
        
        taskManager:handleKill(cid, target)
    end)
    
    if not status then
        print("Error processing task: " .. tostring(err))
    end
    
    return true
end