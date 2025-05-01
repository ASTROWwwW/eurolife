if Config.NewEsx == true then 
    ESX = exports['es_extended']:getSharedObject()
else
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

local itemplayer = {}

RegisterNetEvent('fetchUserData')
AddEventHandler('fetchUserData', function()

    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local identifier = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT idboutique, ptsboutique, avatar FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)

        if result then
            TriggerClientEvent('receiveUserData', _src, result)
        end

    end)


end)

RegisterNetEvent('Boutique:updateAvatar')
AddEventHandler('Boutique:updateAvatar', function(id, avatarUrl)
    local src = source

    MySQL.Async.execute('UPDATE users SET avatar = @avatar WHERE idboutique = @id', {
        ['@id'] = id,
        ['@avatar'] = avatarUrl
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print(('Avatar mis à jour pour l\'ID boutique %s'):format(id))
        else
            print(('Échec de la mise à jour de l\'avatar pour l\'ID boutique %s'):format(id))
        end
    end)
end)

RegisterNetEvent('wBoutique:changePlayerBucket')
AddEventHandler('wBoutique:changePlayerBucket', function(bucket)
    local _src = source
    SetPlayerRoutingBucket(_src, bucket)
end)

RegisterNetEvent('boutique:acheterArme')
AddEventHandler('boutique:acheterArme', function(armeName, prix, TypeArme, Label)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local identifier = xPlayer.getIdentifier()

    MySQL.Async.fetchScalar('SELECT ptsboutique FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(ptsBoutique)

        if ptsBoutique >= prix then
            local newPts = ptsBoutique - prix

            MySQL.Async.execute('UPDATE users SET ptsboutique = @newPts WHERE identifier = @identifier', {
                ['@newPts'] = newPts,
                ['@identifier'] = identifier
            })

            if TypeArme == 'normal' then 
                Config.AddItemNormal(xPlayer,_src,armeName, prix, Label)
            elseif TypeArme == 'perm' then 
                Config.AddItemPerm(xPlayer,_src,armeName, prix, Label)
            end

            MySQL.Async.execute('INSERT INTO wBoutiqueHistorique (identifier, Type, Montant, Date, Achat,SoldeAfterAchat) VALUES (@identifier, @type, @montant, @date, @achat,@SoldeAfterAchat)', {
                ['@identifier'] = identifier,
                ['@type'] = 'Achat d\'arme',
                ['@montant'] = prix,
                ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
                ['@achat'] = Label,
                ['@SoldeAfterAchat'] = newPts,
            })

            local heure = os.date("%d/%m/%Y %X")
            local idr1= xPlayer.getIdentifier()
            local NomJoueur = xPlayer.getName()
            local contenta = {
                {
                    ["color"] = '5897984',
                    ["title"] = "Script Boutique",
                    ["description"] = '**Joueur ID : **' ..tostring(_src) ..'\n ** Nom Du joueur : **'..NomJoueur..'\n ** A acheté : **'..Label..'\n ** Pour un montant de : **'..prix..'\n ** Coins Restant : **'..newPts,
                    ["footer"] = {
                        ["text"] = heure ..'\nlicense:'..idr1,
                    },
                }
            }

        
            TriggerEvent("Boutique:LogsAchatArmes",contenta)


            TriggerClientEvent('boutique:fermeture', -1)

        else

            TriggerClientEvent('esx:showNotification', _src, 'Vous n\'avez pas assez de ~r~points~s~ pour cet achat.')
        end
    end)
end)

RegisterNetEvent('boutique:requestHistorique')
AddEventHandler('boutique:requestHistorique', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local identifier = xPlayer.identifier
    
    MySQL.Async.fetchAll('SELECT * FROM wBoutiqueHistorique WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(results)
        if results then
            TriggerClientEvent('boutique:openHistorique', _src, results)
        end
    end)
end)


function shuffle(tbl)
    local n = #tbl
    while n > 1 do
        local k = math.random(n)
        tbl[n], tbl[k] = tbl[k], tbl[n]
        n = n - 1
    end
    return tbl
end



function Lalootbox(nom, price, LabelLootBox, newPts)
    local itemtochoose = {}
    local lastlistbeforepicking = {}
    local itemtogive = nil


    for k,v in pairs(Config.LootBox) do 
        if nom == v.name then 
            for k2, v2 in pairs(Config.LootBox[k].contents) do 
                for i = 1, v2.drop_rate, 1 do 
                    table.insert(itemtochoose, { Obj = v2.item , TypeArme = v2.type, ImageItem = v2.image , LabelItem = v2.label, NomBox = nom, PrixLootBox = price, LabelLootBox = LabelLootBox, newPts = newPts } )
                end
            end
        end
    end
    Wait(50)
    lastlistbeforepicking = shuffle(itemtochoose)
    Wait(50)



    itemtogive = lastlistbeforepicking[math.random(#lastlistbeforepicking)]

    Wait(10)
    return itemtogive
end


RegisterNetEvent('lootbox:verifierPoints')
AddEventHandler('lootbox:verifierPoints', function(lootBoxId)
    
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local LabelLootBox = nil
    local price = 0
    local lalootboxaouvrir = nil

    for k,v in pairs(Config.LootBox) do 
        if lootBoxId == v.name then 
            price = v.price
            LabelLootBox = v.label
            lalootboxaouvrir = v.name
            break
        end
    end

    if itemplayer[_src] then 
        xPlayer.showNotification("Vous ne pouvez pas faire 2 lootbox en même temps")
        return 
    end

    MySQL.Async.fetchScalar('SELECT ptsboutique FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(ptsBoutique)
        if ptsBoutique >= price then

            local newPts = ptsBoutique - price
            MySQL.Async.execute('UPDATE users SET ptsboutique = @newPts WHERE identifier = @identifier', {
                ['@newPts'] = newPts,
                ['@identifier'] = xPlayer.identifier
            })

            Wait(20)
            itemplayer[_src] = Lalootbox(lalootboxaouvrir,price, LabelLootBox, newPts)

            TriggerClientEvent('lootbox:resultat', _src, itemplayer[_src].ImageItem)
        else
            xPlayer.showNotification("Vous n'avez pas assez de points pour acheter cette lootbox.")
            TriggerClientEvent('boutique:FermetureChepasquoi', -1)
        end
    end)
end)

ESX.RegisterServerCallback('Boutique:PlaqueDispoOrNot', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        cb(result[1] ~= nil)
    end)
end)

function GeneratePlate()

    local letters = ""
    local numbers = ""


    for i = 1, 4 do
        letters = letters .. string.char(math.random(65, 90))
    end

    for i = 1, 4 do
        numbers = numbers .. tostring(math.random(0, 9))
    end

    return letters .. numbers
end


function GenerateUniquePlate(callback)
    local newPlate = GeneratePlate()

    MySQL.Async.fetchScalar('SELECT plate FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = newPlate
    }, function(result)
        if result then
            GenerateUniquePlate(callback)
        else
            callback(newPlate)
        end
    end)
end


RegisterNetEvent('Boutique:AchatVeh')
AddEventHandler('Boutique:AchatVeh', function(Name,Label,Prix)

    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local price = Prix
    
    MySQL.Async.fetchScalar('SELECT ptsboutique FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(ptsBoutique)
        if ptsBoutique >= price then

            local newPts = ptsBoutique - price
            MySQL.Async.execute('UPDATE users SET ptsboutique = @newPts WHERE identifier = @identifier', {
                ['@newPts'] = newPts,
                ['@identifier'] = xPlayer.identifier
            })

            GenerateUniquePlate(function(generatedPlate)
                Config.AchatVeh(_src, xPlayer, Name,Label,price,generatedPlate,newPts)
            end)

            MySQL.Async.execute('INSERT INTO wBoutiqueHistorique (identifier, Type, Montant, Date, Achat,SoldeAfterAchat) VALUES (@identifier, @type, @montant, @date, @achat,@SoldeAfterAchat)', {
                ['@identifier'] = xPlayer.identifier,
                ['@type'] = 'Achat Véhicule',
                ['@montant'] = price,
                ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
                ['@achat'] = Label,
                ['@SoldeAfterAchat'] = newPts,
            })

            local heure = os.date("%d/%m/%Y %X")
            local idr1= xPlayer.getIdentifier()
            local NomJoueur = xPlayer.getName()
            local contenta = {
                {
                    ["color"] = '5897984',
                    ["title"] = "Script Boutique",
                    ["description"] = '**Joueur ID : **' ..tostring(_src) ..'\n ** Nom Du joueur : **'..NomJoueur..'\n ** A acheté : **'..Label..'\n ** Pour un montant de : **'..price..'\n ** Coins Restant : **'..newPts,
                    ["footer"] = {
                        ["text"] = heure ..'\nlicense:'..idr1,
                    },
                }
            }

        
            TriggerEvent("Boutique:LogsAchatVoitures",contenta)

        else
            xPlayer.showNotification("Vous n'avez pas assez de points pour acheter cette Voiture.")
        end
    end)
end)

RegisterNetEvent('lootbox:itemGagneServeur')
AddEventHandler('lootbox:itemGagneServeur', function()

    local _src = source
    local itemGagne = nil 
    local xPlayer = ESX.GetPlayerFromId(_src)
    local identifier = xPlayer.getIdentifier()

    if itemplayer[_src] then

        MySQL.Async.execute('INSERT INTO wBoutiqueHistorique (identifier, Type, Montant, Date, Achat,SoldeAfterAchat) VALUES (@identifier, @type, @montant, @date, @achat,@SoldeAfterAchat)', {
            ['@identifier'] = identifier,
            ['@type'] = 'LootBox '..itemplayer[_src].LabelLootBox,
            ['@montant'] = itemplayer[_src].PrixLootBox,
            ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
            ['@achat'] = itemplayer[_src].LabelItem,
            ['@SoldeAfterAchat'] = itemplayer[_src].newPts,
        })

        local heure = os.date("%d/%m/%Y %X")
        local idr1= xPlayer.getIdentifier()
        local NomJoueur = xPlayer.getName()
        local contenta = {
            {
                ["color"] = '5897984',
                ["title"] = "Script Boutique",
                ["description"] = '**Joueur ID : **' ..tostring(_src) ..'\n ** Nom Du joueur : **'..NomJoueur..'\n ** A acheté la LootBox  : ** '..itemplayer[_src].LabelLootBox..'\n ** Il a gagné : ** '..itemplayer[_src].LabelItem..'\n ** Pour un montant de : **'..itemplayer[_src].PrixLootBox..'\n ** Coins Restant : **'..itemplayer[_src].newPts,
                ["footer"] = {
                    ["text"] = heure ..'\nlicense:'..idr1,
                },
            }
        }

    
        TriggerEvent("Boutique:LogsAchatLootBox",contenta)


        if itemplayer[_src].TypeArme == "item" then 

            Config.LootBoxGainItem(xPlayer,_src, itemplayer[_src].Obj, itemplayer[_src].LabelItem , itemplayer[_src].NomBox , itemplayer[_src].PrixLootBox, itemplayer[_src].LabelLootBox, itemplayer[_src].newPts)

        elseif itemplayer[_src].TypeArme == "car" or itemplayer[_src].TypeArme == "bike" or itemplayer[_src].TypeArme == "boat" or itemplayer[_src].TypeArme == "plane" then

            GenerateUniquePlate(function(generatedPlate)
        
                    Config.LootBoxGainCar(
                        xPlayer,
                        _src,
                        itemplayer[_src].Obj,
                        itemplayer[_src].LabelItem,
                        itemplayer[_src].NomBox,
                        itemplayer[_src].PrixLootBox,
                        itemplayer[_src].LabelLootBox,
                        itemplayer[_src].newPts,
                        itemplayer[_src].TypeArme,
                        generatedPlate
                    )
            end)

        elseif itemplayer[_src].TypeArme == "money" then 

            Config.LootBoxGainMoney(xPlayer,_src, itemplayer[_src].Obj, itemplayer[_src].LabelItem , itemplayer[_src].NomBox , itemplayer[_src].PrixLootBox, itemplayer[_src].LabelLootBox, itemplayer[_src].newPts)

        elseif itemplayer[_src].TypeArme == "perm" then 

            Config.LootBoxGainArmPerm(xPlayer,_src, itemplayer[_src].Obj, itemplayer[_src].LabelItem , itemplayer[_src].NomBox , itemplayer[_src].PrixLootBox, itemplayer[_src].LabelLootBox, itemplayer[_src].newPts)

        end
        
    end

    Wait(1000)

    itemplayer[_src] = nil 

    TriggerClientEvent('boutique:fermeture', _src)


end)

RegisterCommand(Config.CommandeGivePts, function(source, args, raw)
  local _source = source
  local id    = args[1]
  local point = (ESX.Math.Round(args[2]))

  if source == 0 then 

      MySQL.query('SELECT * FROM users WHERE idboutique =@idboutique', {
          ['@idboutique'] = id}, 
          
          function(data)

          local poi = data[1].ptsboutique
          npoint = poi + point
  
          MySQL.Async.execute('UPDATE `users` SET `ptsboutique`=@ptsboutique  WHERE idboutique=@idboutique', {
              ['@idboutique'] = id,
              ['@ptsboutique'] = npoint 
          }, function(rowsChange)
          end)

        local heure = os.date("%d/%m/%Y %X")
        local contenta = {
            {
                ["color"] = '5897984',
                ["title"] = "Give ID Boutique",
                ["description"] = '**Give de : **' ..point ..'\n ** Id boutique : **'..id,
                ["footer"] = {
                    ["text"] = heure,
                },
            }
        }

        print('^4Give Point boutique via idboutique ' .. id .. ' points '..point)

        TriggerEvent("Boutique:GiveCoinLogs",contenta)


      end)
  end
end, true)