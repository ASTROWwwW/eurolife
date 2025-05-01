local nuiOpen = false
local displayedVehicle = nil
local vehicleCam = nil
local initialCoords = nil
local initialBucket = nil
local phoneProp = nil

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end

for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

if Config.NewEsx == true then 
    ESX = exports['es_extended']:getSharedObject()
else
    ESX = nil 
    CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
            Wait(0)
        end
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CloseMenuUI()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)

    CloseMenuUI()

end)


RegisterNUICallback('itemGagneClient', function()

    TriggerServerEvent('lootbox:itemGagneServeur')

end)


function OpenMenuUI()

    if not nuiOpen then 

        nuiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            config = {
                BoutonArmes = Config.BoutonArmes,
                BoutonLootBox = Config.BoutonLootBox,
                BoutonVoiture = Config.BoutonVoiture,
                BoutonHistorique = Config.BoutonHistorique,
                TebexUrl = Config.TebexUrl,
                WebsiteUrl = Config.WebsiteUrl,
                DiscordUrl = Config.DiscordUrl,
                ActiverTebexUrl = Config.ActiverTebexUrl,
                ActiverWebSiteUrl = Config.ActiverWebSiteUrl,
                ActiverDiscordUrl = Config.ActiverDiscordUrl,
                VideoId = Config.VideoId,
                lootBoxes = Config.LootBox,
                ActiverMusique = Config.ActiverMusique
            }
            
        })

        TriggerServerEvent('fetchUserData')

    end

end

function CloseMenuUI()

    if nuiOpen then 

        nuiOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'close'
        })

    end

end



RegisterNetEvent('boutique:fermeture')
AddEventHandler('boutique:fermeture', function()

    CloseMenuUI()

end)

RegisterNetEvent('Boutique:SetupVeh')
AddEventHandler('Boutique:SetupVeh', function(model , Plate)

    Config.FunctionClientAfterSpawnCar(model , Plate)

end)

RegisterNetEvent('receiveUserData')
AddEventHandler('receiveUserData', function(data)
    SendNUIMessage({
        action = 'updateData',
        users = data
    })
end)

RegisterCommand('OpenMenuUI', function()
    OpenMenuUI()
end, false)

RegisterKeyMapping('OpenMenuUI', 'Ouvrir la boutique', 'keyboard', 'F1')


RegisterNUICallback('closeall', function()
    CloseMenuUI()
end)


function showMidsizeBanner(_title, _subtitle, _bannerColor)
    Citizen.CreateThread(function()
        local scaleform = RequestScaleformMovie('MIDSIZED_MESSAGE')

        while not HasScaleformMovieLoaded(scaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(scaleform, "SHOW_COND_SHARD_MESSAGE")
        PushScaleformMovieFunctionParameterString(_title)
        PushScaleformMovieFunctionParameterString(_subtitle)
        PushScaleformMovieFunctionParameterInt(_bannerColor)
        PushScaleformMovieFunctionParameterBool(true)
        PopScaleformMovieFunctionVoid()

        local start = GetGameTimer()
        while (GetGameTimer() - start) < 3000 do 
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            Wait(0)
        end
    end)
end

function showCountdown(_number, _r, _g, _b)
    Citizen.CreateThread(function()
        local scaleform = RequestScaleformMovie('COUNTDOWN')

        while not HasScaleformMovieLoaded(scaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(scaleform, "SET_MESSAGE")
        PushScaleformMovieFunctionParameterInt(_number)
        PushScaleformMovieFunctionParameterInt(_r)
        PushScaleformMovieFunctionParameterInt(_g)
        PushScaleformMovieFunctionParameterInt(_b)
        PushScaleformMovieFunctionParameterBool(true)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "FADE_MP")
        PushScaleformMovieFunctionParameterInt(_number)
        PushScaleformMovieFunctionParameterInt(_r)
        PushScaleformMovieFunctionParameterInt(_g)
        PushScaleformMovieFunctionParameterInt(_b)
        PopScaleformMovieFunctionVoid()

        local start = GetGameTimer()
        while (GetGameTimer() - start) < 1000 do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            Wait(0)
        end
    end)
end

function TestVehicle(vehicleName)

    local playerId = GetPlayerServerId(PlayerId())
    local testCoords = vector3(-910.65, -3289.64, 13.94-1)
    local testHeading = 58.23

    if initialCoords == nil then 
        initialCoords = GetEntityCoords(PlayerPedId())
    end

    TriggerServerEvent('wBoutique:changePlayerBucket', tonumber(playerId))

    ESX.Streaming.RequestModel(vehicleName)
    while not HasModelLoaded(vehicleName) do
        Wait(0)
    end

    vehicle = CreateVehicle(vehicleName, testCoords.x, testCoords.y, testCoords.z, testHeading, false, true)
    FreezeEntityPosition(vehicle, true)

    if DoesEntityExist(vehicle) then
        Wait(500) 

        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetVehicleDoorsLocked(vehicle, 4)

        showMidsizeBanner(Config.SpawnCarTextHeader, Config.SpawnCarText, 2)

        Wait(3000)
        FreezeEntityPosition(vehicle, false)

        for i = 20, 1, -1 do
            showCountdown(i, 255, 0, 0)
            Wait(1000)
        end

        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
        SetEntityCoords(PlayerPedId(), initialCoords)

        TriggerServerEvent('wBoutique:changePlayerBucket', 0)

    end
end




RegisterNUICallback('acheterArmeClient', function(data)

    local armeName = data.armeName
    local prix = data.prix
    local typeArme = data.type
    local Label = data.label

    TriggerServerEvent('boutique:acheterArme', armeName, prix, typeArme, Label)
end)

RegisterNUICallback('updateAvatar', function(data, cb)
    TriggerServerEvent('Boutique:updateAvatar', data.id, data.avatar)
    cb('ok')
end)

function OpenArmesModal()
    SendNUIMessage({
        action = 'updateArmes',
        armes = Config.SaleWeapon
    })
end

function OpenCarsModal()
    SendNUIMessage({
        action = 'updateCars',
        cars = Config.SaleCar
    })
end

RegisterNUICallback('historiqueClicked', function(data, cb)
    TriggerServerEvent('boutique:requestHistorique')
    cb('ok')
end)

RegisterNetEvent('boutique:openHistorique')
AddEventHandler('boutique:openHistorique', function(historiqueData)
    SendNUIMessage({
        action = 'openHistorique',
        historique = historiqueData
    })
end)

RegisterNUICallback('verifierPoints', function(data)

    local lootBoxId = data.lootBoxId
    TriggerServerEvent('lootbox:verifierPoints', lootBoxId)

end)

RegisterNetEvent('lootbox:resultat')
AddEventHandler('lootbox:resultat', function(selectedItem)

    SendNUIMessage({
        action = 'afficherLootboxGagne',
        item = selectedItem
    })
end)

RegisterNUICallback('carsClicked', function()
    OpenCarsModal()
end)

RegisterNUICallback('armesClicked', function()
    OpenArmesModal()
end)


RegisterNUICallback('testerCarClient', function(veh)
    CloseMenuUI()
    TestVehicle(veh.carName)
end)

RegisterNUICallback('acheterCarClient', function(veh)
    CloseMenuUI()
    TriggerServerEvent('Boutique:AchatVeh', veh.carName, veh.carLabel, veh.prix)
end)
