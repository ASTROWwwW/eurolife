local isFishing = false
local fishingRod = nil

Citizen.CreateThread(function()
    -- Ajout des blips pour les zones de pêche
    for _, zone in pairs(Config.FishingZones) do
        local blip = AddBlipForRadius(zone.x, zone.y, zone.z, zone.radius)
        SetBlipSprite(blip, zone.blip.sprite)
        SetBlipColour(blip, zone.blip.color)
        SetBlipAlpha(blip, 128) -- Transparence (0-255)
        SetBlipAsShortRange(blip, true) -- Blip visible seulement de près

        local blipIcon = AddBlipForCoord(zone.x, zone.y, zone.z)
        SetBlipSprite(blipIcon, zone.blip.sprite)
        SetBlipColour(blipIcon, zone.blip.color)
        SetBlipScale(blipIcon, 0.5) -- Taille du blip (0.8 = 80% de la taille normale)
        SetBlipAsShortRange(blipIcon, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(zone.blip.name)
        EndTextCommandSetBlipName(blipIcon)
    end
end)

-- Vérifie si le joueur est dans une zone de pêche
function IsInFishingZone()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    for _, zone in pairs(Config.FishingZones) do
        if Vdist(coords.x, coords.y, coords.z, zone.x, zone.y, zone.z) < zone.radius then
            return true
        end
    end
    return false
end

-- Fonction pour créer la canne à pêche si elle n'existe pas
function CreateFishingRod()
    if fishingRod then return end
    
    local playerPed = PlayerPedId()
    local rodHash = GetHashKey('prop_fishing_rod_01')
    
    RequestModel(rodHash)
    while not HasModelLoaded(rodHash) do
        Citizen.Wait(10)
    end
    
    fishingRod = CreateObject(rodHash, 0, 0, 0, true, true, true)
    AttachEntityToEntity(fishingRod, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(rodHash)
end

-- Fonction pour retirer la canne à pêche
function RemoveFishingRod()
    if fishingRod then
        DeleteObject(fishingRod)
        fishingRod = nil
    end
end

-- Fonction principale de pêche
function StartFishing(hookType)
    if isFishing then return end
    isFishing = true
    
    local playerPed = PlayerPedId()
    CreateFishingRod()
    
    -- Charger l'animation si elle n'est pas déjà chargée
    if not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') then
        RequestAnimDict('amb@world_human_stand_fishing@idle_a')
        while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do
            Citizen.Wait(10)
        end
    end
    
    -- Jouer l'animation de pêche
    TaskPlayAnim(playerPed, 'amb@world_human_stand_fishing@idle_a', 'idle_a', 8.0, -8.0, -1, 49, 0, false, false, false)
    
    ESX.ShowNotification("Tu commences à pêcher...")
    
    local fishTime = math.random(Config.FishTimeMin, Config.FishTimeMax) * 1000
    Citizen.Wait(fishTime)
    
    -- Vérifie si l'hameçon casse
    local breakChance = Config.Hooks[hookType].breakChance
    if math.random() < breakChance then
        TriggerServerEvent('esx_fishing:hookBroke', hookType)
        ESX.ShowNotification("Ton hameçon s'est cassé !")
        StopFishing()
    else
        -- Ça mord !
        ESX.ShowNotification("🐟 Ça mord ! Appuie sur ~o~G~w~ pour attraper le poisson !")
        PlaySound(-1, "FocusIn", "HintCamSounds", 0, 0, 1)
        
        -- Attendre que le joueur appuie sur G pendant 3 secondes
        local startTime = GetGameTimer()
        local catchSuccess = false
        
        while GetGameTimer() - startTime < 3000 do -- 3 secondes pour réagir
            Citizen.Wait(0)
            
            if IsControlJustPressed(0, 47) then -- Touche G
                catchSuccess = true
                -- Animation de capture réussie
                TaskPlayAnim(playerPed, 'amb@world_human_stand_fishing@idle_a', 'idle_b', 8.0, -8.0, -1, 49, 0, false, false, false)
                Citizen.Wait(2000)
                break
            end
        end
        
        if catchSuccess then
            -- Le joueur a attrapé le poisson
            TriggerServerEvent('esx_fishing:tryCatchFish', hookType)
            -- ESX.ShowNotification("Bien joué ! Tu as attrapé un ~g~" .. caughtFish.name .. " !")
        else
            -- Le poisson s'est échappé
            ESX.ShowNotification("Trop tard ! Le poisson s'est ~r~échappé...")
        end
        
        StopFishing()
    end
end

-- Fonction pour arrêter la pêche
function StopFishing()
    if not isFishing then return end
    
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    RemoveFishingRod()
    isFishing = false
end

-- Boucle principale pour afficher la notification et gérer l'interaction
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsInFishingZone() then
            if not isFishing then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour commencer à pêcher")
                if IsControlJustPressed(0, 38) then -- Touche E
                    ESX.TriggerServerCallback('esx_fishing:checkRequirements', function(hasRequirements, hookType)
                        if hasRequirements then
                            StartFishing(hookType)
                        else
                            ESX.ShowNotification("Tu as besoin d'une canne à pêche et d'un hameçon pour pêcher !")
                        end
                    end)
                end
            else
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour arrêter de pêcher")
                if IsControlJustPressed(0, 38) then -- Touche E
                    StopFishing()
                end
            end
        else
            if isFishing then
                StopFishing()
            end
        end
    end
end)

------------------------- VENDEUR --------------------------

-- Variables pour le menu RageUI
local RMenu = {}
local fishSellerOpen = false
local playerInventory = nil -- Variable pour stocker l'inventaire

-- Créer le PNJ vendeur
Citizen.CreateThread(function()
    -- Ajouter le blip sur la carte
    local blip = AddBlipForCoord(Config.FishBuyer.position)
    SetBlipSprite(blip, Config.FishBuyer.blip.sprite)
    SetBlipColour(blip, Config.FishBuyer.blip.color)
    SetBlipScale(blip, 0.5) -- Taille du blip (1.0 = taille normale, vous pouvez ajuster)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.FishBuyer.blip.name)
    EndTextCommandSetBlipName(blip)
    
    -- Créer le PNJ
    RequestModel(GetHashKey(Config.FishBuyer.model))
    while not HasModelLoaded(GetHashKey(Config.FishBuyer.model)) do
        Citizen.Wait(1)
    end
    
    local fishSeller = CreatePed(4, GetHashKey(Config.FishBuyer.model), 
        Config.FishBuyer.position.x, Config.FishBuyer.position.y, Config.FishBuyer.position.z - 1.0, 
        Config.FishBuyer.heading, false, true)
    
    SetEntityHeading(fishSeller, Config.FishBuyer.heading)
    FreezeEntityPosition(fishSeller, true)
    SetEntityInvincible(fishSeller, true)
    SetBlockingOfNonTemporaryEvents(fishSeller, true)
    
    -- Animation du PNJ
    TaskStartScenarioInPlace(fishSeller, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

-- Fonction pour ouvrir le menu de vente
function OpenFishSellerMenu()
    if fishSellerOpen then return end
    fishSellerOpen = true
    
    -- Récupérer l'inventaire du joueur une seule fois à l'ouverture
    ESX.TriggerServerCallback('esx_fishing:getPlayerInventory', function(inventory)
        playerInventory = inventory
        
        RMenu.FishSeller = RageUI.CreateMenu("Acheteur de poissons", "Vendre vos poissons")
        
        RageUI.Visible(RMenu.FishSeller, true)
        
        Citizen.CreateThread(function()
            while fishSellerOpen do
                Citizen.Wait(0)
                
                RageUI.IsVisible(RMenu.FishSeller, function()
                    local fishFound = false
                    
                    -- Afficher tous les poissons dans l'inventaire
                    for _, fish in pairs(Config.Fish) do
                        local count = 0
                        for i=1, #playerInventory.items, 1 do
                            if playerInventory.items[i].name == fish.item then
                                count = playerInventory.items[i].count
                                break
                            end
                        end
                        
                        if count > 0 then
                            fishFound = true
                            local price = Config.FishPrices[fish.item] or 0
                            
                            RageUI.Button(fish.name, "Quantité: " .. count .. " | Prix unitaire: $" .. price, {RightLabel = "Vendre"}, true, {
                                onSelected = function()
                                    -- Demander la quantité à vendre
                                    local amount = KeyboardInput("FISH_SELL_AMOUNT", "Quantité à vendre (max " .. count .. ")", "", 8)
                                    amount = tonumber(amount)
                                    
                                    if amount and amount > 0 and amount <= count then
                                        TriggerServerEvent('esx_fishing:sellFish', fish.item, amount)
                                        -- Actualiser l'inventaire après une vente
                                        RefreshInventory()
                                    else
                                        ESX.ShowNotification("Quantité invalide !")
                                    end
                                end
                            })
                        end
                    end
                    
                    if not fishFound then
                        RageUI.Separator("~r~Vous n'avez pas de poissons à vendre")
                    end
                    
                end)
                
                if not RageUI.Visible(RMenu.FishSeller) then
                    fishSellerOpen = false
                    RMenu.FishSeller = nil
                    playerInventory = nil -- Nettoyer l'inventaire quand on ferme le menu
                end
            end
        end)
    end)
end

-- Fonction pour saisir des données au clavier (utile pour la quantité)
function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

-- Vérifier la proximité du vendeur
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - Config.FishBuyer.position)
        
        if dist <= 3.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler à l'acheteur de poissons")
            
            if IsControlJustPressed(0, 38) then -- Touche E
                OpenFishSellerMenu()
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Fonction pour actualiser l'inventaire
function RefreshInventory()
    ESX.TriggerServerCallback('esx_fishing:getPlayerInventory', function(inventory)
        playerInventory = inventory
    end)
end

----------------------------- -----------------------------------------

-- Nettoyage quand le script est arrêté
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        RemoveFishingRod()
    end
end)