local QBCore = exports['qb-core']:GetCoreObject()
local Balance = 0
local location = {}
local BMItems = {}

RegisterNetEvent('ik-blackmarket:server:RandomLocation', function()
    for k, v in pairs(Config.Locations) do
        if v["products"] == nil then
            print("Config.Locations['"..k.."'] can't find its product table")
        end
        if Config.RandomLocation then
            local m = math.random(1, #v["coords"])
            location = {bm = k, loc= m, data = v}
            m = 0
        end
    end
end)

if Config.UseTimer then
    CreateThread(function()
        local minutes = Config.ChangeLocationTime
        while true do
            Wait(60000)
            minutes = minutes - 1
            if minutes == 0 then
                TriggerEvent('ik-blackmarket:server:RandomLocation')
                TriggerClientEvent("ik-blackmarket:client:removeall", -1)
                TriggerClientEvent('ik-blackmarket:client:CreatePed', -1)
                minutes = Config.ChangeLocationTime
            end
        end
    end)
end

QBCore.Functions.CreateCallback("ik-blackmarket:server:PedLocation", function (_, cb)
    cb(location)
end)

QBCore.Functions.CreateCallback("ik-blackmarket:server:GetBMLocation", function (_, cb)
    cb(location)
end)

-- ##### Functions ##### --

local function getMarkedBillWorth(source)
    local Player = QBCore.Functions.GetPlayer(source)
    local markedbilltotal = 0
    for _, v in pairs(Player.PlayerData.items) do
        if v.name == "markedbills" then
            markedbilltotal = markedbilltotal + (v.info.worth * v.amount)
        end
    end
    return markedbilltotal
end

local function payByMarkedBills(balance,source)
    local Player = QBCore.Functions.GetPlayer(source)
    info = {
        worth = balance
    }
    for _, v in pairs(Player.PlayerData.items) do
        if v.name == "markedbills" then
            Player.Functions.RemoveItem("markedbills", v.amount)
        end
    end
    Player.Functions.AddItem("markedbills", 1 , false ,info)
end

local function DeductAmount(bm, item, amount)
    for _,v in pairs(BMItems) do
        if v.bm == bm and v.itemname == item then
            v.amount -= amount
        end
    end
end

local function GiveAndCheckItem(item,amount,weapon,price,balance,billtype,bm)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BlackMoneyName = Config.BlackMoneyName
    local newbalance = balance - price
    if weapon then
        for i = 1, tonumber(amount) do
            if Player.Functions.AddItem(item, 1) then
                if tonumber(i) == tonumber(amount) then
                    if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" and Config.UseDirtyMoney then
                        payByMarkedBills(newbalance,src)
                    elseif Config.Payment == "blackmoney" and BlackMoneyName ~= "markedbills" and Config.UseDirtyMoney then
                        Player.Functions.RemoveItem(BlackMoneyName, tonumber(price))
                    else
                        Player.Functions.RemoveMoney(tostring(billtype), tonumber(price), 'shop-payment')
                    end
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
                end
                if Config.Stock then DeductAmount(bm, item, amount) end
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.cant_give"), "error") break
            end
            Wait(5)
        end
    else
        if Player.Functions.AddItem(item, amount) then
            if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" and Config.UseDirtyMoney then
                payByMarkedBills(newbalance, src)
            elseif Config.Payment == "blackmoney" and BlackMoneyName ~= "markedbills" and Config.UseDirtyMoney then
                Player.Functions.RemoveItem(BlackMoneyName, tonumber(price))
            else
                Player.Functions.RemoveMoney(tostring(billtype), tonumber(price), 'shop-payment')
            end
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
            if Config.Stock then DeductAmount(bm, item, amount) end
        else
            TriggerClientEvent('QBCore:Notify', src,  Lang:t("error.cant_give"), "error")
        end
    end
end

local function GetTotalWeight(items)
    local weight = 0
    if not items then return 0 end
    for _, item in pairs(items) do
        weight += item.weight * item.amount
    end
    return tonumber(weight)
end

-- ##### Events ##### --

RegisterServerEvent('ik-blackmarket:GetItem', function(amount, billtype, item, shoptable, price, removeitem, bm)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BlackMoneyName = Config.BlackMoneyName
    local TotalPrice = tonumber(price) * tonumber(amount)
    local totalweight = GetTotalWeight(Player.PlayerData.items)
    local slots = 0
    for _ in pairs(Player.PlayerData.items) do slots = slots +1 end
    slots = Config.MaxSlots - slots
    if (totalweight + (QBCore.Shared.Items[item].weight * amount)) > Config.MaxWeight then TriggerClientEvent("QBCore:Notify", src, "Not enough space in inventory", "error") return end
    if QBCore.Shared.Items[item].unique and (tonumber(slots) < tonumber(amount)) then TriggerClientEvent("QBCore:Notify", src, "Not enough slots in inventory", "error") return end
    if billtype == "blackmoney" then
        if BlackMoneyName == "markedbills" then
            Balance = getMarkedBillWorth(src)
        else
            Balance = Player.Functions.GetItemByName(BlackMoneyName).amount
        end
    elseif billtype == "crypto" then
        Balance = Player.PlayerData.money.crypto
    else
        Balance = Player.Functions.GetMoney(tostring(billtype))
    end
    if Balance < TotalPrice then
        TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_money"), "error") return
    end
    if QBCore.Shared.Items[item].type == "weapon" or QBCore.Shared.Items[item].unique then
        GiveAndCheckItem(item,amount,true,TotalPrice,Balance,billtype,bm)
    else
        GiveAndCheckItem(item,amount,false,TotalPrice,Balance,billtype,bm)
    end
    local data = {}
    data.products = shoptable
    data.shoptable = shoptable
    data.k = bm
    custom = true
    if removeitem == nil and not Config.RemoveItem then
        TriggerClientEvent('ik-blackmarket:ShopMenu', src, data, custom)
        -- Player.Functions.AddItem(Config.ItemName, 1)
    end
end)


AddEventHandler('onResourceStart', function(resource)
    for k, v in pairs(Config.Products) do
        for i = 1, #v do
            if not QBCore.Shared.Items[Config.Products[k][i].name] then
                print("Config.Products['"..k.."'] can't find item: "..Config.Products[k][i].name)
            end
            BMItems[#BMItems+1] = {bm = k, itemname = Config.Products[k][i].name, amount = Config.Products[k][i].amount}
        end
    end
    for k, v in pairs(Config.Locations) do
        if v["products"] == nil then
            print("Config.Locations['"..k.."'] can't find its product table")
        end
        if Config.RandomLocation then
            local m = math.random(1, #v["coords"])
            location = {bm = k, loc= m, data = v}
            m = 0
        end
    end
end)

QBCore.Functions.CreateCallback('ik-blackmarket:server:GetItemAmount', function(source, cb, bm, item)
    for _,v in pairs(BMItems) do
        if v.bm == bm and v.itemname == item then
            cb(v.amount)
            return
        end
    end
    cb(nil)
end)

RegisterNetEvent('ik-blackmarket:server:AddRemoveItem', function (action)
    local Player = QBCore.Functions.GetPlayer(source)
    if action == 'add' then
        Player.Functions.AddItem(Config.ItemName, 1)
    end
    if action == 'remove' then
        Player.Functions.RemoveItem(Config.ItemName, 1)
    end
end)

RegisterNetEvent("ik-blackmarket:server:callCops", function(coords)
    local alertData = {
        title = "10-33 | Shop Robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Someone Is WireTapping Phonecalls!"
    }
    TriggerClientEvent("ik-blackmarket:client:wiretappingCall", -1, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)
