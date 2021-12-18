Config = {}

-- General --
Config.Use3DText = false
Config.EnableBlips = true

-- Duty Settings --
Config.GlobalNotifications = true
Config.PatrolCar = 'dilettante2'

-- Coords --
Config.HQCoords = vector3(-195.94491577148, -830.75805664063, 30.779104232788)
Config.HQCarSpawn = vector3(-162.82891845703, -788.74865722656, 31.354904174805)
Config.HQCarSpawnHeading = 159.77

-- Security Zones --
Config.SecurityZones = {
    {
        name = 'Grove Street LTD',
        coord = vector3(-51.257926940918, -1754.3212890625, 29.421009063721),
        blip = true,
        startCoord = vector3(-51.257926940918, -1754.3212890625, 29.421009063721),
        PatrolTime = 10 -- In seconds
    },
    {
        name = 'Sisyphus Theater',
        coord = vector3(213.41055297852, 1235.3703613281, 225.46057128906),
        blip = true,
        startCoord = vector3(213.41055297852, 1235.3703613281, 225.46057128906),
        PatrolTime = 10 -- In seconds
    },
    {
        name = 'ULSA',
        coord = vector3(-1612.9968261719, 185.89691162109, 59.410472869873),
        blip = true,
        startCoord = vector3(-1612.9968261719, 185.89691162109, 59.410472869873),
        PatrolTime = 10 -- In seconds
    }
}

