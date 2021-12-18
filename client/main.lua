ESX              = nil
local onDuty = false
local SecurityZoneBlips = {}

-- ESX BASE --
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

-- Commands --


-- DRAW MARKER --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		DrawMarker(25, Config.HQCoords.x, Config.HQCoords.y, Config.HQCoords.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 155, false, true, 2, nil, nil, false)
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
function DrawBlip(coord)
	local blip = AddBlipForCoord(coord)
	table.insert(SecurityZoneBlips, blip)
	SetBlipSprite(blip, 67)
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