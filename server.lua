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

--Wrapper converting for opening shops externally
RegisterServerEvent('ik-blackmarket:ShopOpen', function(shop, name, shoptable)
	local data = { shoptable = { products = shoptable.items, label = shoptable.label, }, custom = true }
	TriggerClientEvent('ik-blackmarket:ShopMenu', source, data, true)
end)

RegisterServerEvent('ik-blackmarket:GetItem', function(amount, billtype, item, shoptable, price, info, shop, num, nostash)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--Inventory space checks
	local totalWeight = QBCore.Player.GetTotalWeight(Player.PlayerData.items)
    local maxWeight = QBCore.Config.Player.MaxWeight
	local slots = 0
	for k, v in pairs(Player.PlayerData.items) do slots = slots +1 end
	slots = Config.MaxSlots - slots
	local balance = Player.Functions.GetMoney(tostring(billtype))
	-- If too heavy:
	if (totalWeight + (QBCore.Shared.Items[item].weight * amount)) > maxWeight then
		TriggerClientEvent("QBCore:Notify", src, "Not enough space in inventory", "error")
	-- If unique and it would poof away:
	elseif QBCore.Shared.Items[item].unique and (tonumber(slots) < tonumber(amount)) then
		TriggerClientEvent("QBCore:Notify", src, "Not enough slots in inventory", "error")
	else
		--Money Check
		if balance <= (tonumber(price) * tonumber(amount)) then -- Check for money first if not enough, stop here
			TriggerClientEvent("QBCore:Notify", src, "Not enough money", "error") return
		end

		-- If its a weapon or a unique item, do this:
		if QBCore.Shared.Items[item].type == "weapon" or QBCore.Shared.Items[item].unique then
			for i = 1, amount do -- Make a loop to put items into different slots rather than full amount in 1 slot
				if Player.Functions.AddItem(item, 1) then
					if tonumber(i) == tonumber(amount) then -- when its on its last loop do this
						Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
						TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
					end
				else
					TriggerClientEvent('QBCore:Notify', src, "Can't give item!", "error") break -- stop the item giving loop
				end
				Wait(5)
			end
		else
			-- if its a normal item, do normal things
			if Player.Functions.AddItem(item, amount) then
				Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
			else
				TriggerClientEvent('QBCore:Notify', source,  "Can't give item!", "error")
			end
		end
	end
	--Make data to send back to main shop menu
	local data = {}
	data.shoptable = shoptable
	custom = true
	TriggerClientEvent('ik-blackmarket:ShopMenu', src, data, custom)
end)