-- task_config.lua
local TaskConfig = {
    tasks = {
        -- Experience-focused tasks with token rewards
        {
            name = "Beholder",
            monster = "Beholder",
            count = 25,
            minLevel = 50,
            completionStorage = 980160,
            reward = {
                exp = 40500000,
                tokens = 1
            }
        },
        {
            name = "Gazer",
            monster = "Gazer",
            count = 25,
            minLevel = 30,
            completionStorage = 980161,
            reward = {
                exp = 40500000,
                tokens = 1
            }
        },
        {
            name = "Hero",
            monster = "Hero",
            count = 50,
            minLevel = 100,
            completionStorage = 980162,
            reward = {
                exp = 80500000,
                tokens = 2
            }
        },
        {
            name = "Black Knight",
            monster = "Black Knight",
            count = 25,
            minLevel = 101,
            completionStorage = 980163,
            reward = {
                exp = 40500000,
                tokens = 2
            }
        },
        {
            name = "Assassin",
            monster = "Assassin",
            count = 50,
            minLevel = 60,
            completionStorage = 980164,
            reward = {
                exp = 60500000,
                tokens = 2
            }
        },
        {
            name = "Hydra",
            monster = "Hydra",
            count = 50,
            minLevel = 61,
            completionStorage = 980165,
            reward = {
                exp = 60500000,
                tokens = 2
            }
        },
        {
            name = "Ancient Scarab",
            monster = "Ancient Scarab",
            count = 50,
            minLevel = 62,
            completionStorage = 980166,
            reward = {
                exp = 60500000,
                tokens = 2
            }
        },
        {
            name = "Giant Spider",
            monster = "Giant Spider",
            count = 50,
            minLevel = 63,
            completionStorage = 980167,
            reward = {
                exp = 60500000,
                tokens = 2
            }
        },
        {
            name = "Demon",
            monster = "Demon",
            count = 50,
            minLevel = 64,
            completionStorage = 980168,
            reward = {
                exp = 60500000,
                tokens = 2
            }
        },
        {
            name = "Angel",
            monster = "Angel",
            count = 100,
            minLevel = 100,
            completionStorage = 980169,
            reward = {
                exp = 102000000,
                tokens = 4
            }
        },
        {
            name = "Water Elemental",
            monster = "Water Elemental",
            count = 100,
            minLevel = 4000,
            completionStorage = 980180,
            reward = {
                exp = 68000000000,
                tokens = 10
            }
        },
        {
            name = "Thornscale",
            monster = "Thornscale",
            count = 500,
            minLevel = 6000,
            completionStorage = 980181,
            reward = {
                exp = 840000000000,
                tokens = 4
            }
        },
        -- Skull-focused tasks with token rewards
        {
            name = "Izual",
            monster = "Izual",
            count = 100,
            minLevel = 200,
            completionStorage = 980170,
            reward = {
                skulls = {
                    id = 2320,  -- Chipped Skull
                    count = 50
                },
                tokens = 4
            }
        },
        {
            name = "Mutalisk",
            monster = "Mutalisk",
            count = 150,
            minLevel = 400,
            completionStorage = 980171,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 1
                },
                tokens = 5
            }
        },
        {
            name = "Doom Lord",
            monster = "Doom Lord",
            count = 250,
            minLevel = 600,
            completionStorage = 980172,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 2
                },
                tokens = 6
            }
        },
        {
            name = "Fire Storm",
            monster = "Fire Storm",
            count = 250,
            minLevel = 800,
            completionStorage = 980173,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 3
                },
                tokens = 6
            }
        },
        {
            name = "Hell Screamer",
            monster = "Hell screamer",
            count = 250,
            minLevel = 2000,
            completionStorage = 980174,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 5
                },
                tokens = 6
            }
        },
        {
            name = "Vlad Tepes",
            monster = "Vlad Tepes",
            count = 500,
            minLevel = 1000,
            completionStorage = 980175,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 10
                },
                tokens = 15
            }
        },
        {
            name = "The Soul",
            monster = "The Soul",
            count = 400,
            minLevel = 2000,
            completionStorage = 980176,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 20
                },
                tokens = 15
            }
        },
        {
            name = "The Creator",
            monster = "The Creator",
            count = 400,
            minLevel = 2000,
            completionStorage = 980177,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 50
                },
                tokens = 15
            }
        },
        {
            name = "Demonic Summoner",
            monster = "Demonic Summoner",
            count = 1000,
            minLevel = 2500,
            completionStorage = 980178,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 100
                },
                tokens = 60
            }
        },
        {
            name = "Soul Destroyer",
            monster = "Soul Destroyer",
            count = 1000,
            minLevel = 12000,
            completionStorage = 980179,
            reward = {
                skulls = {
                    id = 2229,  -- Flawless Skull
                    count = 1000
                },
                tokens = 100
            }
        }
    },
    
    -- Global settings
    settings = {
        maxActiveTasks = 1,
        minTaskLevel = 30
    }
}

return TaskConfig