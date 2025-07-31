-- data/npc/lib/task/task_manager.lua

local TaskManager = {}
TaskManager.__index = TaskManager

function TaskManager:new()
    local self = setmetatable({}, TaskManager)
    self.config = dofile('data/npc/lib/task/task_config.lua')
    return self
end

function TaskManager:handleKill(cid, target)
    if not self.config or not self.config.tasks then
        print("Error: Task configuration not loaded properly")
        return false
    end
    
    local targetName = string.lower(getCreatureName(target))
    local taskType = getPlayerStorageValue(cid, 980151) -- TASK_TYPE
    
    if taskType < 1 or taskType > #self.config.tasks then
        print("Invalid task type: " .. taskType)
        return false
    end
    
    local currentTask = self.config.tasks[taskType]
    if not currentTask then
        print("Task not found for type: " .. taskType)
        return false
    end
    
    if string.lower(currentTask.monster) == targetName then
        local progress = getPlayerStorageValue(cid, 980154)
        if progress < 0 then progress = 0 end
        
        local newProgress = progress + 1
        setPlayerStorageValue(cid, 980154, newProgress)
        
        -- Send progress message
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 
            string.format("Task progress: %d/%d %ss killed", 
                newProgress, currentTask.count, currentTask.monster))
                
        -- Check if task is completed
        if newProgress >= currentTask.count then
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 
                "Task completed! Report back to Grizzly Adams for your reward!")
        end
        
        return true
    end
    
    return false
end

return TaskManager