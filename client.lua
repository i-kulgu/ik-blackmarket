local QBCore = exports['qb-core']:GetCoreObject()
m = 0
PlayerJob = {}
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end) end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
    QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end)
    mainthread()
end)

if Config.UseTimer then
    Citizen.CreateThread(function()
        local minutes = Config.ChangeLocationTime
        while true do
            Citizen.Wait(60000)
            minutes = minutes - 1
            if minutes == 0 then
                TriggerEvent("ik-blackmarket:client:removeall")
                mainthread()
                minutes = Config.ChangeLocationTime
            end
        end
    end)
end
Citizen.CreateThread(function()
    mainthread()
end)

ped = {}
local productstable = {}
function mainthread()
    for k, v in pairs(Config.Locations) do
        if Config.RandomItem then
            local ia = 0 
            repeat
                ia += 1
                local tp = v.products
                local pr = math.random(1, #tp)
                productstable[#productstable+1] = {name = v.products[pr].name, price = v.products[pr].price, crypto = v.products[pr].crypto, amount = v.products[pr].amount }
            until ia == Config.RandomItemAmount
        else
            productstable = v.products
        end
        if Config.RandomLocation then
            m = math.random(1, #v["coords"]) -- generate a random coordinate
            if not v["hideblip"] then -- Create blip if set to false
                StoreBlip = AddBlipForCoord(b)
                SetBlipSprite(StoreBlip, v["blipsprite"])
                SetBlipScale(StoreBlip, 0.7)
                SetBlipDisplay(StoreBlip, 6)
                SetBlipColour(StoreBlip, v["blipcolour"])
                SetBlipAsShortRange(StoreBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(v["label"])
                EndTextCommandSetBlipName(StoreBlip)
            end
            -- Create ped for random location number in m
            local i = math.random(1, #v["model"]) -- Get random ped model
            RequestModel(v["model"][i]) while not HasModelLoaded(v["model"][i]) do Wait(0) end
            if ped["['"..k.."("..m..")']"] == nil then ped["['"..k.."("..m..")']"] = CreatePed(0, v["model"][i], v["coords"][m].x, v["coords"][m].y, v["coords"][m].z-1.0, v["coords"][m].a, false, false) end
            if not v["killable"] then SetEntityInvincible(ped["['"..k.."("..m..")']"], true) end
            local scenarios = { "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", "WORLD_HUMAN_GUARD_PATROL", "WORLD_HUMAN_JANITOR", "WORLD_HUMAN_MUSCLE_FLEX", "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", "PROP_HUMAN_STAND_IMPATIENT", }
            scenario = math.random(1, #scenarios) -- Get random scenario
            TaskStartScenarioInPlace(ped["['"..k.."("..m..")']"], scenarios[scenario], -1, true)
            SetBlockingOfNonTemporaryEvents(ped["['"..k.."("..m..")']"], true)
            FreezeEntityPosition(ped["['"..k.."("..m..")']"], true)
            SetEntityNoCollisionEntity(ped["['"..k.."("..m..")']"], PlayerPedId(), false)
            if Config.Debug then print("Ped Created for Shop - ['"..k.."("..m..")']") end

            if Config.Debug then print("Shop - ['"..k.."("..m..")']") end
            exports['qb-target']:AddCircleZone("['"..k.."("..m..")']", vector3(v["coords"][m].x, v["coords"][m].y, v["coords"][m].z), 2.0, { name="['"..k.."("..m..")']", debugPoly=Config.Debug, useZ=true, },{ options = { { event = "ik-blackmarket:ShopMenu", icon = "fas fa-certificate", label = Lang:t("target.browse"),item = (v.openwith or nil),gang = (v.gang or nil), shoptable = v, products = productstable, name = v["label"], k = k, l = m, }, }, distance = 2.0 })
        else
            for l, b in pairs(v["coords"]) do -- Create ped for each location given in Config
                if not v["hideblip"] then -- Create blip if set to false
                    StoreBlip = AddBlipForCoord(b)
                    SetBlipSprite(StoreBlip, v["blipsprite"])
                    SetBlipScale(StoreBlip, 0.7)
                    SetBlipDisplay(StoreBlip, 6)
                    SetBlipColour(StoreBlip, v["blipcolour"])
                    SetBlipAsShortRange(StoreBlip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(v["label"])
                    EndTextCommandSetBlipName(StoreBlip)
                end
                -- Create ped for each location in coords
                local i = math.random(1, #v["model"])
                RequestModel(v["model"][i]) while not HasModelLoaded(v["model"][i]) do Wait(0) end
                if ped["Shop - ['"..k.."("..l..")']"] == nil then ped["Shop - ['"..k.."("..l..")']"] = CreatePed(0, v["model"][i], b.x, b.y, b.z-1.0, b.a, false, false) end
                if not v["killable"] then SetEntityInvincible(ped["Shop - ['"..k.."("..l..")']"], true) end
                local scenarios = { "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", "WORLD_HUMAN_GUARD_PATROL", "WORLD_HUMAN_JANITOR", "WORLD_HUMAN_MUSCLE_FLEX", "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", "PROP_HUMAN_STAND_IMPATIENT", }
                scenario = math.random(1, #scenarios)
                TaskStartScenarioInPlace(ped["Shop - ['"..k.."("..l..")']"], scenarios[scenario], -1, true)
                SetBlockingOfNonTemporaryEvents(ped["Shop - ['"..k.."("..l..")']"], true)
                FreezeEntityPosition(ped["Shop - ['"..k.."("..l..")']"], true)
                SetEntityNoCollisionEntity(ped["Shop - ['"..k.."("..l..")']"], PlayerPedId(), false)
                if Config.Debug then print("Ped Created for Shop - ['"..k.."("..l..")']") end

                if Config.Debug then print("Shop - ['"..k.."("..l..")']") end
                exports['qb-target']:AddCircleZone("Shop - ['"..k.."("..l..")']", vector3(b.x, b.y, b.z), 2.0, { name="Shop - ['"..k.."("..l..")']", debugPoly=Config.Debug, useZ=true, },{ options = { { event = "ik-blackmarket:ShopMenu", icon = "fas fa-certificate", label = Lang:t("target.browse"), item = (v.openwith or nil),gang = (v.gang or nil), shoptable = v, products = productstable, name = v["label"], k = k, l = l, }, }, distance = 2.0 })
            end
        end
    end
end

RegisterNetEvent('ik-blackmarket:ShopMenu', function(data, custom)
    local products = data.products
    local rmi = data.item
    local ShopMenu = {}
    local hasLicense, hasLicenseItem = nil
    ShopMenu[#ShopMenu + 1] = { header = data.shoptable["label"], txt = "", isMenuHeader = true }
    ShopMenu[#ShopMenu + 1] = { header = "", txt = Lang:t("menu.close"), params = { event = "ik-blackmarket:CloseMenu" } }

    for i = 1, #products do
        local amount = nil
        local lock = false
        if products[i].price == 0 then
            price = "Free"
        else
            if Config.Payment == "blackmoney" then
                totalprice = (products[i].price * Config.BlackMoneyMultiplier)
                price = Lang:t("menu.cost")..totalprice
            elseif Config.Payment == "crypto" then
                totalprice = products[i].crypto
                price = Lang:t("menu.cost")..totalprice
            else
                totalprice = products[i].price
                price = Lang:t("menu.cost")..totalprice
            end
        end

        local setheader = QBCore.Shared.Items[tostring(products[i].name)].label --"<img src=nui://"..Config.img..QBCore.Shared.Items[products[i].name].image.." width=35px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[tostring(products[i].name)].label
        local text = price.."<br>"..Lang:t("menu.weight").." "..(QBCore.Shared.Items[products[i].name].weight / 1000)..Config.Measurement
        if products[i].requiredJob then
            for i2 = 1, #products[i].requiredJob do
                if QBCore.Functions.GetPlayerData().job.name == products[i].requiredJob[i2] then
                    ShopMenu[#ShopMenu + 1] = { icon = products[i].name, header = setheader, txt = text, isMenuHeader = lock,
                        params = { event = "ik-blackmarket:Charge", args = { item = products[i].name, cost = totalprice, info = products[i].info, shoptable = data.shoptable, k = data.k, l = data.l, amount = amount, custom = custom, rem = rmi} } }
                end
            end
        elseif products[i].requiresLicense then
            if hasLicense and hasLicenseItem then
            ShopMenu[#ShopMenu + 1] = { icon = products[i].name, header = setheader, txt = text, isMenuHeader = lock,
                    params = { event = "ik-blackmarket:Charge", args = { item = products[i].name, cost = totalprice, info = products[i].info, shoptable = data.shoptable, k = data.k, l = data.l, amount = amount, custom = custom, rem = rmi} } }
            end
        else
            ShopMenu[#ShopMenu + 1] = { icon = products[i].name, header = setheader, txt = text, isMenuHeader = lock,
                    params = { event = "ik-blackmarket:Charge", args = {
                                    item = products[i].name,
                                    cost = totalprice,
                                    info = products[i].info,
                                    shoptable = products,
                                    k = data.k,
                                    l = data.l,
                                    amount = amount,
                                    custom = custom,
                                    rem = rmi,
                                } } }
        end
        text, setheader = nil
    end
    exports['qb-menu']:openMenu(ShopMenu)
end)

RegisterNetEvent('ik-blackmarket:CloseMenu', function() exports['qb-menu']:closeMenu() end)

RegisterNetEvent('ik-blackmarket:Charge', function(data)
    if data.cost == "Free" then price = data.cost else if Config.Payment == "crypto" then price = "₿"..data.cost else price = "$"..data.cost end end
    if QBCore.Shared.Items[data.item].weight == 0 then weight = "" else weight = Lang:t("menu.weight").." "..(QBCore.Shared.Items[data.item].weight / 1000)..Config.Measurement end
    local settext = "- "..Lang:t("menu.confirm").." -<br><br>"
    settext = settext..weight.."<br> "..Lang:t("menu.cpi").." "..price.."<br><br>- "..Lang:t("menu.payment_type").." -"
    local header = "<center><p><img src=nui://"..Config.img..QBCore.Shared.Items[data.item].image.." width=100px></p>"..QBCore.Shared.Items[data.item].label
    if data.shoptable["logo"] ~= nil then header = "<center><p><img src="..data.shoptable["logo"].." width=150px></img></p>"..header end

    local newinputs = {}
    if Config.UseDirtyMoney and Config.Payment == "blackmoney" then
        newinputs[#newinputs+1] = { type = 'radio', name = 'billtype', text = settext, options = { { value = "blackmoney", text = Lang:t("menu.blackmoney") }}}
    elseif Config.UseDirtyMoney and Config.Payment == "crypto" then
        newinputs[#newinputs+1] = { type = 'radio', name = 'billtype', text = settext, options = { { value = "crypto", text = Lang:t("menu.crypto") }}}
    else
        newinputs[#newinputs+1] = { type = 'radio', name = 'billtype', text = settext, options = { { value = "cash", text = Lang:t("menu.cash") }, { value = "bank", text = Lang:t("menu.card") } } }
    end
    newinputs[#newinputs+1] = { type = 'number', isRequired = true, name = 'amount', text = Lang:t("menu.amount") }

    local dialog = exports['qb-input']:ShowInput({ header = header, submitText = Lang:t("menu.submittext"), inputs = newinputs })
    if dialog then
        if not dialog.amount then return end
        if tonumber(dialog.amount) <= 0 then TriggerEvent("QBCore:Notify", Lang:t("error.incorrect_amount"), "error") TriggerEvent("ik-blackmarket:Charge", data) return end
        if data.cost == "Free" then data.cost = 0 end
        TriggerServerEvent('ik-blackmarket:GetItem', dialog.amount, dialog.billtype, data.item, data.shoptable, data.cost, data.rem)
        RequestAnimDict('amb@prop_human_atm@male@enter')
        while not HasAnimDictLoaded('amb@prop_human_atm@male@enter') do Wait(1) end
        if HasAnimDictLoaded('amb@prop_human_atm@male@enter') then TaskPlayAnim(PlayerPedId(), 'amb@prop_human_atm@male@enter', "enter", 1.0,-1.0, 1500, 1, 1, true, true, true) end
    end
end)

RegisterNetEvent("ik-blackmarket:client:removeall",function()
    for k, v in pairs(Config.Locations) do
        if Config.RandomLocation then
            exports['qb-target']:RemoveZone("['"..k.."("..m..")']")
            if Config.Peds then	DeletePed(ped["['"..k.."("..m..")']"]) end
        else
            for l, b in pairs(v["coords"]) do
                exports['qb-target']:RemoveZone("['"..k.."("..l..")']")
                if Config.Peds then	DeletePed(ped["['"..k.."("..l..")']"]) end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    TriggerEvent("ik-blackmarket:client:removeall")
end)
