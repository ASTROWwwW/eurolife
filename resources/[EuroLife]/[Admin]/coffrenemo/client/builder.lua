local isBuilderOpen = false
local builderData = {}
local isMainMenuOpen = false
local allCoffres = {}



function OpenMainCoffreMenu()
    if isMainMenuOpen then return end
    isMainMenuOpen = true

    local mainMenu = RageUI.CreateMenu("Gestion Coffres", "Builder Menu")
    local createMenu = RageUI.CreateSubMenu(mainMenu, "Créer un Coffre", "Nouveau Coffre")
    local editMenu = RageUI.CreateSubMenu(mainMenu, "Modifier un Coffre", "Coffres existants")

    RageUI.Visible(mainMenu, true)

    CreateThread(function()
        while isMainMenuOpen do
            Wait(1)

            RageUI.IsVisible(mainMenu, function()
                RageUI.Button("Créer un Coffre", nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        OpenCoffreBuilderMenu()
                    end
                })

                RageUI.Button("Modifier un Coffre", nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        ESX.TriggerServerCallback('eurolife_coffre:getAllCoffres', function(coffres)
                            allCoffres = coffres
                        end)
                    end
                }, editMenu)
            end)

            RageUI.IsVisible(editMenu, function()
                if #allCoffres == 0 then
                    RageUI.Separator("~r~Aucun coffre disponible.")
                else
                    for _, coffre in pairs(allCoffres) do
                        RageUI.Button(coffre.label.." ["..coffre.job.."]", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                OpenEditCoffreMenu(coffre)
                            end
                        })
                    end
                end
            end)
            if not RageUI.Visible(mainMenu) and not RageUI.Visible(editMenu) then
                isMainMenuOpen = false
            end

        end
    end)
end





function OpenCoffreBuilderMenu(isEditing)
    if isBuilderOpen then return end
    isBuilderOpen = true
    isMainMenuOpen = false

    if not isEditing then
        ResetBuilder()
    end

    local mainMenu = RageUI.CreateMenu(isEditing and "Éditer Coffre" or "Création Coffre", "Builder Menu")
    RageUI.Visible(mainMenu, true)


    CreateThread(function()
        while isBuilderOpen do
            Wait(1)
            if builderData.position then
                DrawMarker(
                    builderData.marker.type,
                    builderData.position.x, builderData.position.y, builderData.position.z - builderData.marker.height,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    builderData.marker.size, builderData.marker.size, 1.0,
                    builderData.marker.color.r, builderData.marker.color.g, builderData.marker.color.b,
                    builderData.marker.opacity, false, true, 2, nil, nil, false
                )
            end
            
            RageUI.IsVisible(mainMenu, function()

                RageUI.Separator("↓ Paramètres du Coffre ↓")
                RageUI.Line()

                RageUI.Button("Nom du Coffre", nil, {RightLabel = builderData.label ~= "" and builderData.label or "→"}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Nom du coffre", "", 30)
                        if input then
                            builderData.label = input
                        end
                    end
                })

                RageUI.Button("Job Associé", nil, {RightLabel = builderData.job ~= "" and builderData.job or "→"}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Nom du job", "", 30)
                        if input then
                            builderData.job = input
                        end
                    end
                })

                RageUI.Checkbox("Utiliser un mot de passe ?", nil, builderData.usePassword, {}, {
                    onChecked = function()
                        builderData.usePassword = true
                    end,
                    onUnChecked = function()
                        builderData.usePassword = false
                        builderData.password = ""
                    end
                })

                if builderData.usePassword then
                    RageUI.Button("Définir le Mot de passe", nil, {RightLabel = builderData.password ~= "" and builderData.password or "→"}, true, {
                        onSelected = function()
                            local input = KeyboardInput("Mot de passe", "", Config.MaxPasswordLength)
                            if input and #input >= Config.MinPasswordLength then
                                builderData.password = input
                            else
                                ESX.ShowNotification("~r~Mot de passe invalide.")
                            end
                        end
                    })
                end

                RageUI.Button("Poids Maximum", nil, {RightLabel = tostring(builderData.maxWeight).." kg"}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Poids max", tostring(Config.DefaultMaxWeight), 3)
                        input = tonumber(input)
                        if input and input > 0 then
                            builderData.maxWeight = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })

                RageUI.Button("Position du Coffre", nil, {RightLabel = builderData.position and string.format("%.2f | %.2f | %.2f", builderData.position.x, builderData.position.y, builderData.position.z) or "→"}, true, {
                    onSelected = function()
                        local coords = GetEntityCoords(PlayerPedId())
                        builderData.position = {x = coords.x, y = coords.y, z = coords.z}
                        ESX.ShowNotification("~g~Position enregistrée.")
                    end
                })

                RageUI.Separator("↓ Paramètres du Marker ↓")
                RageUI.Line()

                RageUI.Button("Type du Marker", nil, {RightLabel = tostring(builderData.marker.type)}, true, {
                    onSelected = function()
                        local input = KeyboardInput("ID Type Marker", tostring(builderData.marker.type), 3)
                        input = tonumber(input)
                        if input and input >= 0 then
                            builderData.marker.type = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })

                RageUI.Button("Taille du Marker", nil, {RightLabel = tostring(builderData.marker.size).." m"}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Taille Marker", tostring(builderData.marker.size), 3)
                        input = tonumber(input)
                        if input and input > 0 then
                            builderData.marker.size = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })

                RageUI.Button("Hauteur du Marker", nil, {RightLabel = tostring(builderData.marker.height).." m"}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Hauteur Marker", tostring(builderData.marker.height), 3)
                        input = tonumber(input)
                        if input and input > 0 then
                            builderData.marker.height = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })
                
                RageUI.Button("Opacité du Marker", nil, {RightLabel = tostring(builderData.marker.opacity)}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Opacité Marker (0-255)", tostring(builderData.marker.opacity), 3)
                        input = tonumber(input)
                        if input and input >= 0 and input <= 255 then
                            builderData.marker.opacity = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })
                
                RageUI.Button("Couleur Rouge", nil, {RightLabel = tostring(builderData.marker.color.r)}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Rouge (0-255)", tostring(builderData.marker.color.r), 3)
                        input = tonumber(input)
                        if input and input >= 0 and input <= 255 then
                            builderData.marker.color.r = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })

                RageUI.Button("Couleur Vert", nil, {RightLabel = tostring(builderData.marker.color.g)}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Vert (0-255)", tostring(builderData.marker.color.g), 3)
                        input = tonumber(input)
                        if input and input >= 0 and input <= 255 then
                            builderData.marker.color.g = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })

                RageUI.Button("Couleur Bleu", nil, {RightLabel = tostring(builderData.marker.color.b)}, true, {
                    onSelected = function()
                        local input = KeyboardInput("Bleu (0-255)", tostring(builderData.marker.color.b), 3)
                        input = tonumber(input)
                        if input and input >= 0 and input <= 255 then
                            builderData.marker.color.b = input
                        else
                            ESX.ShowNotification("~r~Valeur invalide.")
                        end
                    end
                })

                RageUI.Separator("")

                RageUI.Button(isEditing and "~g~Valider les Modifications" or "~g~Valider et Créer le Coffre", nil, {RightBadge = RageUI.BadgeStyle.Tick}, builderData.label ~= "" and builderData.job ~= "" and builderData.position ~= nil, {
                    onSelected = function()
                        TriggerServerEvent("eurolife_coffre:createCoffre", builderData)
                        ResetBuilder()
                        RageUI.CloseAll()
                        isBuilderOpen = false
                    end
                })
                
                if not builderData.id then
                RageUI.Button("~r~Annuler", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                    onSelected = function()
                        ResetBuilder()
                        RageUI.CloseAll()
                        isBuilderOpen = false
                    end
                })
                end 
                if builderData.id then 
                    RageUI.Button("~r~Supprimer ce Coffre", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                        onSelected = function()
                            local confirm = KeyboardInput("Écris Y pour confirmer", "", 1)
                            if confirm and confirm:lower() == "y" then
                                ESX.TriggerServerCallback('eurolife_coffre:deleteCoffre', function(success)
                                    if success then
                                        ESX.ShowNotification("~g~Coffre supprimé avec succès.")
                                        ResetBuilder()
                                        RageUI.CloseAll()
                                        isBuilderOpen = false
                                    else
                                        ESX.ShowNotification("~r~Erreur lors de la suppression.")
                                    end
                                end, builderData.id)
                            else
                                ESX.ShowNotification("~r~Suppression annulée.")
                            end
                        end
                    })
                    
                end
                
            end)
            if not RageUI.Visible(mainMenu) then
                isBuilderOpen = false
                ResetBuilder()
            end
            
        end
    end)
end

function ResetBuilder()
    builderData = {
        label = "",
        job = "",
        usePassword = false,
        password = "",
        position = nil,
        maxWeight = Config.DefaultMaxWeight,
        marker = {
            type = 1,
            size = 1.0,
            height = 1.0,
            opacity = 150,
            color = {r = 0, g = 150, b = 255}
        }
        
    }
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

function OpenEditCoffreMenu(coffre)
    local markerColor = coffre.marker_color
if type(markerColor) == "string" then
    local decoded = json.decode(markerColor)
    if decoded and decoded.r and decoded.g and decoded.b then
        markerColor = decoded
    else
        markerColor = {r=0, g=150, b=255}
    end
elseif type(markerColor) ~= "table" then
    markerColor = {r=0, g=150, b=255}
end

    builderData = {
        id = coffre.id,
        label = coffre.label,
        job = coffre.job,
        usePassword = coffre.password ~= "",
        password = coffre.password or "",
        position = json.decode(coffre.position),
        maxWeight = coffre.max_weight,
        marker = {
            type = tonumber(coffre.marker_type) or 1,
            size = tonumber(string.format("%.1f", coffre.marker_size)) or 1.0,
            height = tonumber(string.format("%.1f", coffre.marker_height)) or 1.0,
            opacity = tonumber(coffre.marker_opacity) or 150,
            color = markerColor
        }
        
    }
    OpenCoffreBuilderMenu(true) -- true = mode édition
end


RegisterCommand(Config.AdminCommand, function()
    ESX.TriggerServerCallback('eurolife_coffre:checkAdmin', function(isAdmin)
        if isAdmin then
            OpenMainCoffreMenu()
        else
            ESX.ShowNotification("~r~Tu n'as pas la permission.")
        end
    end)
end, false)

