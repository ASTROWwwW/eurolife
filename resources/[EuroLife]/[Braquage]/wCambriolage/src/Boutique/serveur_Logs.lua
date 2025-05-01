if Config.NewEsx == true then 
    ESX = exports['es_extended']:getSharedObject()
else
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

local LogisGiveCoint = ""
local LogisAchatArmes = ""
local LogsAchatVoitures = ""
local LogsAchatLootBox = ""


RegisterServerEvent('Boutique:GiveCoinLogs')
AddEventHandler('Boutique:GiveCoinLogs', function(content)
    PerformHttpRequest(LogisGiveCoint, function(err, text, headers) end, 'POST', json.encode({username = "Script Boutiuqe", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('Boutique:LogsAchatArmes')
AddEventHandler('Boutique:LogsAchatArmes', function(content)
    PerformHttpRequest(LogisAchatArmes, function(err, text, headers) end, 'POST', json.encode({username = "Script Boutiuqe", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('Boutique:LogsAchatVoitures')
AddEventHandler('Boutique:LogsAchatVoitures', function(content)
    PerformHttpRequest(LogsAchatVoitures, function(err, text, headers) end, 'POST', json.encode({username = "Script Boutiuqe", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

RegisterServerEvent('Boutique:LogsAchatLootBox')
AddEventHandler('Boutique:LogsAchatLootBox', function(content)
    PerformHttpRequest(LogsAchatLootBox, function(err, text, headers) end, 'POST', json.encode({username = "Script Boutiuqe", embeds = content}), { ['Content-Type'] = 'application/json' })
end) 

