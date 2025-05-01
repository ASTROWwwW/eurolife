if ConfigWCambriolage.NewEsx == true then 
    ESX = exports['es_extended']:getSharedObject()
else
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end


local OuvertureMenu = ""
local VisualisationLogs = ""
local CreationValiderServeur = ""
local TpPointsLogs = ""
local DeleteJson = ""
local Lancementbraquage = ""
local EntrerBucket = ""
local SortieBucket = ""
local VenteItem = ""

function Customban(msg, target)
    DropPlayer(target, msg) -- Si vous voulez ban , mettre votre trigger de ban
end

RegisterServerEvent('buildermenu:OuvertureMenu')
AddEventHandler('buildermenu:OuvertureMenu', function(content)
    PerformHttpRequest(OuvertureMenu, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:VisualisationLogs')
AddEventHandler('buildermenu:VisualisationLogs', function(content)
    PerformHttpRequest(VisualisationLogs, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:CreationValiderServeur')
AddEventHandler('buildermenu:CreationValiderServeur', function(content)
    PerformHttpRequest(CreationValiderServeur, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 


RegisterServerEvent('buildermenu:TpPointsLogs')
AddEventHandler('buildermenu:TpPointsLogs', function(content)
    PerformHttpRequest(TpPointsLogs, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:DeleteJson')
AddEventHandler('buildermenu:DeleteJson', function(content)
    PerformHttpRequest(DeleteJson, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:Lancementbraquage')
AddEventHandler('buildermenu:Lancementbraquage', function(content)
    PerformHttpRequest(Lancementbraquage, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:EntrerBucket')
AddEventHandler('buildermenu:EntrerBucket', function(content)
    PerformHttpRequest(EntrerBucket, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:SortieBucket')
AddEventHandler('buildermenu:SortieBucket', function(content)
    PerformHttpRequest(SortieBucket, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('buildermenu:VenteItem')
AddEventHandler('buildermenu:VenteItem', function(content)
    PerformHttpRequest(VenteItem, function(err, text, headers) end, 'POST', json.encode({username = "Menu Builder Cambriolage", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 