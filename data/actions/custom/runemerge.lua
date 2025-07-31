function onUse(cid, item, frompos, item2, topos)

-- Rune merger by Alreth - 2nd edition
if item.uid == 6999 then
rune1pos = {x=156, y=73, z=6, stackpos=1}
rune1 = getThingfromPos(rune1pos)
rune2pos = {x=157, y=73, z=6, stackpos=1}
rune2 = getThingfromPos(rune2pos)

if (item.itemid == 1945) then
if (rune1.itemid >= 2261 and rune1.itemid <= 2316) then
if (getPlayerMana(cid) < 20) then
doPlayerSendTextMessage(cid, 22, "You need 2000 mana to perform this merge this.")
else
if (rune1.itemid == rune2.itemid) then
doPlayerAddMana(cid, -2000)
rune1x = rune1.type
rune2x = rune2.type

if (rune1x == 0) then
rune1x = 1
end
if (rune2x == 0) then
rune2x = 1
end

runetotal = rune1x + rune2x
if (runetotal <= 200) then
newrune1 = runetotal
newrune2 = 0
else
newrune1 = 200
newrune2 = runetotal-200
doPlayerSendTextMessage(cid, 22, "The new merged rune can not have more than 200 charges. One full rune will be made and one with restoring charges.")
end

if (newrune1 > 0) then
doCreateItem(rune1.itemid, newrune1, rune1pos)
end
if (newrune2 > 0) then
doCreateItem(rune1.itemid, newrune2, rune2pos)
end

doRemoveItem(rune1.uid, rune1.type)
doRemoveItem(rune2.uid, rune2.type)
doSendMagicEffect(rune1pos, 11)
doSendMagicEffect(rune2pos, 11)
doSendMagicEffect(getPlayerPosition(cid), 14)
doTransformItem(item.uid, item.itemid + 1)
else
doPlayerSendTextMessage(cid, 22, "Runes missmatch. Put two runes of the same type on each basin.")
end
end
else
doPlayerSendTextMessage(cid, 22, "You can only merge runes together.")
end

elseif (item.itemid == 1946) then
doTransformItem(item.uid, item.itemid - 1)

else
doPlayerSendTextMessage(cid, 22, "Sorry, not possible.")

end

end
-- end of rune merger script --

end