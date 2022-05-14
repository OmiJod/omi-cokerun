Config = {}


Config.MinimumCokeJobPolice = 0
Config.Cooldown = 360 --- Cooldown until next allowed Coke run
Config.RunCost = 1500 --- Self explanatory 

Config.Payout = math.random(2000, 3000) -- How much you get paid
Config.Item = "coke_brick" -- The item you receive from the job
Config.CokeChance = 1000 -- Percentage chance to get Coke
Config.CokeAmount = 1 -- Amount of Coke you recieve

Config.SpecialRewardChance = 300 -- Percentage of getting rare item on job. Multiplied by 100. 0.1% = 1, 1% = 10, 20% = 200, 50% = 500, etc. Default 0.1%.
Config.SpecialItem = "weapon_pistol50" -- Put a rare item here which will have 0.1% chance of being given on the run.

Config.BossLocation = vector3(2555.62, 4651.61, 33.08)
Config.Itemtime = 1000 * 5 -- 5 minutes (time for the case to open after you collect it)
Config.Carspawn = vector3(1427.63, 6348.36, 23.98) -- Spawn location for vehicle (it serves not purpose just there...)
Config.ItemToGive = "cokebaggy" -- Item to give after the proccess
Config.ItemToTake = "coke_brick" -- Item to take before
Config.Coords = vector3(-199.19, -1705.82, 32.66) -- Coords

Config['cokeguards'] = {
    ['npcguards'] = {
        { coords = vector3(1439.06, 6320.65, 24.28), heading = 38.41, model = 'csb_mweather'},
        { coords = vector3(1453.0, 6338.79, 23.81), heading = 94.02, model = 'csb_mweather'},
        { coords = vector3(1474.68, 6372.33, 23.6), heading = 345.89, model = 'csb_mweather'},
        { coords = vector3(1484.32, 6368.98, 23.7), heading = 120.9, model = 'csb_mweather'},
        { coords = vector3(1426.31, 6357.93, 28.4), heading = 173.16, model = 'csb_mweather'},
        { coords = vector3(1424.21, 6356.38, 23.98), heading = 184.4, model = 'csb_mweather'},
        { coords = vector3(1425.87, 6347.98, 23.98), heading = 179.2, model = 'csb_mweather'},
        { coords = vector3(1441.03, 6336.22, 23.85), heading = 71.62, model = 'csb_mweather'},
        { coords = vector3(1433.11, 6330.34, 23.99), heading = 48.6, model = 'csb_mweather'},
        { coords = vector3(1088.1405, -2246.9199, 37.6795), heading = 201.0654, model = 'csb_mweather'},
        { coords = vector3(1108.3584, -2320.5750, 36.5850), heading = 44.2218, model = 'csb_mweather'},
        { coords = vector3(1077.6124, -2307.5488, 38.7956), heading = 295.8649, model = 'csb_mweather'},
    },
}
