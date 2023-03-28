Config = {}
Config.EnableDebug = true

-- General --
Config.Use3DText = true
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
        startCoord = vector3(-40.965518951416, -1751.9327392578, 29.421020507813),
        PatrolTime = 120, -- In seconds
        PaidContract = true,
        Payout = 100
    },
    {
        name = 'Sisyphus Theater',
        coord = vector3(218.1862, 1192.421, 225.5947),
        blip = true,
        startCoord = vector3(218.1862, 1192.421, 225.5947),
        PatrolTime = 30, -- In seconds
        PaidContract = true,
        Payout = 100
    },
    {
        name = 'ULSA',
        coord = vector3(-1635.6265869141, 181.37966918945, 61.757331848145),
        blip = true,
        startCoord = vector3(-1635.6265869141, 181.37966918945, 61.757331848145),
        PatrolTime = 120, -- In seconds
        PaidContract = true,
        Payout = 100
    }
}

-- Interaction Menu --
Config.Questions = {
    {
        label = 'What are you doing in this area?',
        value = 'area_question'
    },
    {
        label = 'Is everything okay?',
        value = 'everything_okay'
    }
}

Config.Answers = {
    'Mind your own business.',
    'Can you leave me alone please?',
    'I am calling the police'
}