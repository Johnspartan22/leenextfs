local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Constants for item IDs
local ITEM_FLAWLESS_SKULL = 2229
local ITEM_CHIPPED_SKULL = 2320
local ITEM_UNDERWORLD_TOKEN = 2151

-- Storage constants
local STORAGE = {
    TASK_ACTIVE = 980150,
    TASK_TYPE = 980151,
    TASK_PROGRESS = 980154,
    TASK_REPEAT_COUNT = 980155  -- New storage for tracking repeats
}

-- OTServ event handling functions
function onCreatureAppear(cid)        npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)     npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                    npcHandler:onThink()                   end

-- Load task configuration
local TaskConfig = dofile('data/npc/lib/task/task_config.lua')

------------------------------------------------------------
-- Helper Function: Format numbers with million/billion suffix
------------------------------------------------------------
local function formatNumber(amount)
    if amount >= 1000000000 then
        local billions = math.floor(amount / 1000000000)
        return billions .. " billion"
    elseif amount >= 1000000 then
        local millions = math.floor(amount / 1000000)
        return millions .. " million"
    else
        return tostring(amount)
    end
end

------------------------------------------------------------
-- Helper Function: Get reward preview text
------------------------------------------------------------
local function getRewardPreview(task, isRepeat)
    local rewards = {}
    
    if task.reward.exp then
        local exp = isRepeat and math.floor(task.reward.exp / 2) or task.reward.exp
        table.insert(rewards, formatNumber(exp) .. " experience")
    end
    
    if task.reward.skulls then
        local count = isRepeat and math.ceil(task.reward.skulls.count / 2) or task.reward.skulls.count
        local skullName = task.reward.skulls.id == ITEM_FLAWLESS_SKULL and "flawless skull" or "chipped skull"
        table.insert(rewards, count .. " " .. skullName .. (count > 1 and "s" or ""))
    end
    
    if task.reward.tokens then
        local tokens = isRepeat and math.ceil(task.reward.tokens / 2) or task.reward.tokens
        table.insert(rewards, tokens .. " underworld token" .. (tokens > 1 and "s" or ""))
    end
    
    return table.concat(rewards, " and ")
end

------------------------------------------------------------
-- Helper Function: Start a task if allowed for a player
------------------------------------------------------------
local function startTask(cid, taskId)
    if getPlayerStorageValue(cid, STORAGE.TASK_ACTIVE) == 1 then
        return false, "active"
    end
    
    local task = TaskConfig.tasks[taskId]
    local repeatCount = getPlayerStorageValue(cid, task.completionStorage)
    
    -- If task was completed before
    if repeatCount == 1 then
        -- Ask for confirmation about reduced reward
        return false, "repeat"
    end

    -- Register the kill event
    registerCreatureEvent(cid, "TaskKill")

    setPlayerStorageValue(cid, STORAGE.TASK_ACTIVE, 1)
    setPlayerStorageValue(cid, STORAGE.TASK_TYPE, taskId)
    setPlayerStorageValue(cid, STORAGE.TASK_PROGRESS, 0)
    
    local rewardPreview = getRewardPreview(task, false)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE,
        string.format("Task accepted: Kill %d %s for %s. Good luck!", 
        task.count, task.monster, rewardPreview))
    return true
end

------------------------------------------------------------
-- Get available tasks for a given category (exp or money)
------------------------------------------------------------
local function getAvailableTasks(cid, category)
    local playerLevel = getPlayerLevel(cid)
    local availableTasks = {}
    local suggestedTask = nil
    local minLevelDiff = math.huge

    for taskId, task in ipairs(TaskConfig.tasks) do
        local isCorrectCategory = (category == "exp" and task.reward.exp) or
                                 (category == "money" and task.reward.skulls)

        -- We now show all tasks, even completed ones
        if isCorrectCategory and playerLevel >= task.minLevel then
            -- Add task without reward preview
            table.insert(availableTasks, {
                id = taskId, 
                task = task
            })
            
            local levelDiff = playerLevel - task.minLevel
            if levelDiff >= 0 and levelDiff < minLevelDiff then
                minLevelDiff = levelDiff
                suggestedTask = task
            end
        end
    end

    return availableTasks, suggestedTask
end

------------------------------------------------------------
-- Get a category-specific message listing available tasks
------------------------------------------------------------
local function getCategoryMessage(cid, category)
    local availableTasks, suggestedTask = getAvailableTasks(cid, category)

    if #availableTasks == 0 then
        return "You don't meet the level requirements for any " .. category .. " tasks yet."
    end

    local message = "Available " .. category .. " tasks:\n"
    for _, taskData in ipairs(availableTasks) do
        -- Show just the task name and level requirement
        message = message .. "- {" .. string.lower(taskData.task.name) .. "} (Level " ..
                  taskData.task.minLevel .. ")\n"
    end

    if suggestedTask then
        message = message .. "\nSuggested task: {" .. string.lower(suggestedTask.name) .. "}"
    end
    return message
end

------------------------------------------------------------
-- Register basic keyword responses
------------------------------------------------------------
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am the hunter master; I hand out monster hunting tasks."
})

keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am Grizzly Adams, the master hunter."
})

keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "It is exactly |TIME|."
})

keywordHandler:addKeyword({'task'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I offer {exp} and {money} tasks. Which interests you?"
})

keywordHandler:addKeyword({'tasks'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I offer {exp} and {money} tasks. Which interests you?"
})

------------------------------------------------------------
-- Main Conversation Callback
------------------------------------------------------------
local function creatureSayCallback(cid, msgtype, msg)
    if not npcHandler:isFocused(cid) then 
        return false 
    end
    msg = string.lower(msg)

    -- Check for pending task confirmation (yes/no)
    if npcHandler.topic[cid] then
        if type(npcHandler.topic[cid]) == "table" then
            if npcHandler.topic[cid].pendingTask then
                if msg == "yes" then
                    local taskId = npcHandler.topic[cid].pendingTask
                    local task = TaskConfig.tasks[taskId]
                    local playerLevel = getPlayerLevel(cid)
                    if playerLevel >= task.minLevel then
                        local success, reason = startTask(cid, taskId)
                        if success then
                            npcHandler.topic[cid] = 0
                        elseif reason == "repeat" then
                            -- Show reduced reward warning
                            npcHandler.topic[cid] = { pendingRepeat = taskId }
                            local normalReward = getRewardPreview(task, false)
                            local reducedReward = getRewardPreview(task, true)
                            npcHandler:say(string.format("You have already completed this task before. Normal reward would be: %s. If you repeat it, you will only receive: %s. Do you still want to accept it? (yes/no)", normalReward, reducedReward), cid)
                        elseif reason == "active" then
                            npcHandler:say("You already have an active task. Complete it first!", cid)
                            npcHandler.topic[cid] = 0
                        end
                    else
                        npcHandler:say(string.format("You need to be at least level %d to take this task. Try saying {tasks} to see what's available.", task.minLevel), cid)
                        npcHandler.topic[cid] = 0
                    end
                    return true
                elseif msg == "no" then
                    npcHandler:say("Maybe next time then.", cid)
                    npcHandler.topic[cid] = 0
                    return true
                end
            elseif npcHandler.topic[cid].pendingRepeat then
                if msg == "yes" then
                    local taskId = npcHandler.topic[cid].pendingRepeat
                    local task = TaskConfig.tasks[taskId]
                    
                    -- Start the repeat task
                    registerCreatureEvent(cid, "TaskKill")
                    setPlayerStorageValue(cid, STORAGE.TASK_ACTIVE, 1)
                    setPlayerStorageValue(cid, STORAGE.TASK_TYPE, taskId)
                    setPlayerStorageValue(cid, STORAGE.TASK_PROGRESS, 0)
                    
                    local rewardPreview = getRewardPreview(task, true)
                    npcHandler:say(string.format("Very well. Kill %d %s for %s. Good luck!", 
                        task.count, task.monster, rewardPreview), cid)
                    npcHandler.topic[cid] = 0
                elseif msg == "no" then
                    npcHandler:say("Maybe try a different task then.", cid)
                    npcHandler.topic[cid] = 0
                end
                return true
            end
        end
    end

    -- Regular greetings and farewells
    if msgcontains(msg, 'hi') then
        npcHandler:say("Hello " .. getCreatureName(cid) .. "! Would you like a task? You can choose {exp} or {money} tasks. Which do you prefer?", cid)
        npcHandler.topic[cid] = 0
        return true

    elseif msgcontains(msg, 'bye') then
        npcHandler:say("Happy hunting, " .. getCreatureName(cid) .. "!", cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = nil
        return true

    elseif msg == "exp" then
        npcHandler:say(getCategoryMessage(cid, "exp"), cid)
        return true

    elseif msg == "money" then
        npcHandler:say(getCategoryMessage(cid, "money"), cid)
        return true

    else
        -- Check if player mentioned any task name
        for taskId, task in ipairs(TaskConfig.tasks) do
            local taskName = string.lower(task.name)
            if msg:find("%f[%a]" .. taskName .. "%f[%A]") then
                local playerLevel = getPlayerLevel(cid)
                if playerLevel >= task.minLevel then
                    npcHandler.topic[cid] = { pendingTask = taskId }
                    local rewardPreview = getRewardPreview(task, false)
                    npcHandler:say(string.format("Do you want to accept the task to kill %d %s for %s? (yes/no)", 
                        task.count, task.monster, rewardPreview), cid)
                else
                    npcHandler:say(string.format("You need to be at least level %d to take this task. Try saying {tasks} to see what's available.", task.minLevel), cid)
                end
                return true
            end
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())