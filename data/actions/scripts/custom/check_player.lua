function onUse(cid, item, frompos, item2, topos)
    if not isCreature(cid) then 
        return false
    end
    
    -- First try target from position
    local target = getTopCreature(topos)
    local targetPlayer
    
    if target and isPlayer(target.uid) then
        targetPlayer = target.uid
    elseif item2 and isPlayer(item2.uid) then
        targetPlayer = item2.uid
    else
        targetPlayer = cid
    end
    
    if not isPlayer(targetPlayer) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, 'No valid target found.')
        return false
    end

    -- Get player info
    local name = getCreatureName(targetPlayer)
    local health = getCreatureHealth(targetPlayer)  
    local maxHealth = getCreatureMaxHealth(targetPlayer)
    local mana = getPlayerMana(targetPlayer)
    local maxMana = getPlayerMaxMana(targetPlayer)

    local message = string.format("Target: %s\nHealth: %d/%d\nMana: %d/%d", 
        name, health, maxHealth, mana, maxMana)
        
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, message)
    return true
end