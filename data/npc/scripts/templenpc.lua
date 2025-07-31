local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)       npcHandler:onCreatureAppear(cid)       end
function onCreatureDisappear(cid)    npcHandler:onCreatureDisappear(cid)    end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                   npcHandler:onThink()                   end

-- Standard greetings and farewell messages
npcHandler:setMessage(MESSAGE_GREET, "Ah... another living soul enters my domain. *grips scythe* Welcome, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Run along, mortal. Your time will come... eventually.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "They always leave... but they always return, in the end.")

-- Basic keywords with morbid responses
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am Death itself, the collector of souls. When mortals breathe their last, I am there to guide them to their final rest."
})
keywordHandler:addKeyword({'temple'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "This temple stands between the realm of the living and the dead. Many souls pass through here on their final journey... as will you, eventually."
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I am known by many names - Death, the Grim Reaper. But you may call me Mortis. Though I doubt you'll need to call me... I'll find you when your time comes."
})
keywordHandler:addKeyword({'time'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Time... a concept that matters only to the living. But since you ask, it is |TIME|. Your own time... well, that's not for you to know."
})
keywordHandler:addKeyword({'death'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Death is my domain, mortal. I've guided countless souls across the veil, and I will continue to do so until the last star fades."
})
keywordHandler:addKeyword({'soul'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Ah, souls... they come in all shapes and sizes. Some bright, some dark, some barely there at all. Yours seems... interesting."
})
keywordHandler:addKeyword({'help'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Help? *chuckles coldly* I'm afraid the only help I provide is... final. Though your time hasn't come yet, mortal."
})
keywordHandler:addKeyword({'life'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Life is but a brief candle, soon to be snuffed out. I've watched countless flames flicker and fade... it's quite beautiful, in its way."
})
keywordHandler:addKeyword({'blessing'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Blessings? *laughs grimly* No blessing can shield you from me forever, mortal. When your time comes, I will be there."
})
keywordHandler:addKeyword({'scythe'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "My trusty companion through countless harvests of souls. Its edge is ever-sharp, though you need not concern yourself with that... yet."
})
keywordHandler:addKeyword({'goodbye'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Farewell, mortal. Until our... final meeting."
})
keywordHandler:addKeyword({'dead'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "The dead are my constant companions. Their whispers fill these halls, speaking of regrets and unfinished business. Would you like to hear their tales? *grins darkly*"
})
keywordHandler:addKeyword({'mortal'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Yes, you are indeed mortal. I can see the thread of your life, slowly unwinding... but fear not, it still has length to it. For now."
})

npcHandler:addModule(FocusModule:new())