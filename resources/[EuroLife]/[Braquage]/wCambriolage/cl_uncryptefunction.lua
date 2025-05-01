RegisterNetEvent('createBlipForFailure')
AddEventHandler('createBlipForFailure', function(coords)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161) 
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Activité suspecte")
    EndTextCommandSetBlipName(blip)

    SetTimeout(ConfigWCambriolage.TempsRemoveBlipsAlerte, function()
        RemoveBlip(blip)
    end)
end)

local items = {}

OpenMenuVente = function()

    local open3 = false 
    local OpenMenuVente = RageUI.CreateMenu("Cambriolage", "Que voulez-vous faire ?", 0, 80)
    local OpenMenuVente2 = RageUI.CreateSubMenu(OpenMenuVente, "Builder", "Que voulez-vous faire ?")


    OpenMenuVente.Closed = function()
        open3 = false 
    end

    if open3 then 
        open3 = false 
        RageUI.Visible(OpenMenuVente, false)
        return
    else 
        open3 = true 
        RageUI.Visible(OpenMenuVente, true)

        CreateThread(function()
            while open3 do 
                RageUI.IsVisible(OpenMenuVente, function()

                    RageUI.Line()

                
                    RageUI.Button("~o~→ ~s~Vendre", nil, {RightLabel = "~o~→→"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('buildermenu:CheckItems', function(result)
                                items = result
                            end)
                        end
                    },OpenMenuVente2)
                    

                end)

                RageUI.IsVisible(OpenMenuVente2, function()

                    RageUI.Line()

                    for _, item in ipairs(items) do
                        RageUI.Button(string.format("~o~→ ~s~%s", item.Label), nil, {RightLabel = string.format("~o~%d~s~ ($%d)", item.Count, item.Prix)}, true, {
                            onSelected = function()
                                Coords = GetEntityCoords(PlayerPedId(), false)
                                TriggerServerEvent('buildermenu:SellItem', item.Name, item.Count, item.Prix, Coords)
                                refreshDonner()
                            end
                        })
                    end


                end)

                Wait(0)
            end
        end)
    end
end

refreshDonner = function()
    ESX.TriggerServerCallback('buildermenu:CheckItems', function(result)
        items = result
    end)
end