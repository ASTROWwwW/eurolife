Reports = {}
ReportsSessionId = 0
ReportsInfos = {
    Active = 0,
    Taked = 0,
    Finish = 0,
}

Callback.registerServerCallback('Yvelt:getReportList', function(source)
    return {Reports}
end)

RegisterCommand('report', function(source, args)
    local _src = source 
    local argument = table.concat(args, ' ', 1)
    local xPlayer = YveltHelper:getPlayerFromId(_src)

    if _src == 0 then
        print(' ')
        print('Voici l\'état des reports actuellement :')
        print('Reports actif : '..ReportsInfos.Active)
        print('Reports en attente : '..ReportsInfos.Active - ReportsInfos.Taked.. '')
        print('Reports pris en charge : '..ReportsInfos.Taked)
        print('Reports terminé : '..ReportsInfos.Finish)
        print(' ')
    else
        if Reports[source] then
            YveltHelper:serverNotification(xPlayer.source, '~r~Vous avez déjà un report actif')
            return
        else
            if argument == '' then
                if YveltConfig.ReportRaison then
                    YveltHelper:serverNotification(xPlayer.source, '~r~Vous devez indiquer une raison')
                    return
                else
                    argument = 'Aucune raison fournis'
                end
            end
            ReportsSessionId = ReportsSessionId + 1 
            local players = {}
            local xPlayers = ESX.GetPlayers()
            
            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                Reports[source] = {
                    date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes',
                    heure = os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes',
                    uid = UID:getUIDfromID(_src),
                    source = _src,
                    name = GetPlayerName(_src),
                    rank = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    job1 = YveltHelper:getJob(xPlayer.source).name,
                    job2 = YveltHelper:getJob2(xPlayer.source).name,
                    rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                    rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                    rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                    raison = argument,
                    state = 'waiting',
                    takedBy = '?',
                    id = ReportsSessionId,
                }
            else
                Reports[source] = {
                    date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes',
                    heure = os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes',
                    uid = UID:getUIDfromID(_src),
                    source = _src,
                    name = GetPlayerName(_src),
                    rank = 'Joueur',
                    job1 = YveltHelper:getJob(xPlayer.source).name,
                    job2 = YveltHelper:getJob2(xPlayer.source).name,
                    rankName = 'Joueur',
                    rankLabel = '[ Joueur ]',
                    rankColor = '~s~',
                    rankPower = 0,
                    raison = argument,
                    state = 'waiting',
                    takedBy = '?',
                    id = ReportsSessionId,
                }
            end

            local embed = {
                title = 'Création d\'un report',
                description = 'Le joueur `'..GetPlayerName(_src)..'` (ID : `'.._src..'` | UID : `'..UID:getUIDfromID(_src)..'`) vient de faire un report (Report n°`'..ReportsSessionId..'`)\nRaison du report : `'..argument..'`',
                color = 16777215,
                webhook = 'report',
            }

            YveltHelper:sendWebhook(embed)

            YveltHelper:serverNotification(xPlayer.source, '~g~Votre report a été envoyé !')

            for i=1, #xPlayers, 1 do
                local xPlayerS = YveltHelper:getPlayerFromId(xPlayers[i])
                if xPlayerS then
                    if PlayersRanks[YveltHelper:getIdentifier(xPlayerS.source)] then
                        YveltHelper:serverNotification(xPlayerS.source, '~g~Un report vient d\'arriver ('..ReportsSessionId..') !')
                        TriggerClientEvent('Yvelt:ReceiveReportsList', xPlayerS.source, Reports)
                    end
                end
            end
        end
    end
end)

RegisterServerEvent('Yvelt:updateReport')
AddEventHandler('Yvelt:updateReport', function(action, s)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then

        local players = {}
        local xPlayers = ESX.GetPlayers()

        if action == 'taked' then
            local embed = {
                title = 'Prise en charge d\'un report',
                description = 'Le joueur `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) vient de prendre en charge un report (Report n°`'..s.id..'`)\nRaison du report : `'..s.raison..'`',
                color = 4838724,
                webhook = 'report',
            }

            YveltHelper:sendWebhook(embed)

            Reports[s.source].state = 'taked'
            Reports[s.source].takedBy = GetPlayerName(source)

            YveltHelper:serverNotification(s.source, '~g~Report pris en charge par '..GetPlayerName(source)..' !')
            for i=1, #xPlayers, 1 do
                local xPlayerS = YveltHelper:getPlayerFromId(xPlayers[i])
                if xPlayerS then
                    if PlayersRanks[YveltHelper:getIdentifier(xPlayerS.source)] then
                        YveltHelper:serverNotification(xPlayerS.source, '~g~Le staff '..GetPlayerName(source)..' a pris le report n°'..s.id..' en charge !')
                        TriggerClientEvent('Yvelt:ReceiveReportsList', xPlayerS.source, Reports)
                    end
                end
            end
        elseif action == 'finish' then
            local embed = {
                title = 'Fermeture d\'un report',
                description = 'Le joueur `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) vient de fermer un report (Report n°`'..s.id..'`)\nRaison du report : `'..s.raison..'`',
                color = 13976644,
                webhook = 'report',
            }

            YveltHelper:sendWebhook(embed)

            local id = s.id
            Reports[s.source] = nil
            YveltHelper:serverNotification(s.source, '~g~Report cloturé par '..GetPlayerName(source)..' !')
            antiCheatAvis['id:'..s.source] = YveltHelper:getIdentifier(xPlayer.source)

            -- print('YveltHelper:getIdentifier(xPlayer.source)', YveltHelper:getIdentifier(xPlayer.source))
            -- print('antiCheatAvis[\'id:\'..source] : ', antiCheatAvis['id:'..source])
            -- print('xPlayer.source', xPlayer.source)

            TriggerClientEvent('Yvelt:LaisseUnAvis', s.source, GetPlayerName(source))
            for i=1, #xPlayers, 1 do
                local xPlayerS = YveltHelper:getPlayerFromId(xPlayers[i])
                if xPlayerS then
                    if PlayersRanks[YveltHelper:getIdentifier(xPlayerS.source)] then
                        YveltHelper:serverNotification(xPlayerS.source, '~g~Le staff '..GetPlayerName(source)..' a cloturé le report n°'..id..'')
                        TriggerClientEvent('Yvelt:ReceiveReportsList', xPlayerS.source, Reports)
                    end
                end
            end
        else
            DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:updateReport\")")
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:updateReport\")")
    end
end)

local playerAdminChats = {}

-- Quand un admin prend un ticket en charge
RegisterServerEvent('Yvelt:updateReport')
AddEventHandler('Yvelt:updateReport', function(state, report)
    -- Code existant...
    
    -- Si le report est pris en charge, associer le joueur à l'admin
    if state == 'taked' then
        local adminSource = source
        local playerSource = report.source
        playerAdminChats[playerSource] = adminSource
    elseif state == 'finish' then
        -- Quand le ticket est clôturé, supprimer l'association
        local playerSource = report.source
        playerAdminChats[playerSource] = nil
    end
end)

-- Quand l'admin envoie un message au joueur
RegisterServerEvent('Yvelt:AdminMessageToPlayer')
AddEventHandler('Yvelt:AdminMessageToPlayer', function(playerSource, message)
    local adminSource = source
    -- Stocker l'association joueur-admin pour les réponses
    playerAdminChats[playerSource] = adminSource
    
    -- Envoyer le message au joueur avec template rouge et "Administration"
    TriggerClientEvent('chat:addMessage', playerSource, {
        template = '<div style="padding: 0.5vw 0.7vw; margin: 0.4vw 0.4vw 0.4vw 0vw; background-color: rgba(255, 0, 0, 0.8); border-radius: 4px;"><i class="fas fa-shield-alt"></i> <b><span style="color: white; font-size: 0.9em;">Administration</span></b>: {1}</div>',
        color = {255, 0, 0},
        multiline = true,
        args = {"Administration", message}
    })
    
    -- Notifier le joueur qu'il peut répondre
    TriggerClientEvent('Yvelt:AdminMessageReceived', playerSource, GetPlayerName(adminSource))
end)

-- Quand un joueur répond à l'admin
RegisterServerEvent('Yvelt:PlayerReplyToAdmin')
AddEventHandler('Yvelt:PlayerReplyToAdmin', function(message)
    local playerSource = source
    local adminSource = playerAdminChats[playerSource]
    
    -- Vérifier si un admin est associé à ce joueur
    if adminSource then
        -- Envoyer la réponse à l'admin
        TriggerClientEvent('Yvelt:PlayerReplyReceived', adminSource, GetPlayerName(playerSource), playerSource, message)
        
        -- Confirmation au joueur
        TriggerClientEvent('chat:addMessage', playerSource, {
            color = {0, 255, 0},
            multiline = true,
            args = {"Système", "Votre réponse a été envoyée à l'administrateur."}
        })
    else
        -- Aucun admin associé
        TriggerClientEvent('chat:addMessage', playerSource, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Système", "Vous n'avez aucun ticket en cours avec un administrateur."}
        })
    end
end)