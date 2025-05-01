local CoffreCache = {}


local function LoadAllCoffres()
    CoffreCache = {}
    exports.oxmysql:execute('SELECT * FROM eurolife_coffres', {}, function(result)
        for _, v in pairs(result) do
            local coffre = CoffreServerManager:Create({
                id = v.id,
                label = v.label,
                job = v.job,
                password = v.password,
                position = json.decode(v.position),
                max_weight = v.max_weight,
                markerType = tonumber(v.marker_type) or 1,
                markerSize = tonumber(string.format("%.1f", v.marker_size)) or 1.0,
                markerHeight = tonumber(string.format("%.1f", v.marker_height)) or 1.0,
                markerOpacity = tonumber(v.marker_opacity) or 150,
                markerColor = v.marker_color and json.decode(v.marker_color) or {r=0, g=150, b=255},
                money = v.money or 0, 
                black_money = v.black_money or 0 
            })
            
            CoffreCache[#CoffreCache + 1] = coffre
        end
        if Config.Debug then
            print(("[EUROLIFE COFFRE] %s coffres chargés dans le cache serveur."):format(#CoffreCache))
        end
    end)
end

RegisterNetEvent('eurolife_coffre:requestCoffres', function()
    local src = source
    local payload = {}

    for _, coffre in pairs(CoffreCache) do
        table.insert(payload, {
            id = coffre.id,
            label = coffre.label,
            job = coffre.job,
            password = coffre.password,
            position = json.encode(coffre.position), -- 🔥 ENCODE
            max_weight = coffre.maxWeight,
            marker_type = coffre.markerType,
            marker_size = coffre.markerSize,
            marker_height = coffre.markerHeight,
            marker_opacity = coffre.markerOpacity,
            marker_color = json.encode(coffre.markerColor), -- 🔥 ENCODE
            money = coffre.money,
            black_money = coffre.black_money
        })
    end

    TriggerClientEvent('eurolife_coffre:loadCoffres', src, payload)
end)


RegisterNetEvent('eurolife_coffre:refreshCoffres', function()
    LoadAllCoffres()
    Wait(500)
    local players = GetPlayers()
    if #players > 0 then
        local payload = {}
        for _, coffre in pairs(CoffreCache) do
            table.insert(payload, {
                id = coffre.id,
                label = coffre.label,
                job = coffre.job,
                password = coffre.password,
                position = coffre.position, -- PAS decode ici
                max_weight = coffre.maxWeight,
                marker_type = coffre.markerType,
                marker_size = coffre.markerSize,
                marker_height = coffre.markerHeight,
                marker_opacity = coffre.markerOpacity,
                marker_color = coffre.markerColor, -- PAS decode ici
                money = coffre.money,
                black_money = coffre.black_money
            })
        end
        for _, playerId in ipairs(players) do
            TriggerClientEvent('eurolife_coffre:loadCoffres', playerId, payload)
        end
    end
end)





AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    LoadAllCoffres()
end)
