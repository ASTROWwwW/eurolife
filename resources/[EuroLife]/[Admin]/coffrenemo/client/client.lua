local ActiveCoffres = {}
local playerJob = nil
RegisterNetEvent('esx:setJob', function(job)
    playerJob = job.name
end)

-- Charger tous les coffres
RegisterNetEvent("eurolife_coffre:loadCoffres", function(coffres)
    ActiveCoffres = {}
    for _, v in pairs(coffres) do
        -- 🔥 Force clean marker_color
        local markerColor = v.marker_color
        if type(markerColor) == "string" then
            local decoded = json.decode(markerColor)
            if decoded and decoded.r and decoded.g and decoded.b then
                markerColor = decoded
            else
                markerColor = {r=0, g=150, b=255} -- fallback safe
            end
        end

        local newCoffre = CoffreManager:Create({
            id = v.id,
            label = v.label,
            job = v.job,
            password = v.password,
            position = type(v.position) == "table" and vector3(v.position.x, v.position.y, v.position.z) or v.position,
            max_weight = v.max_weight,
            markerType = tonumber(v.marker_type) or 1,
            markerSize = tonumber(string.format("%.1f", v.marker_size)) or 1.0,
            markerHeight = tonumber(string.format("%.1f", v.marker_height)) or 1.0,
            markerOpacity = tonumber(v.marker_opacity) or 150,
            markerColor = markerColor -- ici
        })

        table.insert(ActiveCoffres, newCoffre)
    end
end)


-- Request coffres au démarrage de la ressource
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    TriggerServerEvent('eurolife_coffre:requestCoffres')
end)



CreateThread(function()
    while true do
        local waitTime = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        playerJob = ESX.GetPlayerData().job and ESX.GetPlayerData().job.name

        for _, coffre in pairs(ActiveCoffres) do
            if playerJob and playerJob == coffre.job then
                local distance = #(playerCoords - coffre.position)

                if distance < 20.0 then
                    waitTime = 1

                    -- Draw Marker
                    DrawMarker(
                        coffre.markerType,
                        coffre.position.x, coffre.position.y, coffre.position.z - coffre.markerHeight,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        coffre.markerSize, coffre.markerSize, 1.0,
                        coffre.markerColor.r, coffre.markerColor.g, coffre.markerColor.b,
                        coffre.markerOpacity, false, true, 2, nil, nil, false
                    )

                    -- Interaction
                    if distance < 1.5 then
                        ESX.ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir ~y~"..coffre.label.."")

                        if IsControlJustReleased(0, 38) then -- E
                            coffre:Open()
                        end
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)


