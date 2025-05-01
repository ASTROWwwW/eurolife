

ESX = exports["es_extended"]:getSharedObject()

-- Fonction pour obtenir l'heure française correcte avec la date
local function getFrenchTime()
    local time = os.date('!*t', os.time()) -- UTC time
    local dstCheck = os.date('*t').isdst   -- Check if DST is in effect
    
    -- Appliquer le décalage horaire français (UTC+1 en hiver, UTC+2 en été)
    if dstCheck then
        time.hour = (time.hour + 2) % 24  -- UTC+2 en été (DST active)
    else 
        time.hour = (time.hour + 1) % 24  -- UTC+1 en hiver (pas de DST)
    end
    
    return time
end

-- Fonction pour récupérer la license
local function getPlayerLicense(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return "License non trouvée"
end

AddEventHandler('playerConnecting', function(t,t2,t3)
    local source = source
    local identifier = getPlayerLicense(source)
    local name = GetPlayerName(source)
    local playerIp = GetPlayerEndpoint(source)
    local playerPing = GetPlayerPing(source)
    local time = getFrenchTime()

    PerformHttpRequest('https://discord.com/api/webhooks/1292408147490639976/Uvy9OUfkr-GuIG6NglfT1zpqZ6Cz2z36Eq_jBwUf6obF6iINRDo784iigw00lF5ukJNw', 
                                    function(err, text, headers) end, 'POST', 
                                    json.encode({embeds={{
                                        title="Connexion",
                                        description="\n📜 <b>Nom du joueur</b> : "..name.. "`\n🎮 <b>Licence du joueur</b> : "..identifier.. "\n📡 <b>Ping du joueur</b> : "..playerPing.. "\n📅 <b>Date</b> : "..time.day.."/"..time.month.."/"..time.year.."\n🕘 <b>Heure</b> : "..time.hour..":"..time.min..":"..time.sec,
                                        color=16711680
                                    }}}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function(reason)
    local lPlayer = ESX.GetPlayerFromId(source)

    if lPlayer then
        local identifier = lPlayer.identifier -- Déjà la license dans ESX
        local name = GetPlayerName(source)
        local playerIp = GetPlayerEndpoint(source)
        local playerPing = GetPlayerPing(source)
        local time = getFrenchTime()

        PerformHttpRequest('https://discord.com/api/webhooks/1292408147490639976/Uvy9OUfkr-GuIG6NglfT1zpqZ6Cz2z36Eq_jBwUf6obF6iINRDo784iigw00lF5ukJNw', 
                                    function(err, text, headers) end, 'POST', 
                                    json.encode({embeds={{
                                        title="Déconnexion",
                                        description="\n📜 Player name: "..name.. "`["..source.."]`\n🎮 Identifier: "..identifier.. "\n📡 Player Ping: "..playerPing.. "\n❓ Reason: "..reason.."\n📅 Date: "..time.day.."/"..time.month.."/"..time.year.."\n🕘 Heure: "..time.hour..":"..time.min..":"..time.sec,
                                        color=16711680
                                    }}}), { ['Content-Type'] = 'application/json' })
    else
        print('^7 Player Disconnected On Loading Screen')
    end
end)

AddEventHandler('chatMessage', function(source, name, message)
    local time = getFrenchTime()

    PerformHttpRequest('https://discord.com/api/webhooks/1358022420765737100/V-UY7HEqATQ2egU65CBAxuhfSJ5-otVxRnVjYO3sUcQ9AWqd7OaKrg955eTUWqPuadTk', 
                                    function(err, text, headers) end, 'POST', 
                                    json.encode({embeds={{
                                        title="Logs Console",
                                        description="\nNom du joueur: "..name.. "`["..source.."]`\nType de commande: "..message.."\nDate: "..time.day.."/"..time.month.."/"..time.year.."\nHeure: "..time.hour..":"..time.min..":"..time.sec,
                                        color=16711680
                                    }}}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('lz-logs:aimlogs')
AddEventHandler('lz-logs:aimlogs', function(pedId)
    local name,id = GetPlayerName(source), ESX.GetPlayerFromId(source)
    local tname,tid = GetPlayerName(pedId), ESX.GetPlayerFromId(pedId)
    local time = getFrenchTime()

    PerformHttpRequest('https://discord.com/api/webhooks/1204115818409893949/i5Wyi8MERwOMoY67AdVG3YQWQ5jk3S9vbwrNXy-agQUYuoZPiLw8ZZVKKmDTNGt7uo7o', 
                                    function(err, text, headers) end, 'POST', 
                                    json.encode({embeds={{
                                        title="Journaux de visée",
                                        description="\nPlayer name: "..name.. "`["..id.source.."]`\nvise: "..tname.." `["..tid.source.."]`\nDate: "..time.day.."/"..time.month.."/"..time.year.."\nHeure: "..time.hour..":"..time.min..":"..time.sec,
                                        color=16711680
                                    }}}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('lz-logs:killlogs')
AddEventHandler('lz-logs:killlogs', function(message, weapon)
    local time = getFrenchTime()

    weapon = weapon or "Unknown Weapon"

    PerformHttpRequest('https://discord.com/api/webhooks/1357640136132919366/ETRPiJE6YJEQNZ2qnSeHolFv5H7-em21xDVO_CZmRRZgA2QCVndPZjbXMreTp8rI4NFf', 
                                    function(err, text, headers) end, 'POST', 
                                    json.encode({embeds={{
                                        title="Kill Logs",
                                        description="\n"..message.. "\nWeapon: "..weapon.."\nDate: "..time.day.."/"..time.month.."/"..time.year.."\nHeure: "..time.hour..":"..time.min..":"..time.sec,
                                        color=16711680
                                    }}}), { ['Content-Type'] = 'application/json' })
end)