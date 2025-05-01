Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            Callback.triggerServerCallback('Yvelt:getJail', function(table)
                if table then
                    openjailMenu(table)
                end
            end)
            break
        end
    end
end)

local jail = {
    open = false,
}

mainMenujail = RageUI.CreateMenu('Jail', 'MENU DE PRISON')
mainMenujail.Closable = false

RegisterNetEvent('Yvelt:SendClientToJail')
AddEventHandler('Yvelt:SendClientToJail', function(table)
    openjailMenu(table)
end)

local time = 999999999
local displayTime = "0"
local seconds = 0
local minutes = 0

function updateTimeDisplay()
    if minutes == 1 then
        displayTime = minutes .. " minute " .. seconds .. " secondes"
    else
        displayTime = minutes .. " minutes " .. seconds .. " secondes"
    end
end

function boolCountjailTime(timeGet)
    -- Convertir le temps en secondes pour plus de précision
    local totalSeconds = timeGet
    minutes = math.floor(totalSeconds / 60)
    seconds = totalSeconds % 60
    updateTimeDisplay()
    
    CreateThread(function()
        while jail.open do
            Wait(1000) -- Attendre 1 seconde
            if totalSeconds <= 0 then
                jail.open = false
            else
                totalSeconds = totalSeconds - 1
                minutes = math.floor(totalSeconds / 60)
                seconds = totalSeconds % 60
                updateTimeDisplay()
            end
            
            -- Mettre à jour le serveur chaque minute seulement
            if seconds == 0 then
                TriggerServerEvent('Yvelt:updatejailTime')
            end
        end
    end)
end

RegisterNetEvent('Yvelt:finishjailTime')
AddEventHandler('Yvelt:finishjailTime', function(table)
    jail.open = false
    RageUI.CloseAll()
    Wait(100)
    SetEntityCoords(PlayerPedId(), YveltConfig.PrisonExit)
    if YveltConfig.GiveVehicleOnExit then
        YveltHelper:spawnVehicle(YveltConfig.GiveVehicleOnExit)
    end
end)

function openjailMenu(table)
    jail.open = false
    RageUI.CloseAll()
    Wait(100)
    SetEntityCoords(PlayerPedId(), YveltConfig.PrisonPos)
    boolCountjailTime(tonumber(table.time))
    jail.open = true
    RageUI.Visible(mainMenujail, true)
    CreateThread(function()
        while jail.open do
            Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), YveltConfig.PrisonPos, true) > YveltConfig.Distance then
                SetEntityCoords(PlayerPedId(), YveltConfig.PrisonPos)
            end
            RageUI.IsVisible(mainMenujail, function()
                RageUI.Separator('↓ Vous êtes actellement en prison ↓')
                RageUI.Button(("Temps restant :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = displayTime}, true, {})
                RageUI.Button(("Jail par :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = ''..table.staffName..''}, true, {})
                RageUI.Button(("Raison du jail :"), 'Pour contester une sanction, merci de se rendre dans le salon vocal besoin d\'aide sur le Discord du serveur', {RightLabel = ''..table.raison..''}, true, {})
                RageUI.Separator('↓ Pour contester une sanction ↓')
            end)
        end
    end)
end