local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
	for k, v in pairs(Config.Products) do
		for i = 1, #v do
			if not QBCore.Shared.Items[Config.Products[k][i].name] then
				print("Config.Products['"..k.."'] can't find item: "..Config.Products[k][i].name)
			end
		end
	end
	for k, v in pairs(Config.Locations) do
		if v["products"] == nil then
			print("Config.Locations['"..k.."'] can't find its product table")
		end
	end
end)

RegisterServerEvent('ik-blackmarket:GetItem', function(amount, billtype, item, shoptable, price, info, shop, num, nostash)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local totalWeight = QBCore.Player.GetTotalWeight(Player.PlayerData.items)
    local maxWeight = QBCore.Config.Player.MaxWeight
	local slots = 0
	for k, v in pairs(Player.PlayerData.items) do slots = slots +1 end
	slots = Config.MaxSlots - slots
	local balance = Player.Functions.GetMoney(tostring(billtype))
	if (totalWeight + (QBCore.Shared.Items[item].weight * amount)) > maxWeight then
		TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_space"), "error")
	elseif QBCore.Shared.Items[item].unique and (tonumber(slots) < tonumber(amount)) then
		TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_slots"), "error")
	else
		if balance <= (tonumber(price) * tonumber(amount)) then
			TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_money"), "error") return
		end
		if QBCore.Shared.Items[item].type == "weapon" or QBCore.Shared.Items[item].unique then
			for i = 1, amount do
				if Player.Functions.AddItem(item, 1) then
					if tonumber(i) == tonumber(amount) then
						Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
						TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
					end
				else
					TriggerClientEvent('QBCore:Notify', src, Lang:t("error.cant_give"), "error") break
				end
				Wait(5)
			end
		else
			if Player.Functions.AddItem(item, amount) then
				Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
			else
				TriggerClientEvent('QBCore:Notify', source,  Lang:t("error.cant_give"), "error")
			end
		end
	end
	local data = {}
	data.shoptable = shoptable
	custom = true
	TriggerClientEvent('ik-blackmarket:ShopMenu', src, data, custom)
end)