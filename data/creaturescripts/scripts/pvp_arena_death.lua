function onPrepareDeath(cid, deathList)
    print("onPrepareDeath triggered for " .. getCreatureName(cid)) -- Debug line
    -- Define the arena area
    local arenaMin = {x = 147, y = 63, z = 4} -- Top-left corner
    local arenaMax = {x = 167, y = 71, z = 4} -- Bottom-right corner
    local teleportTo = {x = 163, y = 72, z = 4} -- Thais temple

    local pos = getCreaturePosition(cid)
    print("Player position: x=" .. pos.x .. ", y=" .. pos.y .. ", z=" .. pos.z) -- Debug line

    if pos.x >= arenaMin.x and pos.x <= arenaMax.x and
       pos.y >= arenaMin.y and pos.y <= arenaMax.y and
       pos.z == arenaMin.z then
        print("Player died in arena!") -- Debug line
        
        -- Set health and mana to maximum
        doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
        doPlayerAddMana(cid, getPlayerMaxMana(cid))
        
        -- Teleport and effects
        doTeleportThing(cid, teleportTo)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You were defeated in the PvP Arena and teleported out!")
        doSendMagicEffect(teleportTo, CONST_ME_TELEPORT)
        return false
    end

    print("Player died outside arena.") -- Debug line
    return true
end