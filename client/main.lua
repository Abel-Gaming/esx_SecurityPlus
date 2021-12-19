ESX              = nil
local onDuty = false
local onPatrol = false
local SecurityZoneBlips = {}

-- ESX BASE --
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

-- Commands --
RegisterCommand('+forceduty', function(source, args, rawCommand)
	ToggleDuty()
end, false)

-- DRAW MARKER --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		DrawMarker(25, Config.HQCoords.x, Config.HQCoords.y, Config.HQCoords.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 155, false, true, 2, nil, nil, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if onDuty then
			for k,v in pairs(Config.SecurityZones) do
				DrawMarker(25, v.startCoord.x, v.startCoord.y, v.startCoord.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 155, false, true, 2, nil, nil, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(500)
	end

	while true do
		Citizen.Wait(1)
		if onDuty then
			for k,v in pairs(Config.SecurityZones) do
				while #(GetEntityCoords(PlayerPedId()) - v.startCoord) <= 1.0 do
					Citizen.Wait(0)
					if Config.Use3DText then
						ESX.Game.Utils.DrawText3D(v.startCoord, "Press ~y~[E]~s~ to start area patrol")
					else
						ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to start area patrol')
					end
					if IsControlJustReleased(0, 51) then
						if onPatrol then
							ESX.ShowNotification('~r~[ERROR]~w~ You are already on another patrol!')
						else
							ESX.ShowNotification('~y~[INFO]~w~ Your area patrol has started! Please patrol the area for ~b~' .. v.PatrolTime .. ' ~w~seconds')
							onPatrol = true
							timer(v.PatrolTime, v.PaidContract, v.Payout, v.name)
						end
					end
				end
			end
		end
	end
end)

-- CHECK MARKER --
Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(500)
	end

	while true do
		Citizen.Wait(1)
		while #(GetEntityCoords(PlayerPedId()) - Config.HQCoords) <= 1.0 do
			Citizen.Wait(0)
			if Config.Use3DText then
				ESX.Game.Utils.DrawText3D(Config.HQCoords, "Press ~y~[E]~s~ to enter HQ")
			else
				ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to enter HQ')
			end
			if IsControlJustReleased(0, 51) then
				local mainoptions = {
					{label = "Toggle Duty", value = 'toggle_duty'},
					{label = "Spawn Patrol Vehicle", value = 'patrol_vehicle'}
				}
				HQMenu(mainoptions)
			end
		end
	end
end)

-- FUNCTIONS --
function timer(timeAmount, Paid, Payout, Location)
	Citizen.CreateThread(function()
		local time = timeAmount
		while (time ~= 0) do
			Wait( 1000 )
			time = time - 1
		end
		ESX.ShowNotification('~y~[INFO]~w~ Your patrol time for the area has ended.')
		if Paid then
			TriggerServerEvent('esx_SecurityPlus:PayContract', Location)
			onPatrol = false
		else
			onPatrol = false
		end
	end)
end

function DrawBlip(coord)
	local blip = AddBlipForCoord(coord)
	table.insert(SecurityZoneBlips, blip)
	SetBlipSprite(blip, 487)
	SetBlipColour(blip, 11)
	SetBlipScale(blip, 1.0)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Security Zone")
	EndTextCommandSetBlipName(blip)
end

function DeleteBlip(blipID)
	RemoveBlip(blipID)
	SecurityZoneBlips = {}
end

function HQMenu(items)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Security",
		align = "center",
		elements = items
	}, function(data, menu)
		if data.current.value == 'toggle_duty' then
			ToggleDuty()
		elseif data.current.value == 'patrol_vehicle' then
			if onDuty then
				SpawnVehicle(Config.PatrolCar, Config.HQCarSpawn, Config.HQCarSpawnHeading)
				ESX.UI.Menu.CloseAll()
			else
				ESX.ShowNotification('~r~[ERROR]~w~ You are not on duty!')
			end
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function ToggleDuty()
	if onDuty then
		onDuty = false
		ESX.ShowNotification('You are now off duty!')
		ESX.UI.Menu.CloseAll()
		for k,v in pairs(SecurityZoneBlips) do
			DeleteBlip(v)
		end
	else
		onDuty = true
		ESX.ShowNotification('You are now on duty!')
		ESX.UI.Menu.CloseAll()
		TriggerServerEvent('esx_SecurityPlus:DutyNotification')
		for k,v in pairs(Config.SecurityZones) do
			if v.blip == true then
				DrawBlip(v.coord)
			end
		end
	end
end

function SpawnVehicle(vehicleModel, Coords, Heading)
	ESX.Game.SpawnVehicle(vehicleModel, Coords, Heading, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		-- DO ACTION
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

-- EVENTS --
RegisterNetEvent('esx_SecurityPlus:GlobalNotification')
AddEventHandler('esx_SecurityPlus:GlobalNotification', function(text)
	ESX.ShowNotification(text)
end)

RegisterNetEvent('esx_SecurityPlus:ToggleDutyEvent')
AddEventHandler('esx_SecurityPlus:ToggleDutyEvent', function()
	ToggleDuty()
end)

-- BLIP --
if Config.EnableBlips then
	Citizen.CreateThread(function()
		local blip = AddBlipForCoord(Config.HQCoords)
		SetBlipSprite(blip, 67)
		SetBlipColour(blip, 11)
		SetBlipScale(blip, 1.0)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Security HQ")
		EndTextCommandSetBlipName(blip)
	end)
end