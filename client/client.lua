local QBCore = exports['qb-core']:GetCoreObject() 

local VehicleCoords = nil
local CurrentCops = 0
local isProcessing = false

CreateThread(function()
	Wait(100)
	QBCore.Functions.TriggerCallback(
		"qb-drug:server:getConfig",
		function(config) -- get the info from the server, so no dumping stuff
			exports["qb-target"]:AddBoxZone("drugprocessing",  vector3(-199.19, -1705.82, 32.66), 4.8, 2, {
                name="asdasd",
                heading=40,
                --debugPoly=true,
                minZ=29.26,
                maxZ=33.26,
			}, {
				options = {
					{
						event = "drug:overallproccess",
						icon = "fas fa-hammer",
						label = "Process Drug",
						item = config.ItemToTake, --Change Me on server.lua
					},
				},
				distance = 2,
			})
		end
	)
end)

RegisterNetEvent("drug:overallproccess", function()
	local player = PlayerPedId() -- Use this so no loop over all the players
	FreezeEntityPosition(player, true)
	QBCore.Functions.Progressbar("drug-", "Breaking down the drug..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
		anim = "machinic_loop_mechandplayer",
		flags = 16,
	}, {}, {}, function() -- Done
		FreezeEntityPosition(player, false)
		TriggerServerEvent("drug:addbaggies")
		isProcessing = false
	end, function() -- Cancel
		isProcessing = false
		ClearPedTasksImmediately(player)
		FreezeEntityPosition(player, false)
	end)
end)

--- COKE RUN

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)


CreateThread(function()
  RequestModel(`g_m_m_mexboss_01`)
    while not HasModelLoaded(`g_m_m_mexboss_01`) do
    Wait(1)
  end
  cokeboss = CreatePed(2, `g_m_m_mexboss_01`, 2555.62, 4651.61, 33.08, 113.38, false, false) -- change here the cords for the ped 
    SetPedFleeAttributes(cokeboss, 0, 0)
    SetPedDiesWhenInjured(cokeboss, false)
    TaskStartScenarioInPlace(cokeboss, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetPedKeepTask(cokeboss, true)
    SetBlockingOfNonTemporaryEvents(cokeboss, true)
    SetEntityInvincible(cokeboss, true)
    FreezeEntityPosition(cokeboss, true)
end)



--- Target Stuff
CreateThread(function()
    exports['qb-target']:AddTargetModel('g_m_m_mexboss_01', {
        options = {
            { 
                type = "client",
                event = "qb-cokerun:client:start",
                icon = "fas fa-circle",
                label = "Get Job ($1500)",
            },
            { 
                type = "client",
                event = "qb-cokerun:client:reward",
                icon = "fas fa-circle",
                label = "Check Product",
                item = 'coke_cured',
            },
        },
        distance = 3.0 
    })
    ---
    exports['qb-target']:AddTargetModel('prop_security_case_01', {
        options = {
            {
                type = 'client',
                event = "qb-cokerun:client:items",
                icon = "fas fa-circle",
                label = "Grab Goods",
                item = 'casekey',            
            },
        },
        distance = 2.5
    })
end)
---Phone msgs
function RunStart()
	Citizen.Wait(2000)
	TriggerServerEvent('qb-phone:server:sendNewMail', {
	sender = Lang:t('mailstart.sender'),
	subject = Lang:t('mailstart.subject'),
	message = Lang:t('mailstart.message'),
	})
	Citizen.Wait(3000)
end

function Itemtimemsg()
    Citizen.Wait(2000)

	TriggerServerEvent('qb-phone:server:sendNewMail', {
    sender = Lang:t('mail.sender'),
	subject = Lang:t('mail.subject'),
	message = Lang:t('mail.message'),
	})
    Citizen.Wait(Config.Itemtime)
    TriggerServerEvent('qb-cokerun:server:givecaseitems')
    QBCore.Functions.Notify(Lang:t("success.case_has_been_unlocked"), 'success')
end
---
RegisterNetEvent('qb-cokerun:client:start', function ()
    if CurrentCops >= Config.MinimumCokeJobPolice then
        QBCore.Functions.TriggerCallback("qb-cokerun:server:coolc",function(isCooldown)
            if not isCooldown then
                local success = exports['qb-lock']:StartLockPickCircle(5, 8, success)
                print(success)
                if success then
                    TriggerEvent('animations:client:EmoteCommandStart', {"idle11"})
                    QBCore.Functions.Progressbar("start_job", Lang:t('info.talking_to_boss'), 10000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                    }, {}, {}, function() -- Done
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerServerEvent('qb-cokerun:server:startr')
                        TriggerServerEvent('qb-cokerun:server:coolout')
    
                    end, function() -- Cancel
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
                    end)
                else
                    QBCore.Functions.Notify(Lang:t("Boss Does Not Trust You, You aint Stable"), 'error')
                end
            else
                QBCore.Functions.Notify(Lang:t("error.someone_recently_did_this"), 'error')
            end
        end)
    else
        QBCore.Functions.Notify(Lang:t("error.cannot_do_this_right_now"), 'error')
    end
end)

RegisterNetEvent('qb-cokerun:server:runactivate', function()
RunStart()
local DrawCoord = 1
    if DrawCoord == 1 then
    VehicleCoords = Config.Carspawn
end

RequestModel(`mesa3`)
    while not HasModelLoaded(`mesa3`) do
Citizen.Wait(0)
end

SetNewWaypoint(VehicleCoords.x, VehicleCoords.y)
ClearAreaOfVehicles(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 15.0, false, false, false, false, false)
transport = CreateVehicle(`mesa3`, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 52.0, true, true)
SpawnGuards()
spawncase()
end)

function spawncase()
    local case = CreateObject(`prop_security_case_01`, 1425.34, 6337.86, 24.34, true,  true, true)
    CreateObject(case)
    SetEntityHeading(case, 288.38)
    FreezeEntityPosition(case, true)
    SetEntityAsMissionEntity(case)
    case = AddBlipForEntity(case)
    SetBlipSprite(case, 586)
    SetBlipColour(case, 2)
    SetBlipFlashes(case, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Case')
    EndTextCommandSetBlipName(case)
end

cokeguards = {
    ['npcguards'] = {}
}

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function SpawnGuards()
    local ped = PlayerPedId()

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('npcguards')

    for k, v in pairs(Config['cokeguards']['npcguards']) do
        loadModel(v['model'])
        cokeguards['npcguards'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(cokeguards['npcguards'][k])
        networkID = NetworkGetNetworkIdFromEntity(cokeguards['npcguards'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(cokeguards['npcguards'][k], 0)
        SetPedRandomProps(cokeguards['npcguards'][k])
        SetEntityAsMissionEntity(cokeguards['npcguards'][k])
        SetEntityVisible(cokeguards['npcguards'][k], true)
        SetPedRelationshipGroupHash(cokeguards['npcguards'][k], `npcguards`)
        SetPedAccuracy(cokeguards['npcguards'][k], 75)
        SetPedArmour(cokeguards['npcguards'][k], 100)
        SetPedCanSwitchWeapon(cokeguards['npcguards'][k], true)
        SetPedDropsWeaponsWhenDead(cokeguards['npcguards'][k], false)
        SetPedFleeAttributes(cokeguards['npcguards'][k], 0, false)
        GiveWeaponToPed(cokeguards['npcguards'][k], `WEAPON_PISTOL`, 255, false, false)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(cokeguards['npcguards'][k], 10.0, 10.0, 1)
        end
    end

    SetRelationshipBetweenGroups(0, `npcguards`, `npcguards`)
    SetRelationshipBetweenGroups(5, `npcguards`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `npcguards`)
end

RegisterNetEvent('qb-cokerun:client:items', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerEvent("qb-dispatch:cokejob")
            local result = exports['boostinghack']:StartHack()
            if result then
                TriggerEvent('animations:client:EmoteCommandStart', {"type3"})
                QBCore.Functions.Progressbar("grab_case", Lang:t('info.unlocking_case'), 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                }, {}, {}, function() -- Done
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    RemoveBlip(case)
                    TriggerServerEvent('qb-cokerun:server:unlock')

                    local playerPedPos = GetEntityCoords(PlayerPedId(), true)
                    local case = GetClosestObjectOfType(playerPedPos, 10.0, `prop_security_case_01`, false, false, false)
                    if (IsPedActiveInScenario(PlayerPedId()) == false) then
                    SetEntityAsMissionEntity(case, 1, 1)
                    DeleteEntity(case)
                    QBCore.Functions.Notify(Lang:t("success.you_removed_first_security_case"), 'success')
                    Itemtimemsg()
                end
                end, function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
                end)
            else
                QBCore.Functions.Notify(Lang:t("error.you_failed"), 'error')
                TriggerEvent("un-dispatch:cokerun")
            end
        else
            QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
        end

    end, "casekey")
end)

-- RegisterNetEvent('qb-cokerun:client:items', function()
--     QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
--         if result then
--             TriggerEvent("qb-dispatch:cokejob")
--             exports["memorygame_2"]:thermiteminigame(8, 3, 2, 20,
--             function() -- Success
--                 TriggerEvent('animations:client:EmoteCommandStart', {"type3"})
--                 QBCore.Functions.Progressbar("grab_case", Lang:t('info.unlocking_case'), 10000, false, true, {
--                     disableMovement = true,
--                     disableCarMovement = true,
--                     disableMouse = false,
--                     disableCombat = true,
--                 }, {
--                 }, {}, {}, function() -- Done
--                     TriggerEvent('animations:client:EmoteCommandStart', {"c"})
--                     RemoveBlip(case)
--                     TriggerServerEvent('qb-cokerun:server:unlock')

--                     local playerPedPos = GetEntityCoords(PlayerPedId(), true)
--                     local case = GetClosestObjectOfType(playerPedPos, 10.0, `prop_security_case_01`, false, false, false)
--                     if (IsPedActiveInScenario(PlayerPedId()) == false) then
--                     SetEntityAsMissionEntity(case, 1, 1)
--                     DeleteEntity(case)
--                     QBCore.Functions.Notify(Lang:t("success.you_removed_first_security_case"), 'success')
--                     Itemtimemsg()
--                 end
--                 end, function()
--                     TriggerEvent('animations:client:EmoteCommandStart', {"c"})
--                     QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
--                 end)
--             end,
--             function() -- Fail thermite game
--                 QBCore.Functions.Notify(Lang:t("error.you_failed"), 'error')
--             end)
--         else
--             QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
--         end

--     end, "casekey")
-- end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end


RegisterNetEvent('qb-cokerun:client:reward', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerEvent('animations:client:EmoteCommandStart', {"suitcase2"})
            QBCore.Functions.Progressbar("product_check", Lang:t('info.checking_quality'), 7000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
            }, {}, {}, function() -- Done
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('qb-cokerun:server:rewardpayout')

                QBCore.Functions.Notify(Lang:t("success.you_got_paid"), 'success')
            end, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
            end)
        else
            QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
        end
    end, "coke_cured",20)
end)


function cooldown()
	Citizen.Wait(Config.cdTime)
	TriggerServerEvent('coke:updateTable', false)
end

function playAnimPed(animDict, animName, duration, buyer, x,y,z)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do 
      Citizen.Wait(0) 
    end
    TaskPlayAnim(pilot, animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do 
      Citizen.Wait(0) 
    end
    TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end
