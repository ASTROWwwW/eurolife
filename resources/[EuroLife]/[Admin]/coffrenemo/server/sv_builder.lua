RegisterNetEvent("eurolife_coffre:createCoffre", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if Config.Debug then
        print(("[EUROLIFE COFFRE] createCoffre déclenché par %s"):format(src))
    end

    if not data.label or not data.job or not data.position then
        TriggerEvent('eurolife_coffre:refreshCoffres')
        if Config.Debug then print("[EUROLIFE COFFRE] Données incomplètes à la création.") end
        return
    end

    -- Formatage propre
    local label = data.label
    local job = data.job
    local password = data.usePassword and data.password or ""
    local position = json.encode(data.position)
    local maxWeight = tonumber(data.maxWeight) or 100
    local markerType = tonumber(data.marker.type) or 1
    local markerSize = tonumber(string.format("%.1f", data.marker.size)) or 1.0
    local markerHeight = tonumber(string.format("%.1f", data.marker.height)) or 1.0
    local markerOpacity = tonumber(data.marker.opacity) or 150
    local markerColor = json.encode(data.marker.color or {r=0, g=150, b=255})

    if data.id then
        -- UPDATE EXISTANT
        exports.oxmysql:update([[
            UPDATE eurolife_coffres
            SET label = ?, job = ?, password = ?, position = ?, max_weight = ?, 
                marker_type = ?, marker_size = ?, marker_height = ?, marker_opacity = ?, marker_color = ?
            WHERE id = ?
        ]], {
            label, job, password, position, maxWeight,
            markerType, markerSize, markerHeight, markerOpacity, markerColor,
            data.id
        }, function(rowsChanged)
            if Config.Debug then
                print(("[EUROLIFE COFFRE] Coffre ID %s modifié (lignes affectées : %s)"):format(data.id, rowsChanged))
            end
            TriggerEvent('eurolife_coffre:refreshCoffres')
        end)
    else
        -- INSERT NOUVEAU
        exports.oxmysql:insert([[
            INSERT INTO eurolife_coffres
            (label, job, password, position, max_weight, marker_type, marker_size, marker_height, marker_opacity, marker_color, money, black_money)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0)
        ]], {
            label, job, password, position, maxWeight,
            markerType, markerSize, markerHeight, markerOpacity, markerColor
        }, function(insertId)
            if insertId then
                if Config.Debug then
                    print(("[EUROLIFE COFFRE] Nouveau coffre créé, ID : %s par %s (init money/black_money = 0)"):format(insertId, xPlayer.identifier))
                end
                TriggerEvent('eurolife_coffre:refreshCoffres')
            else
                if Config.Debug then
                    print("[EUROLIFE COFFRE] ERREUR lors de l'insertion du coffre.")
                end
            end
        end)
    end
end)

-- Suppression Coffre
ESX.RegisterServerCallback('eurolife_coffre:deleteCoffre', function(source, cb, id)
    if not id then
        return cb(false)
    end

    exports.oxmysql:execute('DELETE FROM eurolife_coffres WHERE id = ?', {id}, function(affectedRows)
        if affectedRows then
            if Config.Debug then
                print(("[EUROLIFE COFFRE] Coffre ID %s supprimé."):format(id))
            end
            TriggerEvent('eurolife_coffre:refreshCoffres')
            cb(true)
        else
            cb(false)
        end
    end)
end)

-- Récupérer tous les coffres
ESX.RegisterServerCallback('eurolife_coffre:getAllCoffres', function(source, cb)
    exports.oxmysql:execute('SELECT * FROM eurolife_coffres', {}, function(result)
        cb(result)
    end)
end)

-- Check Admin
ESX.RegisterServerCallback('eurolife_coffre:checkAdmin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false) end

    local playerGroup = xPlayer.getGroup()
    for _, group in pairs(Config.AdminGroups) do
        if playerGroup == group then
            return cb(true)
        end
    end
    cb(false)
end)
