local currentCoffre = nil
local isCoffreMenuOpen = false
local forceRefresh = false
local coffreAttempts = {}

RegisterNetEvent('eurolife_coffre:openCoffre', function(coffre)
    if isCoffreMenuOpen then return end
    currentCoffre = coffre

    local identifier = GetPlayerServerId(PlayerId()).."-"..coffre.id

    if coffreAttempts[identifier] and coffreAttempts[identifier].lockUntil and GetGameTimer() < coffreAttempts[identifier].lockUntil then
        local remaining = math.ceil((coffreAttempts[identifier].lockUntil - GetGameTimer()) / 1000)
        ESX.ShowNotification("~r~Coffre bloqué. Réessaie dans "..remaining.." secondes.")
        PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", 1)
        return
    end

    if currentCoffre.password and currentCoffre.password ~= "" then
        if not coffreAttempts[identifier] then
            coffreAttempts[identifier] = {tries = 0, lockUntil = nil}
        end

        local input = KeyboardInput("Mot de passe du coffre", "", 30)

        if not input or input ~= currentCoffre.password then
            coffreAttempts[identifier].tries = coffreAttempts[identifier].tries + 1
            PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", 1)
            ESX.ShowNotification("~r~Mot de passe incorrect. Tentatives restantes : "..(3 - coffreAttempts[identifier].tries))

            if coffreAttempts[identifier].tries >= 3 then
                coffreAttempts[identifier].lockUntil = GetGameTimer() + (5 * 60 * 1000)
                ESX.ShowNotification("~r~Trop d'erreurs. Coffre bloqué pour 5 minutes.")
            end

            isCoffreMenuOpen = false
            currentCoffre = nil
            return
        else
            PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            ESX.ShowNotification("~g~Accès autorisé.")
            coffreAttempts[identifier] = nil
        end
    end
    TriggerServerEvent('eurolife_coffre:requestCoffreData', currentCoffre.id)
    isCoffreMenuOpen = true

    local mainMenu = RageUI.CreateMenu(""..coffre.label, "Gestion du coffre")
    local depositMenu = RageUI.CreateSubMenu(mainMenu, "Déposer Item", "Items dans votre inventaire")
    RageUI.Visible(mainMenu, true)

    local moneyGestion, blackGestion = 1, 1

    CreateThread(function()
        while isCoffreMenuOpen do
            local playerData = ESX.GetPlayerData()
            Wait(1)

            if forceRefresh then
                forceRefresh = false
            end

            RageUI.IsVisible(mainMenu, function()
                --RageUI.Separator("Bonjour : ~b~"..playerData.name.." ~s~| ~o~"..playerData.job.label)
                local currentWeight = CalculateCoffreWeight(currentCoffre)
                RageUI.Separator("Poids : ~o~"..string.format("%.1f", currentWeight).."~s~/~b~"..currentCoffre.maxWeight.."kg")
                RageUI.Line()

                RageUI.Separator("Argent Propre : ~g~"..(currentCoffre.money or 0).."$~s~")
                RageUI.Separator("Argent Sale : ~r~"..(currentCoffre.black_money or 0).."$~s~")
                RageUI.Line()

                if not currentCoffre.items or #currentCoffre.items == 0 then
                    RageUI.Separator("~r~Aucun item dans ce coffre.")
                else
                    for k,v in pairs(currentCoffre.items) do
                        RageUI.Button((v.label or v.name).." x"..v.count, nil, {}, true, {
                            onSelected = function()
                                local maxAmount = v.count or 1
                                local amount = 1

                                if maxAmount > 1 then
                                    local input = KeyboardInput("Combien retirer ?", "", 3)
                                    amount = tonumber(input)
                                end

                                if amount and amount > 0 and amount <= maxAmount then
                                    v.count = v.count - amount
                                    if v.count <= 0 then
                                        table.remove(currentCoffre.items, k)
                                    end
                                    TriggerServerEvent("eurolife_coffre:removeItem", currentCoffre.id, v.name, amount)
                                end
                            end
                        })
                    end
                end

                RageUI.Line()

                RageUI.Button("~g~Déposer un Item", nil, {RightLabel = "→"}, true, {}, depositMenu)

                RageUI.List("Gestion Argent Propre", {"Déposer", "Retirer"}, moneyGestion, nil, {}, true, {
                    onListChange = function(Index)
                        moneyGestion = Index
                    end,
                    onSelected = function()
                        local amount = tonumber(KeyboardInput("Montant ?", "", 5))
                        if amount and amount > 0 then
                            if moneyGestion == 1 then
                                -- Dépôt => vérif local argent joueur
                                local playerMoney = ESX.GetPlayerData().money
                                print("Argent joueur:", playerMoney)
                                if playerMoney >= amount then
                                    currentCoffre.money = (currentCoffre.money or 0) + amount
                                    TriggerServerEvent("eurolife_coffre:depositMoney", currentCoffre.id, amount)
                                    print("Dépot validé | Coffre ID:", currentCoffre.id, "| Montant:", amount)
                                else
                                    ESX.ShowNotification("~r~Pas assez d'argent pour déposer.")
                                end
                            else
                                -- Retrait => vérif que coffre a assez
                                if currentCoffre.money and currentCoffre.money >= amount then
                                    currentCoffre.money = math.max((currentCoffre.money or 0) - amount, 0)
                                    TriggerServerEvent("eurolife_coffre:withdrawMoney", currentCoffre.id, amount)
                                    print("Retrait validé | Coffre ID:", currentCoffre.id, "| Montant:", amount)
                                else
                                    ESX.ShowNotification("~r~Pas assez d'argent dans le coffre.")
                                end
                            end
                        end
                    end
                    
                })

                RageUI.List("Gestion Argent Sale", {"Déposer", "Retirer"}, blackGestion, nil, {}, true, {
                    onListChange = function(Index)
                        blackGestion = Index
                    end,
                    onSelected = function()
                        local amount = tonumber(KeyboardInput("Montant ?", "1", 5))
                        if amount and amount > 0 then
                            if blackGestion == 1 then
                                currentCoffre.black_money = (currentCoffre.black_money or 0) + amount
                                TriggerServerEvent("eurolife_coffre:depositBlackMoney", currentCoffre.id, amount)
                            else
                                currentCoffre.black_money = math.max((currentCoffre.black_money or 0) - amount, 0)
                                TriggerServerEvent("eurolife_coffre:withdrawBlackMoney", currentCoffre.id, amount)
                            end
                        end
                    end
                })

            end)

            RageUI.IsVisible(depositMenu, function()
                local inventory = ESX.GetPlayerData().inventory
                for k,v in pairs(inventory) do
                    if v.count > 0 then
                        RageUI.Button(v.label.." x"..v.count, nil, {}, true, {
                            onSelected = function()
                                local maxAmount = v.count or 1
                                local amount = 1

                                if maxAmount > 1 then
                                    local input = KeyboardInput("Combien déposer ?", "", 3)
                                    amount = tonumber(input)
                                end

                                if amount and amount > 0 and amount <= maxAmount then
                                    local found = false
                                    for _, item in pairs(currentCoffre.items) do
                                        if item.name == v.name then
                                            item.count = item.count + amount
                                            found = true
                                            break
                                        end
                                    end
                                    if not found then
                                        table.insert(currentCoffre.items, {name = v.name, label = v.label or v.name, count = amount})
                                    end
                                    TriggerServerEvent("eurolife_coffre:addItem", currentCoffre.id, v.name, amount)
                                    
                                end
                            end
                        })
                    end
                end
            end)

            if not RageUI.Visible(mainMenu) and not RageUI.Visible(depositMenu) then
                isCoffreMenuOpen = false
                currentCoffre = nil
            end
        end
    end)
end)

function CalculateCoffreWeight(coffre)
    local totalWeight = 0
    if coffre.items and #coffre.items > 0 then
        for _, item in pairs(coffre.items) do
            -- Si chaque item a une propriété weight
            if item.weight then
                totalWeight = totalWeight + (item.weight * item.count)
            -- Sinon, on utilise un poids par défaut de 1.0 par item
            else
                totalWeight = totalWeight + (1.0 * item.count)
            end
        end
    end
    return totalWeight
end


RegisterNetEvent('eurolife_coffre:updateCurrentCoffre', function(coffreData)
    if not coffreData then return end
    if not currentCoffre then return end
    currentCoffre.items = coffreData.items or {}
    currentCoffre.money = coffreData.money or 0
    currentCoffre.black_money = coffreData.black_money or 0
    forceRefresh = true
end)

function ReloadCoffreAndReopen()
    if not currentCoffre then return end
    TriggerServerEvent('eurolife_coffre:requestCoffreData', currentCoffre.id)
end


