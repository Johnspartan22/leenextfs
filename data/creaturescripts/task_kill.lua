function onKill(creature, target)
    if not target:isMonster() then
        return true
    end

    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- Check if player has an active task
    local taskActive = player:getStorageValue(980150)  -- TASK_ACTIVE
    if taskActive ~= 1 then
        return true
    end

    -- Get task info
    local taskId = player:getStorageValue(980151)  -- TASK_TYPE
    local TaskConfig = dofile('data/npc/lib/task/task_config.lua')
    local task = TaskConfig.tasks[taskId]
    
    if not task then
        return true
    end

    -- Check if killed monster matches task monster
    if target:getName():lower() ~= task.monster:lower() then
        return true
    end

    -- Update progress
    local progress = player:getStorageValue(980154)  -- TASK_PROGRESS
    if progress < 0 then progress = 0 end
    
    local newProgress = progress + 1
    player:setStorageValue(980154, newProgress)

    -- If task is not complete yet, just show progress
    if newProgress < task.count then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 
            string.format("Task progress: %d/%d %s killed", newProgress, task.count, task.monster))
        return true
    end

    -- Task completed - check if this is a repeat
    local isRepeat = (player:getStorageValue(task.completionStorage) == 1)

    -- Give experience if part of reward
    if task.reward.exp then
        local exp = isRepeat and math.floor(task.reward.exp / 2) or task.reward.exp
        player:addExperience(exp)
    end

    -- Give skulls if part of reward
    if task.reward.skulls then
        local count = isRepeat and math.ceil(task.reward.skulls.count / 2) or task.reward.skulls.count
        if not player:addItem(task.reward.skulls.id, count) then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Not enough space for your skull reward!")
            return true
        end
    end

    -- Give tokens if part of reward
    if task.reward.tokens then
        local tokens = isRepeat and math.ceil(task.reward.tokens / 2) or task.reward.tokens
        if not player:addItem(2151, tokens) then
            -- Rollback skulls if token giving fails
            if task.reward.skulls then
                player:removeItem(task.reward.skulls.id, count)
            end
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Not enough space for your token reward!")
            return true
        end
    end

    -- Mark task as completed
    player:setStorageValue(task.completionStorage, 1)
    player:setStorageValue(980150, -1)  -- Clear TASK_ACTIVE
    player:setStorageValue(980151, -1)  -- Clear TASK_TYPE

    -- Build reward message
    local rewards = {}
    if task.reward.exp then
        local exp = isRepeat and math.floor(task.reward.exp / 2) or task.reward.exp
        table.insert(rewards, formatNumber(exp) .. " experience")
    end

    if task.reward.skulls then
        local count = isRepeat and math.ceil(task.reward.skulls.count / 2) or task.reward.skulls.count
        local skullName = task.reward.skulls.id == 2229 and "flawless skull" or "chipped skull"
        table.insert(rewards, count .. " " .. skullName .. (count > 1 and "s" or ""))
    end

    if task.reward.tokens then
        local tokens = isRepeat and math.ceil(task.reward.tokens / 2) or task.reward.tokens
        table.insert(rewards, tokens .. " token" .. (tokens > 1 and "s" or ""))
    end

    -- Helper function for number formatting
    local function formatNumber(amount)
        if amount >= 1000000000 then
            return math.floor(amount / 1000000000) .. " billion"
        elseif amount >= 1000000 then
            return math.floor(amount / 1000000) .. " million"
        else
            return tostring(amount)
        end
    end

    -- Send completion message
    local rewardMsg = string.format("Congratulations! %sTask completed! Received: %s",
        isRepeat and "Repeated " or "",
        table.concat(rewards, ", "))
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, rewardMsg)
    return true
end