local QBCore = exports['qb-core']:GetCoreObject()
local Balance = 0

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

local function payByMarkedBills(balance, price,source)
    local Player = QBCore.Functions.GetPlayer(source)
    Balance = balance - price
    info = {
        worth = Balance
    }
    for k, v in pairs(Player.PlayerData.items) do
        if v.name == "markedbills" then
            Player.Functions.RemoveItem("markedbills", v.amount, false)
        end
    end
    Player.Functions.AddItem("markedbills", 1 , false ,info)
end

local function GiveAndCheckItem(item,amount,weapon,price,balance,billtype)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BlackMoneyName = Config.BlackMoneyName
    local TotalPrice = tonumber(price) * tonumber(amount)
    Balance = balance
    if weapon then
        for i = 1, tonumber(amount) do
            if Player.Functions.AddItem(item, 1) then
                if tonumber(i) == tonumber(amount) then
                    if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" and Config.UseDirtyMoney == "true" then
                        payByMarkedBills(Balance,price,src)
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
            if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" and Config.UseDirtyMoney == "true" then
                payByMarkedBills(Balance,TotalPrice, src)
            else
                Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
            end
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
        else
            TriggerClientEvent('QBCore:Notify', src,  Lang:t("error.cant_give"), "error")
        end
    end
end

-- ##### Events ##### --

RegisterServerEvent('ik-blackmarket:GetItem', function(amount, billtype, item, shoptable, price, removeitem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BlackMoneyName = Config.BlackMoneyName
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
    if Balance < (tonumber(price) * tonumber(amount)) then
        TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_money"), "error") return
    end
    if QBCore.Shared.Items[item].type == "weapon" or QBCore.Shared.Items[item].unique then
        GiveAndCheckItem(item,amount,true,price,Balance,billtype)
    else
        GiveAndCheckItem(item,amount,false,price,Balance,billtype)
    end
    local data = {}
    if Config.RandomItem then
        data.products = shoptable
        data.shoptable = shoptable
    else
        data.shoptable = shoptable
    end
    custom = true
    if Config.RemoveItem then
        Player.Functions.RemoveItem(removeitem, 1)
    else
        TriggerClientEvent('ik-blackmarket:ShopMenu', src, data, custom)
    end
end)