local freecamActive = false

function MenuMain()
    RageUI.Checkbox("Activer le mode modération", nil, adminStaffmode, {}, {
        onSelected = function(Index)
            adminStaffmode = Index
        end,
        onChecked = function()
            -- functionBoolRefresh()
            YveltStaffMode = true
            TriggerServerEvent('YveltAdmin:ChangeStaffMode', 'on')
            YveltHelper:onStaffModeON()
        end,
        onUnChecked = function()
            YveltHelper:onStaffModeOFF()
            if noclipActive then
                ExecuteCommand('YveltNoclip')
            end
            YveltStaffMode = false
            isNameShown = false
            TriggerServerEvent('YveltAdmin:ChangeStaffMode', 'off')
            adminPseudo = false
            boolPseudo = false
            for i, v in pairs(YVELT.GamerTags) do
                RemoveMpGamerTag(v.tags)
            end
            YVELT.GamerTags = {};
            SetEntityVisible(PlayerPedId(), true)
            boolHud = false
            boolInvincible = false
            boolSuperjump = false
            boolCoords = false
            boolSupersprint = false
        end
    })
    if playersList ~= nil and playersStaffsList ~= nil then
        RageUI.Separator('Joueur(s) en ligne : '..YveltConfig.ColorMenu..''..playersCount..' ~s~| Staff(s) en ligne : '..YveltConfig.ColorMenu..''..staffsCount)
    else
        RageUI.Separator('Joueur(s) en ligne : '..YveltConfig.ColorMenu..'/ ~s~| Staff(s) en ligne : '..YveltConfig.ColorMenu..'/')
    end
    if adminStaffmode then
        Separator('Gestion administratif')
        if YveltHelper:getAcces(player, 'subReports') then
            RageUI.Button('Liste des reports '..c..'('..ReportsInfos.Waiting..')', nil, {RightLabel = YveltConfig.RightLabel}, true, {}, adminReports)
        else
            RageUI.Button('Liste des reports '..c..'('..ReportsInfos.Waiting..')', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subPlayers') then
            RageUI.Button('Liste des joueurs', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    -- YveltAdmin:retrievePlayers OLD
                end
            }, adminPlayers)
        else
            RageUI.Button('Liste des joueurs', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subPersonnel') then
            RageUI.Button('Gestion personnel', nil, { RightLabel = YveltConfig.RightLabel }, true, {}, adminPerso)
        else
            RageUI.Button('Gestion personnel', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subFreecam') then
            RageUI.Button('Activer/Désactiver Freecam', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    -- Enregistrement de la commande /freecam
                    RegisterCommand('freecam', function()
                        if not freecamActive then
                            -- Activer la caméra libre
                            TriggerEvent('freecam:activate')
                            ESX.ShowNotification('Freecam activée')
                            freecamActive = true
                        else
                            -- Désactiver la caméra libre
                            TriggerEvent('freecam:deactivate')
                            ESX.ShowNotification('Freecam désactivée')
                            freecamActive = false
                        end
                    end, false)
        
                    -- Exécuter la commande /freecam
                    ExecuteCommand('freecam')
                end
            })
        else
            RageUI.Button('Activer/Désactiver Freecam', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subVehicle') then
            RageUI.Button('Gestion vehicule(s)', nil, { RightLabel = YveltConfig.RightLabel }, true, {}, adminVehicle)
        else
            RageUI.Button('Gestion vehicule(s)', nil, {}, false, {})
        end
        
        if player.rank == 'owner' then
            RageUI.Button('Gérer les ranks', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    Callback.triggerServerCallback('YveltAdmin:getRanksList', function(ranks)
                        RanksList = ranks
                    end)
                end
            }, adminRanks)
        else
            RageUI.Button('Gérer les ranks', nil, {}, false, {})
        end
    end
end

Citizen.CreateThread(function()
    RegisterCommand('freecam', function()
        if not freecamActive then
            -- Activer la caméra libre
            TriggerEvent('freecam:activate')
            ESX.ShowNotification('Freecam activée')
            freecamActive = true
        else
            -- Désactiver la caméra libre
            TriggerEvent('freecam:deactivate')
            ESX.ShowNotification('Freecam désactivée')
            freecamActive = false
        end
    end, false)

    TriggerEvent('chat:addSuggestion', '/freecam', 'Activer/désactiver la caméra libre')
end)

-----------------------------------------------------------------
                  -------- COMMANDES ---------
                  -------- -------------------
-----------------------------------------------------------------
---
--------------------------HRP-----------------------------------

-- Ajout d'une suggestion d'aide pour la commande /hrp
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/hrp', 'Envoyer un message hors roleplay visible par les joueurs dans un rayon de 5 mètres', {
        { name="message", help="Le message HRP que vous souhaitez envoyer" }
    })
end)


-- Enregistrement de la commande /hrp
RegisterCommand('hrp', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    if message == '' then
        ESX.ShowNotification('Veuillez entrer un message après la commande /hrp')
        return
    end
    
    -- Déclenche un événement pour traiter le message HRP
    TriggerServerEvent('hrp_command:sendHRPMessage', message)
end, false)

-- Réception et affichage du message HRP pour les joueurs proches
RegisterNetEvent('hrp_command:receiveHRPMessage')
AddEventHandler('hrp_command:receiveHRPMessage', function(playerId, playerName, message)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    
    -- Vérifie si le joueur est dans un rayon de 5 mètres
    if targetPed ~= 0 then
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        
        if distance <= 5.0 then
            -- Affiche le message en gris dans le chat
            TriggerEvent('chat:addMessage', {
                color = {175, 175, 175}, -- Couleur grise
                multiline = true,
                args = {'[HRP] ' .. playerName, message}
            })
        end
    end
end)

--------------------------ADMIN-----------------------------------
---

-- Ajout d'une suggestion d'aide pour la commande /admin
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/admin', 'Envoyer un message administratif visible par les joueurs dans un rayon de 8 mètres', {
        { name="message", help="Le message administratif que vous souhaitez envoyer" }
    })
end)

-- Enregistrement de la commande /admin
RegisterCommand('admin', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    if message == '' then
        ESX.ShowNotification('Veuillez entrer un message après la commande /admin')
        return
    end
    
    -- Vérifie si le joueur est admin (vous pouvez ajuster cette condition selon votre système de permissions)
    if YveltStaffMode then
        -- Déclenche un événement pour traiter le message Admin
        TriggerServerEvent('admin_command:sendAdminMessage', message)
    else
        ESX.ShowNotification('Vous devez être en mode modération pour utiliser cette commande')
    end
end, false)

-- Réception et affichage du message Admin pour les joueurs proches
RegisterNetEvent('admin_command:receiveAdminMessage')
AddEventHandler('admin_command:receiveAdminMessage', function(playerId, playerName, message)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    
    -- Vérifie si le joueur est dans un rayon de 8 mètres
    if targetPed ~= 0 then
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        
        if distance <= 8.0 then
            -- Affiche le message en rouge dans le chat
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0}, -- Couleur rouge
                multiline = true,
                args = {'[ADMIN] ' .. playerName, message}
            })
        end
    end
end)

--------------------------STAFF----------------------------------
---
-- Ajout d'une suggestion d'aide pour la commande /mstaff
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/mstaff', 'Envoyer un message visible uniquement par les staffs en service', {
        { name="message", help="Le message que vous souhaitez envoyer aux autres staffs" }
    })
end)

-- Enregistrement de la commande /mstaff
RegisterCommand('mstaff', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    if message == '' then
        ESX.ShowNotification('Veuillez entrer un message après la commande /mstaff')
        return
    end
    
    -- Vérifie si le joueur est en mode staff
    if YveltStaffMode then
        -- Déclenche un événement pour traiter le message staff
        TriggerServerEvent('staff_command:sendStaffMessage', message)
    else
        ESX.ShowNotification('Vous devez être en mode modération pour utiliser cette commande')
    end
end, false)

-- Réception et affichage du message staff pour les membres du staff
RegisterNetEvent('staff_command:receiveStaffMessage')
AddEventHandler('staff_command:receiveStaffMessage', function(playerId, playerName, message)
    -- Vérifie si le joueur est en mode staff avant d'afficher le message
    if YveltStaffMode then
        -- Affiche le message avec une couleur et mise en forme spéciales
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(75, 0, 130, 0.8); border-radius: 4px;"><i class="fas fa-shield-alt"></i> <b>STAFF - <span style="color: yellow;">{0}</span></b>: {1}</div>',
            args = {playerName, message}
        })
        
        -- Joue un son de notification pour alerter les staffs
        PlaySoundFrontend(-1, "MP_AWARD", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
end)

------------------------------ REMOVE ARGENT----------------------------------------

-- Ajout d'une suggestion d'aide pour la commande /removemoney
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/removemoney', 'Retirer de l\'argent à un joueur', {
        { name="id", help="L'ID du joueur" },
        { name="type", help="Type d'argent (money, bank, black)" },
        { name="montant", help="Montant à retirer" }
    })
end)

-- Enregistrement de la commande /removemoney
RegisterCommand('removemoney', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local moneyType = args[2]
    local amount = tonumber(args[3])

    if not targetId or not moneyType or not amount then
        ESX.ShowNotification('Usage: /removemoney [id] [type: money/bank/black] [montant]')
        return
    end

    if amount <= 0 then
        ESX.ShowNotification('Le montant doit être supérieur à 0')
        return
    end

    -- Vérifie si le joueur est en mode staff
    if YveltStaffMode then
        -- Déclenche un événement serveur pour retirer l'argent
        TriggerServerEvent('admin_command:removeMoney', targetId, moneyType, amount)
    else
        ESX.ShowNotification('Vous devez être en mode modération pour utiliser cette commande')
    end
end, false)

------------------------------ PED ----------------------------------------


-- Ajout d'une suggestion d'aide pour la commande /setped
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/setped', 'Changer votre modèle ou celui d\'un joueur en PED', {
        { name="id", help="ID du joueur (optionnel)" },
        { name="model", help="Modèle du PED (ex: a_m_y_skater_01)" }
    })
end)

-- Enregistrement de la commande /setped
RegisterCommand('setped', function(source, args, rawCommand)
    local targetId, modelName
    
    -- Vérifie si le premier argument est un ID ou un modèle
    if #args >= 2 and tonumber(args[1]) then
        targetId = tonumber(args[1])
        modelName = args[2]
    else
        targetId = nil
        modelName = args[1]
    end
    
    if not modelName then
        ESX.ShowNotification('Usage: /setped [id] [model] ou /setped [model]')
        return
    end
    
    -- Vérifie si le joueur est en mode staff
    if YveltStaffMode then
        if targetId then
            -- Changer le modèle d'un autre joueur
            TriggerServerEvent('admin_command:setPlayerPed', targetId, modelName)
            ESX.ShowNotification('Changement du modèle du joueur ~y~' .. targetId .. '~s~ en ~b~' .. modelName)
        else
            -- Changer son propre modèle
            ChangerPedJoueur(modelName)
        end
    else
        ESX.ShowNotification('Vous devez être en mode modération pour utiliser cette commande')
    end
end, false)

-- Fonction pour changer le modèle du joueur
function ChangerPedJoueur(modelName)
    if not modelName then return end
    
    -- Chargement du modèle
    local modelHash = GetHashKey(modelName)
    RequestModel(modelHash)
    
    -- Attente du chargement (avec timeout)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 30 do
        timeout = timeout + 1
        Citizen.Wait(100)
        RequestModel(modelHash)
    end
    
    if HasModelLoaded(modelHash) then
        -- Sauvegarde des armes actuelles
        local weapons = {}
        for i=1, #ESX.GetWeaponList() do
            local weaponName = ESX.GetWeaponList()[i].name
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(weaponName), false) then
                local ammo = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(weaponName))
                table.insert(weapons, {
                    name = weaponName,
                    ammo = ammo
                })
            end
        end
        
        -- Changement du modèle
        SetPlayerModel(PlayerId(), modelHash)
        SetModelAsNoLongerNeeded(modelHash)
        
        -- Restauration des armes
        for i=1, #weapons, 1 do
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weapons[i].name), weapons[i].ammo, false, false)
        end
        
        ESX.ShowNotification('Vous êtes maintenant un ~g~' .. modelName)
    else
        ESX.ShowNotification('~r~Le modèle ' .. modelName .. ' n\'existe pas!')
    end
end

-- Recevoir l'événement pour changer de modèle
RegisterNetEvent('admin_command:setClientPed')
AddEventHandler('admin_command:setClientPed', function(modelName)
    ChangerPedJoueur(modelName)
end)

-- Commande pour restaurer le personnage original
RegisterCommand('resetped', function(source, args, rawCommand)
    if YveltStaffMode then
        local targetId = tonumber(args[1])
        
        if targetId then
            -- Restaurer le modèle d'un autre joueur
            TriggerServerEvent('admin_command:resetPlayerPed', targetId)
            ESX.ShowNotification('Restauration de l\'apparence du joueur ~y~' .. targetId)
        else
            -- Restaurer son propre modèle
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                local model = nil
                
                if skin.sex == 0 then
                    model = GetHashKey("mp_m_freemode_01")
                else
                    model = GetHashKey("mp_f_freemode_01")
                end
                
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(1)
                end
                
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
                
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                
                ESX.ShowNotification('Votre apparence a été restaurée')
            end)
        end
    else
        ESX.ShowNotification('Vous devez être en mode modération pour utiliser cette commande')
    end
end, false)

-- Ajout d'une suggestion pour la commande resetped
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/resetped', 'Restaurer l\'apparence originale', {
    })
end)