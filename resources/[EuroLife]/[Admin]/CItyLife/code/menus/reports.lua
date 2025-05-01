function MenuReportsMain()
    if Reports then
        RageUI.Checkbox("Cacher les pris en charge", nil, adminReportsWaiting, {}, {
            onSelected = function(Index)
                adminReportsWaiting = Index
            end,
        })
        RageUI.Separator('Reports actifs : '..c..''..ReportsInfos.Waiting..' ~c~|~s~ Reports en charge : '..c..''..ReportsInfos.Taked)
        if ReportsInfos.Waiting == 0 and ReportsInfos.Taked == 0 then
            RageUI.Separator('')
            RageUI.Separator('~g~Aucun report actuellement actif !')
            RageUI.Separator('')
        else
            for k, v in pairs(Reports) do
                if adminReportsWaiting then
                    if v.state == 'waiting' then
                        RageUI.Button('~r~[ATTENTE] ~s~'..v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    elseif v.takedBy == GetPlayerName(PlayerId()) then
                        RageUI.Button(v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison.."~s~\nPris en charge par "..c..""..v.takedBy, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    end
                else
                    if v.state == 'waiting' then
                        RageUI.Button('~r~[ATTENTE] ~s~'..v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    elseif v.state == 'taked' then
                        RageUI.Button(v.id..' → '..v.name.." ~c~("..v.source..")~s~", "Crée a "..c..""..v.heure.."~s~\nAuteur du report : "..c..""..v.name.."~s~\nRaison : "..c..""..v.raison.."~s~\nPris en charge par "..c..""..v.takedBy, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                selectedReport = v
                            end		
                        }, adminReportsActions)
                    end
                end
            end
        end
    else
        RageUI.Separator('')
        RageUI.Separator('~r~Chargement des reports en cours...')
        RageUI.Separator('')
    end
end

function MenuReportsActions()
    selectedPlayer = selectedReport
    s = selectedReport
    if s then
        if s.state == 'waiting' then
            Separator('Gestion de ce report')
            RageUI.Button('Prendre en charge ce report', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    s.state = 'taked'
                    s.takedBy = GetPlayerName(PlayerId())
                    TriggerServerEvent('Yvelt:updateReport', 'taked', s)
                end		
            })
            RageUI.Button('Cloturer le report', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                onSelected = function()
                    s.state = 'finish'
                    s.takedBy = GetPlayerName(PlayerId())
                    TriggerServerEvent('Yvelt:updateReport', 'finish', s)
                    RageUI.GoBack()
                end		
            })
        elseif s.state == 'taked' then
            RageUI.Button('Cloturer le report', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                onSelected = function()
                    s.state = 'finish'
                    s.takedBy = GetPlayerName(PlayerId())
                    TriggerServerEvent('Yvelt:updateReport', 'finish', s)
                    RageUI.GoBack()
                end		
            })
            --RageUI.Separator('Pseudo : ~g~'..s.name..' ~c~('..s.source..')~s~ | ID Report : ~o~'..s.id)
            -- RageUI.List("Téléporte le joueur", YveltTeleportation, (YveltTeleportation.Index or 1), false, {}, true, {
            --     onListChange = function(Index)
            --         YveltTeleportation.Index = Index
            --     end,
            --     onSelected = function(Index)
            --         if YveltTeleportation.Index == 1 then
            --             ExecuteCommand('goto '..s.source)
            --         else
            --             ExecuteCommand('bring '..s.source)
            --         end
            --     end
            -- })
            -- RageUI.List("Action sur le joueurs", YveltAction, (YveltAction.Index or 1), false, {}, true, {
            --     onListChange = function(Index)
            --         YveltAction.Index = Index
            --     end,
            --     onSelected = function(Index)
            --         if YveltAction.Index == 1 then
            --             ExecuteCommand('revive '..s.source)
            --         elseif YveltAction.Index == 2 then
            --             ExecuteCommand('heal '..s.source)
            --         elseif YveltAction.Index == 3 then
            --             ExecuteCommand('slay '..s.source)
            --         elseif YveltAction.Index == 4 then
            --             local YveltRaison = KeyboardInput('YveltMsg', "Entrez la "..c.."raison~s~ du kick", '', 60)
            --             local YveltConfirm = KeyboardInput('YveltMsg', "Entrez \""..c.."oui~s~\" pour confirmer le kick", '', 3)
            --             if YveltConfirm == 'oui' then
            --                 if YveltRaison ~= '' or YveltRaison ~= nil then
            --                     ExecuteCommand('kick '..s.source..' '..YveltRaison)
            --                 else
            --                     ExecuteCommand('kick '..s.source.. ' Aucune raison spécifié')
            --                 end
            --             else
            --                 YveltHelper:clientNotification('~g~Vous avez annulé le kick !')
            --             end
            --         end
            --     end
            -- })
            if colorsText[s.rankColor] then
                RageUI.Separator(s.name..' ~s~'..colorsText[s.rankColor]..''..s.rankLabel)
                RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
            else
                RageUI.Separator(s.name..' ~s~[Joueur]')
                RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
            end
            RageUI.List("Action sur le joueur", YveltAction, (YveltAction.Index or 1), false, {}, true, {
                onListChange = function(Index)
                    YveltAction.Index = Index
                end,
                onSelected = function(Index)
                    if YveltAction.Index == 1 then
                        YveltHelper:revivePlayer(s.source, s.name)
                    elseif YveltAction.Index == 2 then
                        YveltHelper:healPlayer(s.source, s.name)
                    end
                end
            })
            RageUI.List("Téléportation", YveltTeleportation, (YveltTeleportation.Index or 1), false, {}, true, {
                onListChange = function(Index)
                    YveltTeleportation.Index = Index
                end,
                onSelected = function(Index)
                    if YveltTeleportation.Index == 1 then
                        TriggerServerEvent('YveltAdmin:Teleport', 'goto', s.source)
                    elseif YveltTeleportation.Index == 2 then
                        TriggerServerEvent('YveltAdmin:Teleport', 'bring', s.source)
                    else
                        TriggerServerEvent('YveltAdmin:Teleport', 'bringback', s.source)
                    end
                end
            })
            -- RageUI.Button('Téléportation(s) custom', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            --     onSelected = function()
            --         sanctionSelectedId = s.source
            --         sanctionSelectedName = s.name
            --         Callback.triggerServerCallback('YveltAdmin:getTP', function(tp)
            --             TpList = tp
            --         end)
            --     end
            -- }, adminMyTeleports2)
            RageUI.List('Téléportations rapide', YveltConfig.FastTravel, IndexFasttravel, nil, {}, true, {
                onListChange = function(Index, Item)
                    IndexFasttravel = Index;
                end,
                onSelected = function(Index, Item)
                    --SetEntityCoords(PlayerPedId(), Item.Position)
                    TriggerServerEvent('Yvelt:SetPedToCoords', GetPlayerServerId(PlayerId()), s.source, Item.Position)
                end
            })
            Separator('Options utilitaire')
            RageUI.Checkbox("Spectate le joueur", nil, spectate, {}, {
                onSelected = function(Index)
                    spectate = Index
                end,
                onChecked = function()
                    spectate = true
                    boolSpect(s.source, selectedPlayer, s.name)
                end,
                onUnChecked = function()
                    spectate = false
                end
            })
            RageUI.Button('Donner un véhicule au joueur', nil, {RightBadge = RageUI.BadgeStyle.Car}, true, {
                onSelected = function()
                    local car = KeyboardInput('YveltMsg', "Entrez le "..c.."nom~s~ du véhicule", '', 32)
                    if car and car ~= '' then
                        if not IsModelInCdimage(car) then
                            YveltHelper:clientNotification('~r~Ce véhicule n\'existe pas !')
                        else
                            TriggerServerEvent('YveltAdmin:GiveCarToPlayer', s.source, car)
                        end
                    else
                        YveltHelper:clientNotification('~r~Vous avez annulé l\'action')
                    end
                end		
            })
            RageUI.Button('Envoyer un message', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    local YveltMsg = KeyboardInput('YveltMsg', "Entrez le "..c.."message~s~ que vous souhaitez envoyer", '', 70)
                    if YveltMsg and YveltMsg ~= '' then
                        ExecuteCommand('msg '..s.source..' '..YveltMsg)
                        -- Ajouter cette ligne pour déclencher l'événement
                        TriggerServerEvent('Yvelt:AdminMessageToPlayer', s.source, YveltMsg)
                    else
                        YveltHelper:clientNotification('~r~Vous avez annulé l\'action')
                    end
                end		
            })
            
            -- Ajouter un nouveau bouton pour voir les réponses
            RageUI.Button('Voir les réponses', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    if s.replies and #s.replies > 0 then
                        for i, reply in ipairs(s.replies) do
                            YveltHelper:clientNotification('~y~'..reply.time..' - '..reply.name..': ~w~'..reply.message)
                        end
                    else
                        YveltHelper:clientNotification('~y~Aucune réponse pour ce ticket')
                    end
                end
            })
            RageUI.Button('Sanction(s) du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getSanctionsOfPlayer', function(list)
                        adminSanctions = list
                    end, s.uid)
                end		
            }, adminGestPlayerSanctions)
            Separator('Gestion avancé')
            RageUI.Button('Voir l\'inventaire du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getInventoryOfPlayer', function(list, list2)
                        adminInventory = list
                        adminInventory2 = list2
                    end, s.source)
                end		
            }, adminGestPlayerInventory)
            RageUI.Button('Donner un item au joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getItems', function(list)
                        itemsList = list
                    end)
                    -- local YveltMsg = KeyboardInput('YveltMsg', "Entrez le "..c.."nom~s~ de l", '', 70)
                    -- local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez le "..c.."message~s~ que vous souahitez envoyer", '', 70)
                    -- givePlayer(s.source, YveltMsg, YveltMsg2)
                end		
            }, adminGestPlayerItems)
            YveltHelper:CustomMenuPlayers(selectedPlayer)
            for k, v in pairs(YveltMenus.players) do
                if v.type == 'button' then
                    if perm then
                        if YveltHelper:getAcces(player, perm) then
                            if subMenu then
                                RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                                    onActive = function()
                                        v.onActive()
                                    end,
                                    onSelected = function()
                                        v.onSelected()
                                    end
                                }, subMenu)
                            else
                                RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                                    onActive = function()
                                        v.onActive()
                                    end,
                                    onSelected = function()
                                        v.onSelected()
                                    end
                                })
                            end
                        else
                            RageUI.Button(v.name, v.desc, {}, false, {})
                        end
                    else
                        if subMenu then
                            RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                                onActive = function()
                                    v.onActive()
                                end,
                                onSelected = function()
                                    v.onSelected()
                                end
                            }, subMenu)
                        else
                            RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                                onActive = function()
                                    v.onActive()
                                end,
                                onSelected = function()
                                    v.onSelected()
                                end
                            })
                        end
                    end
                elseif v.type == 'separator' then
                    RageUI.Separator(v.name)
                else
                    RageUI.Button('~r~Erreur de configuration', nil, {}, false, {})
                end
            end
        end
    else
        RageUI.Separator('')
        RageUI.Separator('~r~Vérification des informations...')
        RageUI.Separator('')
    end
    -- if nlcReportType == 'Finish' then
    --     RageUI.Button('Retour a la liste des reports', nil, {RightLabel = nlcRight}, true, {
    --         onSelected = function()
    --             nlcReportList = nil
    --             TriggerServerEvent('Yvelt:GetReportList')
    --         end		
    --     }, adminReports)
    --     RageUI.Separator('')
    --     RageUI.Separator('~r~Ce report déjà été traité.')
    --     RageUI.Separator('')
    -- end
    -- if nlcReportType == 'Waiting' then
    --     RageUI.Separator('Pseudo : ~g~'..s.name..' ~c~('..s.source..')~s~ | ID Report : ~o~'..s.id)
    --     if nlcTakedOrNot then
    --         RageUI.Button('Cloturer ce report', nil, {RightLabel = nlcRight}, true, {
    --             onSelected = function()
    --                 nlcReportEnCours = 'aucun'
    --                 TriggerServerEvent('Yvelt:UpdateReportState', s.id, 'Finish', s.identifier, s.source)
    --                 nlcReportList = nil
    --                 TriggerServerEvent('Yvelt:GetReportList')
    --             end		
    --         }, adminReports)
    --     else
    --         RageUI.Button('Prendre en charge ce report', 'Ce report a besoin d\'être pris en charge', {RightLabel = nlcRight}, true, {
    --             onSelected = function()
    --                 nlcTakedOrNot = true
    --                 nlcReportType = 'Taked'
    --                 nlcReportEnCours = s.id
    --                 TriggerServerEvent('Yvelt:UpdateReportState', s.id, 'Taked', s.identifier, s.source)
    --                 if IsPedSittingInAnyVehicle(PlayerPedId()) then
    --                     DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
    --                 end
    --             end		
    --         })
    --     RageUI.Button('Cloturer ce report', nil, {RightLabel = nlcRight}, true, {
    --         onSelected = function()
    --             TriggerServerEvent('Yvelt:UpdateReportState', s.id, 'Finish', s.identifier, s.source)
    --             nlcReportList = nil
    --             TriggerServerEvent('Yvelt:GetReportList')
    --         end		
    --     }, adminReports)
    --     end
    -- elseif nlcReportType == 'Taked' then
    --     RageUI.Button('Cloturer ce report', nil, {RightLabel = nlcRight}, true, {
    --         onSelected = function()
    --             TriggerServerEvent('Yvelt:UpdateReportState', s.id, 'Finish', s.identifier, s.source)
    --             nlcReportList = nil
    --             TriggerServerEvent('Yvelt:GetReportList')
    --         end		
    --     }, adminReports)

    --     RageUI.Separator('Pseudo : ~g~'..s.name..' ~c~('..s.source..')~s~ | ID Report : ~o~'..s.id)
    --     RageUI.List("Téléporte le joueur", YveltTeleportation, (YveltTeleportation.Index or 1), false, {}, true, {
    --         onListChange = function(Index)
    --             YveltTeleportation.Index = Index
    --         end,
    --         onSelected = function(Index)
    --             if YveltTeleportation.Index == 1 then
    --                 ExecuteCommand('goto '..s.source)
    --             else
    --                 ExecuteCommand('bring '..s.source)
    --             end
    --         end
    --     })
    --     RageUI.List("Action sur le joueurs", YveltAction, (YveltAction.Index or 1), false, {}, true, {
    --         onListChange = function(Index)
    --             YveltAction.Index = Index
    --         end,
    --         onSelected = function(Index)
    --             if YveltAction.Index == 1 then
    --                 ExecuteCommand('revive '..s.source)
    --             elseif YveltAction.Index == 2 then
    --                 ExecuteCommand('heal '..s.source)
    --             elseif YveltAction.Index == 3 then
    --                 ExecuteCommand('slay '..s.source)
    --             elseif YveltAction.Index == 4 then
    --                 local YveltRaison = KeyboardInput('YveltMsg', "Entrez la "..c.."raison~s~ du kick", '', 60)
    --                 local YveltConfirm = KeyboardInput('YveltMsg', "Entrez \""..c.."oui\"~s~ pour confirmer le kick", '', 3)
    --                 if YveltConfirm == 'oui' then
    --                     if YveltRaison ~= '' or YveltRaison ~= nil then
    --                         ExecuteCommand('kick '..s.source..' '..YveltRaison)
    --                     else
    --                         ExecuteCommand('kick '..s.source.. ' Aucune raison spécifié')
    --                     end
    --                 else
    --                     YveltHelper:clientNotification('~g~Vous avez annulé le kick !')
    --                 end
    --             end
    --         end
    --     })
    --     RageUI.List('Téléportations rapide', YveltConfig.FastTravel, IndexFasttravel, nil, {}, true, {
    --         onListChange = function(Index, Item)
    --             IndexFasttravel = Index;
    --         end,
    --         onSelected = function(Index, Item)
    --             --SetEntityCoords(PlayerPedId(), Item.Position)
    --             TriggerServerEvent('Yvelt:SetPedToCoords', GetPlayerServerId(PlayerId()), s.source, Item.Position)
    --         end
    --     })
    -- end
end

--[[
        if nlcReportList ~= nil then
        RageUI.Button('Actualiser la liste des reports', nil, {RightLabel = nlcRight}, true, {
            onSelected = function()
                nlcReportList = nil
                TriggerServerEvent('Yvelt:GetReportList')
            end		
        })
        if json.encode(nlcReportList) == '[]' then
            RageUI.Separator()
            RageUI.Separator('~g~Aucun report enregistrée')
            RageUI.Separator()
        else
            if nlcReportList ~= nil then 
                if nlcReportCount == 0 then
                    RageUI.Separator('Reports actifs : ~g~0 ~c~| ~s~Pris en charge : ~y~?')
                else
                    RageUI.Separator('Reports actifs : ~r~'..nlcReportCount..' ~c~| ~s~Pris en charge : ~y~?')
                end
            else
                RageUI.Separator('Reports actifs : ~g~. ~c~| ~s~Pris en charge : ~y~.')
            end
            RageUI.Checkbox("Cacher les pris en charge", nil, nlcHideTaked, {}, {
                onSelected = function(Index)
                    nlcHideTaked = Index
                end
            })
            RageUI.Checkbox("Cacher les reports réglés", nil, nlcRegleReport, {}, {
                onSelected = function(Index)
                    nlcRegleReport = Index
                end
            })
            if nlcReportList ~= nil and nlcReportEnCours ~= 'aucun' then
                if nlcHideTaked or nlcRegleReport then
                    RageUI.Separator('↓ Gestion de votre report ↓')
                else
                    RageUI.Separator('↓ Gestion des reports ↓')
                end
                for y,z in pairs(nlcReportList) do
                    if z.id == nlcReportEnCours and z.state == 'Taked' then
                        RageUI.Button('~y~[CHARGE] ~s~'..z.id..' → '..z.name, "Auteur du report : ~y~"..z.name.."~s~\nPris en charge par : ~y~Vous~s~\nRaison : ~y~"..z.report, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                            onSelected = function()
                                nlcReportType = z.state
                                nlcSelectedReport = z
                            end		
                        }, adminReportsActions)
                    end
                end
            end
            if nlcReportEnCours == 'aucun' then
                RageUI.Separator('↓ Gestion des reports ↓')
            end
            for k,v in pairs(nlcReportList) do
                if v.state == 'Waiting' then
                    RageUI.Button('~r~[ATTENTE] ~s~'..v.id..' → '..v.name, "Auteur du report : ~r~"..v.name.."~s~\nRaison : ~r~"..v.report, {RightLabel = nlcRight}, true, {
                        onSelected = function()
                            nlcReportType = v.state
                            nlcSelectedReport = v
                            nlcTakedOrNot = false
                        end		
                    }, adminReportsActions)
                elseif v.state == 'Taked' then
                    if not nlcHideTaked then
                        if v.staffName ~= nil then
                            RageUI.Button('~y~[CHARGE] ~s~'..v.id..' → '..v.name, "Auteur du report : ~y~"..v.name.."~s~\nPris en charge par : ~y~"..v.name.."~s~\nRaison : ~y~"..v.report, {RightLabel = nlcRight}, true, {
                                onSelected = function()
                                    nlcReportType = v.state
                                    nlcSelectedReport = v
                                end		
                            }, adminReportsActions)
                        else
                            RageUI.Button('~y~[CHARGE] ~s~'..v.id..' → '..v.name, "Auteur du report : ~y~"..v.name.."~s~\nPris en charge par : ~y~?~s~\nRaison : ~y~"..v.report, {RightLabel = nlcRight}, true, {
                                onSelected = function()
                                    nlcReportType = v.state
                                    nlcSelectedReport = v
                                end		
                            }, adminReportsActions)
                        end
                    end
                elseif v.state == 'Finish' and not nlcRegleReport then
                    if v.staffName ~= nil then
                        RageUI.Button('~g~[TERMINE] ~s~'..v.id..' → '..v.name, "Auteur du report : ~g~"..v.name.."~s~\nPris en charge par : ~g~"..v.name.."~s~\nRaison : ~g~"..v.report, {RightLabel = nlcRight}, true, {
                            onSelected = function()
                                nlcReportType = v.state
                                nlcReportId = v.id
                                nlcSelectedReport = k
                            end		
                        }, adminReportsActions)
                    else
                        RageUI.Button('~g~[TERMINE] ~s~'..v.id..' → '..v.name, "Auteur du report : ~g~"..v.name.."~s~\nPris en charge par : ~g~?~s~\nRaison : ~g~"..v.report, {RightLabel = nlcRight}, true, {
                            onSelected = function()
                                nlcReportType = v.state
                                nlcReportId = v.id
                                nlcSelectedReport = k
                            end		
                        }, adminReportsActions)
                    end
                end
            end
        end
    else
        RageUI.Separator()
        RageUI.Separator('~r~Chargement des reports en cours')
        RageUI.Separator()
    end
]]

local pendingReplies = {}

RegisterNetEvent('Yvelt:PlayerReplyReceived')
AddEventHandler('Yvelt:PlayerReplyReceived', function(playerName, playerSource, message)
    -- Notification visuelle pour l'admin
    YveltHelper:clientNotification('~g~Réponse de '..playerName..' ('..playerSource..'): ~w~'..message)

    pendingReplies[playerSource] = true

    -- Supprimer cette ligne pour éviter la notification ESX en double
    -- ESX.ShowNotification('~g~Nouvelle réponse de '..playerName..' ('..playerSource..')')
    
    -- Sauvegarder la réponse dans le rapport correspondant
    for k, v in pairs(Reports) do
        if v.source == playerSource and v.state == 'taked' and v.takedBy == GetPlayerName(PlayerId()) then
            if not v.replies then v.replies = {} end
            
            -- Remplacer os.date par une méthode utilisant GetGameTimer
            local hours = math.floor((GetGameTimer() / 3600000) % 24)
            local minutes = math.floor((GetGameTimer() / 60000) % 60)
            local seconds = math.floor((GetGameTimer() / 1000) % 60)
            local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
            
            table.insert(v.replies, {name = playerName, message = message, time = timeString})
            break
        end
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/repondre', 'Le message que vous souhaitez envoyer à l\'administrateur', {
        { name="message", help="Le message que vous souhaitez envoyer à l'administrateur" }
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/report', 'Merci de fournir un maximum de détails afin que nous puissions vous répondre dans les meilleurs délais.', {
        { name="message", help="Veuillez préciser votre problème ou la raison de votre demande afin que nous puissions vous assister de manière optimale." }
    })
end)

RegisterCommand("repondre", function(source, args)
    local message = table.concat(args, " ")
    if message ~= "" then
        TriggerServerEvent('Yvelt:PlayerReplyToAdmin', message)
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Système", "Veuillez entrer un message."}
        })
    end
end, false)

-- Ajouter cette variable pour suivre si l'instruction a déjà été affichée
local instructionShown = false

-- Modifier l'événement pour n'afficher l'instruction qu'une seule fois par session
RegisterNetEvent('Yvelt:AdminMessageReceived')
AddEventHandler('Yvelt:AdminMessageReceived', function(adminName)
    if not instructionShown then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Système", "Un administrateur vous a contacté. Utilisez /repondre [message] pour lui répondre."}
        })
        instructionShown = true
    end
end)