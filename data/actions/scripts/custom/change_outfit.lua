function onUse(cid, item, fromPosition, itemEx, toPosition)
    local excludedOutfits = {12, 11, 46, 47, 1, 20, 98, 96, 143, 97, 146, 147, 132, 92, 77, 141, 137, 139, 73, 150, 75, 136, 129, 133, 130, 140, 138, 142, 131, 134, 93, 149, 148, 145, 135, 128, 72}
    local additionalOutfits = {158, 160, 159, 171, 231, 237, 238, 274} -- Add your desired outfit numbers here
    local randomOutfit
    
    local function isExcluded(outfit)
        for _, value in ipairs(excludedOutfits) do
            if value == outfit then
                return true
            end
        end
        return false
    end
    
    local function getRandomOutfit()
        -- 30% chance to get an outfit from the additional outfits list
        if math.random(100) <= 10 then
            return additionalOutfits[math.random(#additionalOutfits)]
        end
        
        -- 70% chance to get a regular outfit (1-150)
        repeat
            randomOutfit = math.random(1, 150)
        until not isExcluded(randomOutfit)
        return randomOutfit
    end
    
    local randomOutfit = getRandomOutfit()
    local outfit = {lookType = randomOutfit}
    doCreatureChangeOutfit(cid, outfit)
    doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your outfit was changed!")
    doRemoveItem(item.uid, 1)
    return true
end