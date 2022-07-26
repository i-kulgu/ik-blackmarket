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

RegisterServerEvent('ik-blackmarket:GetItem', function(amount, billtype, item, shoptable, price)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local totalWeight = QBCore.Player.GetTotalWeight(Player.PlayerData.items)
    local maxWeight = QBCore.Config.Player.MaxWeight
	local slots = 0
	local BlackMoneyName = Config.BlackMoneyName
	for k, v in pairs(Player.PlayerData.items) do slots = slots +1 end
	slots = Config.MaxSlots - slots
	if billtype == "blackmoney" then
		if BlackMoneyName == "markedbills" then
			Balance = getMarkedBillWorth()
		else
			Balance = Player.Functions.GetItemByName(BlackMoneyName).amount
		end
	else
		Balance = Player.Functions.GetMoney(tostring(billtype))
	end
	if (totalWeight + (QBCore.Shared.Items[item].weight * amount)) > maxWeight then
		TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_space"), "error")
	elseif QBCore.Shared.Items[item].unique and (tonumber(slots) < tonumber(amount)) then
		TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_slots"), "error")
	else
		if Balance <= (tonumber(price) * tonumber(amount)) then
			TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_money"), "error") return
		end
		if QBCore.Shared.Items[item].type == "weapon" or QBCore.Shared.Items[item].unique then
			for i = 1, amount do
				if Player.Functions.AddItem(item, 1) then
					if tonumber(i) == tonumber(amount) then
						if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" then
							payByMarkedBills(Balance,price)
						else
							Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
						end
						TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
					end
				else
					TriggerClientEvent('QBCore:Notify', src, Lang:t("error.cant_give"), "error") break
				end
				Wait(5)
			end
		else
			if Player.Functions.AddItem(item, amount) then
				if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" then
					payByMarkedBills(Balance,price)
				else
					Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
				end
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
			else
				TriggerClientEvent('QBCore:Notify', source,  Lang:t("error.cant_give"), "error")
			end
		end
	end
	local data = {}
	data.shoptable = shoptable
	custom = true
	if Config.RemoveItem then
		local itemused = Config.ItemName
		Player.Functions.RemoveItem(itemused, 1)
	else
		TriggerClientEvent('ik-blackmarket:ShopMenu', src, data, custom)
	end
end)

function getMarkedBillWorth()
	local Player = QBCore.Functions.GetPlayer(source)
	local markedbilltotal = 0
	for k, v in pairs(Player.PlayerData.items) do
		if v.name == "markedbills" then
			markedbilltotal = markedbilltotal + v.info.worth
		end
	end
	return markedbilltotal
end

function payByMarkedBills(balance, price)
	local Player = QBCore.Functions.GetPlayer(source)
	local newworth = balance - price
	info = {
		worth = newworth
	}
	for k, v in pairs(Player.PlayerData.items) do
		if v.name == "markedbills" then
			Player.Functions.RemoveItem("markedbills", 1, false)
		end
	end
	Player.Functions.AddItem("markedbills", 1 , false ,info)
end
