-- boss_system.lua
-- Boss spawning system for OTX 3.8 (TFS 1.3)
-- Configuration
local config = {
    spawnChance = 0.5,
    spawnDelay = 5000,
    
    -- Define the monster-to-boss name mappings
   bossNames = {
    ["Agent Smith"] = "Agent Smith Boss",
    ["Ancient Necropharus"] = "Ancient Necropharus Boss",
    ["Arch Angel"] = "Arch Angel Boss",
    ["ArchAngel"] = "ArchAngel Boss",
    ["Archdemon Kalius"] = "Archdemon Kalius Boss",
    ["Captain Jack"] = "Captain Jack Boss",
    ["Chuck Norris"] = "Chuck Norris Boss",
    ["Crypt Lord"] = "Crypt Lord Boss",
    ["Deck Hand"] = "Deck Hand Boss",
    ["Demonic Acolyte"] = "Demonic Acolyte Boss",
    ["Demonic Summoner"] = "Demonic Summoner Boss",
    ["Doom Lord"] = "Doom Lord Boss",
    ["Drukus The Dwarf"] = "Drukus the Dwarf Boss",
    ["Dwarf Geomancer"] = "Dwarf Geomancer Boss",
    ["Dwarf Guard"] = "Dwarf Guard Boss",
    ["Dwarf Soldier"] = "Dwarf Soldier Boss",
    ["Echoes Of Oblivion"] = "Echoes of oblivion Boss",
    ["Enraged Skeletor"] = "Enraged Skeletor Boss",
    ["Evil"] = "Evil Boss",
    ["Fallen Angel"] = "Fallen Angel Boss",
    ["Fire Storm"] = "Fire Storm Boss",
    ["First Mate"] = "First Mate Boss",
    ["Flesh Fiend"] = "Flesh Fiend Boss",
    ["Ghostly Visage"] = "Ghostly Visage Boss",
    ["God"] = "God Boss",
    ["Hell Screamer"] = "Hell Screamer Boss",
    ["Ice Cyclops"] = "Ice Cyclops Boss",
    ["Icelander"] = "Icelander Boss",
    ["Izual"] = "Izual Boss",
    ["Juggernaught"] = "Juggernaught Boss",
    ["Keeper Of The Abyss"] = "Keeper Of The Abyss Boss",
    ["Khartoum"] = "Khartoum Boss",
    ["Leprechaun"] = "Leprechaun Boss",
    ["Lizard King"] = "Lizard King Boss",
    ["Lucifer"] = "Lucifer Boss",
    ["Minotaur Archer"] = "Minotaur Archer Boss",
    ["Minotaur Guard"] = "Minotaur Guard Boss",
    ["Minotaur Mage"] = "Minotaur Mage Boss",
    ["Mutalisk"] = "Mutalisk Boss",
    ["Nefarious Acolyte"] = "Nefarious Acolyte Boss",
    ["Oblivination"] = "Oblivination Boss",
    ["Oblivion Badger"] = "Oblivion Badger Boss",
    ["Oblivion Chicken"] = "Oblivion Chicken Boss",
    ["Oblivion Dragon"] = "Oblivion Dragon Boss",
    ["Oblivion Slug"] = "Oblivion Slug Boss",
    ["Oblivion Tiger"] = "Oblivion Tiger Boss",
    ["OblivionMinion"] = "OblivionMinion Boss",
    ["Orc Berserker"] = "Orc Berserker Boss",
    ["Orc Leader"] = "Orc Leader Boss",
    ["Orc Shaman"] = "Orc Shaman Boss",
    ["Orc Spearman"] = "Orc Spearman Boss",
    ["Orc Warlord"] = "Orc Warlord Boss",
    ["Orc Warrior"] = "Orc Warrior Boss",
    ["Orc Rider"] = "Orc rider Boss",
    ["Petrified Hell Hound"] = "Petrified Hell Hound Boss",
    ["Pirate"] = "Pirate Boss",
    ["Relic The Seeker"] = "Relic The Seeker Boss",
    ["Skeletor"] = "Skeletor Boss",
    ["Soul Destroyer"] = "Soul Destroyer Boss",
    ["Soul King"] = "Soul King Boss",
    ["Souls Servent"] = "Souls Servent Boss",
    ["Sunspot"] = "Sunspot Boss",
    ["The Creator"] = "The Creator Boss",
    ["The Soul"] = "The Soul Boss",
    ["Tunneler"] = "Tunneler Boss",
    ["Ultralisk"] = "Ultralisk Boss",
    ["Vlad Tepes"] = "Vlad Tepes Boss",
    ["Abyssal Butterfly"] = "abyssal butterfly Boss",
    ["Amazon"] = "amazon Boss",
    ["Amazonian"] = "amazonian Boss",
    ["Ancient Scarab"] = "ancient scarab Boss",
    ["Ancient Necropharus"] = "ancient necropharus Boss",
    ["Angel"] = "angel Boss",
    ["Apocalypse"] = "apocalypse Boss",
    ["Ashmunrah"] = "ashmunrah Boss",
    ["Assasin"] = "assasin Boss",
    ["Assassin"] = "assassin Boss",
    ["Badger"] = "badger Boss",
    ["Bandit"] = "bandit Boss",
    ["Banshee"] = "banshee Boss",
    ["Bat"] = "bat Boss",
    ["Bazir"] = "bazir Boss",
    ["Bear"] = "bear Boss",
    ["Behemoth"] = "behemoth Boss",
    ["Beholder"] = "beholder Boss",
    ["Black Knight"] = "black knight Boss",
    ["Black Sheep"] = "black sheep Boss",
    ["Blackknight"] = "blackknight Boss",
    ["Blacksheep"] = "blacksheep Boss",
    ["Blue Djinn"] = "blue djinn Boss",
    ["Bluedjinn"] = "bluedjinn Boss",
    ["Bone Beast"] = "bone beast Boss",
    ["Bonebeast"] = "bonebeast Boss",
    ["Bug"] = "bug Boss",
    ["Butterfly"] = "butterfly Boss",
    ["Butterflyblue"] = "butterflyblue Boss",
    ["Butterflypurple"] = "butterflypurple Boss",
    ["Butterflyred"] = "butterflyred Boss",
    ["Butterflyyellow"] = "butterflyyellow Boss",
    ["Captain_Jack"] = "captain_jack Boss",
    ["Carniphila"] = "carniphila Boss",
    ["Caverat"] = "caverat Boss",
    ["Centipede"] = "centipede Boss",
    ["Chicken"] = "chicken Boss",
    ["Cobra"] = "cobra Boss",
    ["Crab"] = "crab Boss",
    ["Crocodile"] = "crocodile Boss",
    ["Crypt Shambler"] = "crypt shambler Boss",
    ["Cryptshambler"] = "cryptshambler Boss",
    ["Cyclops"] = "cyclops Boss",
    ["Dark Monk"] = "dark monk Boss",
    ["Darkmonk"] = "darkmonk Boss",
    ["Deathslicer"] = "deathslicer Boss",
    ["Deer"] = "deer Boss",
    ["Demodras"] = "demodras Boss",
    ["Demon"] = "demon Boss",
    ["Demonic_Summoner"] = "demonic_summoner Boss",
    ["Demonicsummoner"] = "demonicsummoner Boss",
    ["Demonskeleton"] = "demonskeleton Boss",
    ["Dharalion"] = "dharalion Boss",
    ["Dipthrah"] = "dipthrah Boss",
    ["Dog"] = "dog Boss",
    ["Dragon Lord"] = "dragon lord Boss",
    ["Dragon"] = "dragon Boss",
    ["Dragonlord"] = "dragonlord Boss",
    ["Dwarf"] = "dwarf Boss",
    ["Dwarfgeomancer"] = "dwarfgeomancer Boss",
    ["Dwarfguard"] = "dwarfguard Boss",
    ["Dwarfsoldier"] = "dwarfsoldier Boss",
    ["Dworcfleshhunter"] = "dworcfleshhunter Boss",
    ["Dworcvenomsniper"] = "dworcvenomsniper Boss",
    ["Dworcvoodoomaster"] = "dworcvoodoomaster Boss",
    ["Efreet"] = "efreet Boss",
    ["Elder Beholder"] = "elder beholder Boss",
    ["Elderbeholder"] = "elderbeholder Boss",
    ["Elephant"] = "elephant Boss",
    ["Elf"] = "elf Boss",
    ["Elfarcanist"] = "elfarcanist Boss",
    ["Elfscout"] = "elfscout Boss",
    ["Evileye"] = "evileye Boss",
    ["Fernfang"] = "fernfang Boss",
    ["Ferumbras"] = "ferumbras Boss",
    ["Firedevil"] = "firedevil Boss",
    ["Fireelemental"] = "fireelemental Boss",
    ["Flamethrower"] = "flamethrower Boss",
    ["Flamingo"] = "flamingo Boss",
    ["Frosttroll"] = "frosttroll Boss",
    ["Gargoyle"] = "gargoyle Boss",
    ["Gazer"] = "gazer Boss",
    ["Ghost"] = "ghost Boss",
    ["Ghostlyvisage"] = "ghostlyvisage Boss",
    ["Ghoul"] = "ghoul Boss",
    ["Giant Spider"] = "giant spider Boss",
    ["Giantspider"] = "giantspider Boss",
    ["Goblin"] = "goblin Boss",
    ["Greendjinn"] = "greendjinn Boss",
    ["Grorlam"] = "grorlam Boss",
    ["Hero"] = "hero Boss",
    ["Hornedfox"] = "hornedfox Boss",
    ["Hunter"] = "hunter Boss",
    ["Hyaena"] = "hyaena Boss",
    ["Hydra"] = "hydra Boss",
    ["Infernatil"] = "infernatil Boss",
    ["Kongra"] = "kongra Boss",
    ["Larva"] = "larva Boss",
    ["Lich"] = "lich Boss",
    ["Lion"] = "lion Boss",
    ["Lizard Sentinel"] = "lizard sentinel Boss",
    ["Lizard Snakecharmer"] = "lizard snakecharmer Boss",
    ["Lizard Templar"] = "lizard templar Boss",
    ["Lizard_King"] = "lizard_king Boss",
    ["Lizardsentinel"] = "lizardsentinel Boss",
    ["Lizardsnakecharmer"] = "lizardsnakecharmer Boss",
    ["Lizardtemplar"] = "lizardtemplar Boss",
    ["Magicthrower"] = "magicthrower Boss",
    ["Mahrdis"] = "mahrdis Boss",
    ["Marid"] = "marid Boss",
    ["Merlkin"] = "merlkin Boss",
    ["Mimic"] = "mimic Boss",
    ["Minotaur"] = "minotaur Boss",
    ["Minotaurarcher"] = "minotaurarcher Boss",
    ["Minotaurguard"] = "minotaurguard Boss",
    ["Minotaurmage"] = "minotaurmage Boss",
    ["Monk - Copy"] = "monk - Copy Boss",
    ["Monk"] = "monk Boss",
    ["Morgaroth"] = "morgaroth Boss",
    ["Morguthis"] = "morguthis Boss",
    ["Mummy"] = "mummy Boss",
    ["Murius"] = "murius Boss",
    ["Necromancer"] = "necromancer Boss",
    ["Necropharus"] = "necropharus Boss",
    ["Old Widow"] = "old widow Boss",
    ["Oldwidow"] = "oldwidow Boss",
    ["Omruc"] = "omruc Boss",
    ["Orc"] = "orc Boss",
    ["Orcberserker"] = "orcberserker Boss",
    ["Orcleader"] = "orcleader Boss",
    ["Orcrider"] = "orcrider Boss",
    ["Orcshaman"] = "orcshaman Boss",
    ["Orcspearman"] = "orcspearman Boss",
    ["Orcwarlord"] = "orcwarlord Boss",
    ["Orcwarrior"] = "orcwarrior Boss",
    ["Orshabaal"] = "orshabaal Boss",
    ["Panda"] = "panda Boss",
    ["Parrot"] = "parrot Boss",
    ["Pig"] = "pig Boss",
    ["Plague Spitter"] = "plague spitter Boss",
    ["Plaguethrower"] = "plaguethrower Boss",
    ["Poisonspider"] = "poisonspider Boss",
    ["Polarbear"] = "polarbear Boss",
    ["Priestess"] = "priestess Boss",
    ["Rabbit"] = "rabbit Boss",
    ["Rahemos"] = "rahemos Boss",
    ["Rat"] = "rat Boss",
    ["Rotworm"] = "rotworm Boss",
    ["Scarab"] = "scarab Boss",
    ["Scorpion"] = "scorpion Boss",
    ["Serpentspawn"] = "serpentspawn Boss",
    ["Sheep"] = "sheep Boss",
    ["Shredderthrower"] = "shredderthrower Boss",
    ["Sibang"] = "sibang Boss",
    ["Skeleton"] = "skeleton Boss",
    ["Skunk"] = "skunk Boss",
    ["Slime2"] = "slime2 Boss",
    ["Slime"] = "slime Boss",
    ["Smuggler"] = "smuggler Boss",
    ["Snake"] = "snake Boss",
    ["Spider"] = "spider Boss",
    ["Spit Nettle"] = "spit nettle Boss",
    ["Spitnettle"] = "spitnettle Boss",
    ["Stalker"] = "stalker Boss",
    ["Stone Golem"] = "stone golem Boss",
    ["Stonegolem"] = "stonegolem Boss",
    ["Swamp Troll"] = "swamp troll Boss",
    ["Swamptroll"] = "swamptroll Boss",
    ["Tarantula"] = "tarantula Boss",
    ["Terrorbird"] = "terrorbird Boss",
    ["Thalas"] = "thalas Boss",
    ["The_Soul"] = "the_soul Boss",
    ["Tiger"] = "tiger Boss",
    ["Trainer"] = "trainer Boss",
    ["Troll"] = "troll Boss",
    ["Valkyrie Commander"] = "valkyrie commander Boss",
    ["Valkyrie"] = "valkyrie Boss",
    ["Vampire - Copy"] = "vampire - Copy Boss",
    ["Vampire"] = "vampire Boss",
    ["Vashresamun"] = "vashresamun Boss",
    ["Vladtepes"] = "vladtepes Boss",
    ["Warlock"] = "warlock Boss",
    ["Warwolf"] = "warwolf Boss",
    ["Wasp"] = "wasp Boss",
    ["Wildwarrior"] = "wildwarrior Boss",
    ["Winterwolf"] = "winterwolf Boss",
    ["Witch"] = "witch Boss",
    ["Wolf"] = "wolf Boss",
    ["Wolfboss"] = "wolfboss Boss",
    ["Yeti"] = "yeti Boss",
---add more here
},
    
    validMonsters = {},  -- Empty means all monsters can spawn bosses
    announceSpawns = true,
    
    -- Skull configuration
    skullType = SKULL_GREEN -- Use the white skull constant
}

-- Debug mode
local debug = true
local function log(message)
    if debug then
        print("[Boss System] " .. message)
    end
end

log("Boss system loading...")

-- Function to create a boss version of a monster
local function createBossMonster(position, baseMonsterName, playerName)
    log("Attempting to create boss: " .. baseMonsterName)
    
    -- Get the corresponding boss name from the config
    local bossName = config.bossNames[baseMonsterName]
    if not bossName then
        log("No boss version defined for: " .. baseMonsterName)
        return nil
    end
    
    -- Create the monster
    local boss = Game.createMonster(bossName, position)
    if not boss then
        log("Failed to create boss monster")
        return nil
    end
    
    log("Boss monster created successfully")
    
    -- Set white skull on the boss (permanent - will last until the monster is killed)
    boss:setSkull(config.skullType)
    log("Applied permanent white skull to " .. bossName)
    
    -- Visual effects
    position:sendMagicEffect(CONST_ME_MAGIC_RED)
    
    -- Send message only to the player who killed the monster
    if config.announceSpawns and playerName then
        local player = Player(playerName)
        if player then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "A powerful " .. baseMonsterName .. " has appeared!")
        end
    end
    
    return boss
end

-- Event handler for monster death
function onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if not creature:isMonster() then
        return true
    end
    
    local monsterName = creature:getName()
    
    -- Check if this is a boss monster
    if monsterName:find(" Boss$") then
        -- Boss monster died, but we don't need to add special loot anymore
        return true
    end
    
    -- Get the player who killed the monster
    local player = nil
    local playerName = nil
    if killer then
        if killer:isPlayer() then
            player = killer
            playerName = player:getName()
        elseif killer:isSummon() or killer:isNpc() then
            local master = killer:getMaster()
            if master and master:isPlayer() then
                player = master
                playerName = player:getName()
            end
        end
    end
    
    -- Check if this monster can spawn a boss version
    if #config.validMonsters > 0 then
        local isValid = false
        for _, validName in ipairs(config.validMonsters) do
            if monsterName == validName then
                isValid = true
                break
            end
        end
        
        if not isValid then
            return true
        end
    end
    
    -- Check if there's a boss version defined for this monster
    if not config.bossNames[monsterName] then
        return true
    end
    
    -- Random chance to spawn a boss
    if math.random() <= (config.spawnChance / 100) then
        local position = creature:getPosition()
        
        -- Announce the upcoming boss spawn only to the player
        if config.announceSpawns and player then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Warning: A powerful " .. monsterName .. " is preparing to emerge!")
        end
        
        -- Initial visual warning
        position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
        
        -- Store position coordinates to avoid reference issues
        local posX = position.x
        local posY = position.y
        local posZ = position.z
        
        -- Show the effect immediately and then every 250ms for the duration of the delay
        local function showSpawnEffect()
            -- Recreate position from saved coordinates
            local effectPos = Position(posX, posY, posZ)
            effectPos:sendMagicEffect(31) -- Using effect number 31 as requested
        end
        
        -- Show initial effect
        showSpawnEffect()
        
        -- Schedule the effect to appear every 250ms during the waiting period
        for i = 250, config.spawnDelay - 250, 250 do
            addEvent(showSpawnEffect, i)
        end
        
        -- Delayed spawn of the boss after the effect period
        addEvent(function()
            local spawnPos = Position(posX, posY, posZ)
            createBossMonster(spawnPos, monsterName, playerName)
        end, config.spawnDelay)
    end
    
    return true
end

log("Boss system loaded successfully")