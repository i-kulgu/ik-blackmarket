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

-- ##### Functions ##### --

local function getMarkedBillWorth()
    local Player = QBCore.Functions.GetPlayer(source)
    local markedbilltotal = 0
    for _, v in pairs(Player.PlayerData.items) do
        if v.name == "markedbills" then
            markedbilltotal = markedbilltotal + v.info.worth
        end
    end
    return markedbilltotal
end

local function payByMarkedBills(balance, price)
    local Player = QBCore.Functions.GetPlayer(source)
    local newworth = balance - price
    info = {
        worth = newworth
    }
    for _, v in pairs(Player.PlayerData.items) do
        if v.name == "markedbills" then
            Player.Functions.RemoveItem("markedbills", 1, false)
        end
    end
    Player.Functions.AddItem("markedbills", 1 , false ,info)
end

local function GiveAndCheckItem(item,amount,weapon,price,balance,billtype)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BlackMoneyName = Config.BlackMoneyName
    if weapon then
        for i = 1, amount do
            if exports[Config.Inventory]:AddItem(item, 1) then
                if tonumber(i) == tonumber(amount) then
                    if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" then
                        payByMarkedBills(balance,price)
                    else
                        Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
                    end
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add", amount)
                end
            else
                TriggerClientEvent('QBCore:Notify', source, Lang:t("error.cant_give"), "error") break
            end
            Wait(5)
        end
    else
        if exports[Config.Inventory]:AddItem(item, amount) then
            if Config.Payment == "blackmoney" and BlackMoneyName == "markedbills" then
                payByMarkedBills(balance,price)
            else
                Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
            end
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add", amount)
        else
            TriggerClientEvent('QBCore:Notify', source,  Lang:t("error.cant_give"), "error")
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
            Balance = getMarkedBillWorth()
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
        GiveAndCheckItem(item,amount,true,price,Balance,billtype)
    end
    local data = {}
    data.shoptable = shoptable
    custom = true
    if Config.RemoveItem then
        Player.Functions.RemoveItem(removeitem, 1)
    else
        TriggerClientEvent('ik-blackmarket:ShopMenu', src, data, custom)
    end
end)