local QBCore = exports['qb-core']:GetCoreObject() 

local Cooldown = false

QBCore.Functions.CreateCallback("qb-drug:server:getConfig", function(source, cb)
	cb(Config)
end)

RegisterServerEvent("drug:addbaggies", function()
	local src = source
	local ped = GetPlayerPed(src)
	local Player = QBCore.Functions.GetPlayer(src)
	local Coords = GetEntityCoords(ped)

	if #(Config.Coords - Coords) < 3 then -- lets check here if the player is close to the place
		TriggerEvent("drug:overallproccess", Player)
		if Player.Functions.GetItemByName(Config.ItemToTake) ~= nil then -- lets check if the player has the item
			Player.Functions.RemoveItem(Config.ItemToTake, 1) -- Lets take the item
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.ItemToTake], "remove")
			TriggerClientEvent("QBCore:Notify", src, "Making Drug Bags", "success", 8000)
			Player.Functions.AddItem(Config.ItemToGive, 8) -- Lets give the item
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.ItemToGive], "add") -- Lets give the item
			TriggerEvent("qb-log:server:CreateLog","anticheat",GetCurrentResourceName(),"default","8 bags Of Drug Recieved by "..Player.PlayerData.charinfo.firstname)
		end
	else
		TriggerEvent("qb-log:server:CreateLog","anticheat",GetCurrentResourceName(),"red","Player: "..Player.PlayerData.citizenid.." tried to exploit resource: "..GetCurrentResourceName())
		DropPlayer(src, "Trying to exploit resource: " .. GetCurrentResourceName())
	end
end)

RegisterServerEvent('qb-cokerun:server:startr', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.money['cash'] >= Config.RunCost then
		Player.Functions.RemoveMoney('cash', Config.RunCost)
        Player.Functions.AddItem("casekey", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casekey"], "add")
		TriggerClientEvent("qb-cokerun:server:runactivate", src)
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.send_email_right_now"), 'success')
	else
		TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
	end
end)

-- cool down for job
RegisterServerEvent('qb-cokerun:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("qb-cokerun:server:coolc",function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false) 
    end
end)

RegisterServerEvent('qb-cokerun:server:unlock', function ()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	Player.Functions.AddItem("securitycase", 1)
    Player.Functions.RemoveItem("casekey", 1)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["securitycase"], "add")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casekey"], "remove")
end)


RegisterServerEvent('qb-cokerun:server:rewardpayout', function ()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("coke_cured", 20)
    Player.Functions.AddItem(Config.Item, Config.CokeAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["coke_cured"], "remove")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item], "add")

    Player.Functions.AddMoney('cash', Config.Payout)

    local chance = math.random(1, 100)

    if chance >= 85 then
        Player.Functions.AddItem(Config.Item, Config.CokeAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item], "add")
    end

    if chance >= 95 then
        Player.Functions.AddItem(Config.SpecialItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.SpecialItem], "add")
    end
end)

RegisterServerEvent('qb-cokerun:server:givecaseitems', function ()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	Player.Functions.AddItem("coke_cured", 20)
    Player.Functions.RemoveItem("securitycase", 1)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["coke_cured"], "add")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["securitycase"], "remove")
end)
