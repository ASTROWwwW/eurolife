-- function StartPayCheck()
--     CreateThread(function()
--         while true do
--             Wait(Config.PaycheckInterval)
--             for player, xPlayer in pairs(ESX.Players) do
--                 local jobLabel = xPlayer.job.label
--                 local job = xPlayer.job.grade_name
--                 local salary = xPlayer.job.grade_salary

--                 if salary > 0 then
--                     if job == "unemployed" then -- unemployed
--                         xPlayer.addAccountMoney("bank", salary, "Welfare Check")
--                         TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), TranslateCap("received_help", salary), "CHAR_BANK_FLEECA", 9)
--                         if Config.LogPaycheck then
--                             ESX.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
--                                 { name = "Player", value = xPlayer.name, inline = true },
--                                 { name = "ID", value = xPlayer.source, inline = true },
--                                 { name = "Amount", value = salary, inline = true },
--                             })
--                         end
--                     elseif Config.EnableSocietyPayouts then -- possibly a society
--                         TriggerEvent("esx_society:getSociety", xPlayer.job.name, function(society)
--                             if society ~= nil then -- verified society
--                                 TriggerEvent("esx_addonaccount:getSharedAccount", society.account, function(account)
--                                     if account.money >= salary then -- does the society money to pay its employees?
--                                         xPlayer.addAccountMoney("bank", salary, "Paycheck")
--                                         account.removeMoney(salary)
--                                         if Config.LogPaycheck then
--                                             ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
--                                                 { name = "Player", value = xPlayer.name, inline = true },
--                                                 { name = "ID", value = xPlayer.source, inline = true },
--                                                 { name = "Amount", value = salary, inline = true },
--                                             })
--                                         end

--                                         TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), TranslateCap("received_salary", salary), "CHAR_BANK_FLEECA", 9)
--                                     else
--                                         TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), "", TranslateCap("company_nomoney"), "CHAR_BANK_MAZE", 1)
--                                     end
--                                 end)
--                             else -- not a society
--                                 xPlayer.addAccountMoney("bank", salary, "Paycheck")
--                                 if Config.LogPaycheck then
--                                     ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
--                                         { name = "Player", value = xPlayer.name, inline = true },
--                                         { name = "ID", value = xPlayer.source, inline = true },
--                                         { name = "Amount", value = salary, inline = true },
--                                     })
--                                 end
--                                 TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), TranslateCap("received_salary", salary), "CHAR_BANK_FLEECA", 9)
--                             end
--                         end)
--                     else -- generic job
--                         xPlayer.addAccountMoney("bank", salary, "Paycheck")
--                         if Config.LogPaycheck then
--                             ESX.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
--                                 { name = "Player", value = xPlayer.name, inline = true },
--                                 { name = "ID", value = xPlayer.source, inline = true },
--                                 { name = "Amount", value = salary, inline = true },
--                             })
--                         end
--                         TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), TranslateCap("received_salary", salary), "CHAR_BANK_FLEECA", 9)
--                     end
--                 end
--             end
--         end
--     end)
-- end

function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(Config.PaycheckInterval)
            for player, xPlayer in pairs(ESX.Players) do
                -- Montant fixe d'aide de l'État pour tous
                local aideEtatMontant = 25 -- Montant à ajuster selon vos besoins
                
                -- Verser l'aide de l'État à tout le monde
                xPlayer.addAccountMoney("bank", aideEtatMontant, "Aide de l'État")
                TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), 
                    "Aide de l'État", 
                    TranslateCap("received_help", aideEtatMontant), 
                    "CHAR_BANK_FLEECA", 9)
                
                if Config.LogPaycheck then
                    ESX.DiscordLogFields("Paycheck", "Aide de l'État", "green", {
                        { name = "Player", value = xPlayer.name, inline = true },
                        { name = "ID", value = xPlayer.source, inline = true },
                        { name = "Amount", value = aideEtatMontant, inline = true },
                    })
                end

                -- Gestion du job1
                local job1Label = xPlayer.job.label
                local job1 = xPlayer.job.grade_name
                local salary1 = xPlayer.job.grade_salary

                -- Gestion du job2
                local job2Label = xPlayer.job2.label
                local job2 = xPlayer.job2.grade_name
                local salary2 = xPlayer.job2.grade_salary

                -- Traitement du job1 (tous les jobs, y compris unemployed)
                if salary1 > 0 then
                    if Config.EnableSocietyPayouts then
                        HandleSocietyPayout(xPlayer, player, job1Label, salary1, "job")
                    else
                        HandleRegularPayout(xPlayer, player, job1Label, salary1, "Principal")
                    end
                end

                -- Traitement du job2
                if salary2 > 0 then
                    if Config.EnableSocietyPayouts then
                        HandleSocietyPayout(xPlayer, player, job2Label, salary2, "job2")
                    else
                        HandleRegularPayout(xPlayer, player, job2Label, salary2, "Secondaire")
                    end
                end
            end
        end
    end)
end

-- Fonction pour gérer les paiements de société
function HandleSocietyPayout(xPlayer, player, jobLabel, salary, jobType)
    local societyAccount = jobType == "job" and xPlayer.job.name or xPlayer.job2.name
    
    TriggerEvent("esx_society:getSociety", societyAccount, function(society)
        if society ~= nil then
            TriggerEvent("esx_addonaccount:getSharedAccount", society.account, function(account)
                if account.money >= salary then
                    xPlayer.addAccountMoney("bank", salary, "Salaire - " .. jobLabel)
                    account.removeMoney(salary)
                    
                    if Config.LogPaycheck then
                        ESX.DiscordLogFields("Paycheck", "Salaire - " .. jobLabel, "green", {
                            { name = "Player", value = xPlayer.name, inline = true },
                            { name = "ID", value = xPlayer.source, inline = true },
                            { name = "Amount", value = salary, inline = true },
                            { name = "Job Type", value = jobType == "job" and "Principal" or "Secondaire", inline = true },
                        })
                    end

                    TriggerClientEvent("esx:showAdvancedNotification", player, 
                        TranslateCap("bank"), 
                        "Salaire - " .. jobLabel, 
                        "Vous avez reçu votre salaire de ~g~" .. salary .. "$ ~w~pour votre travail ~b~" .. (jobLabel), 
                        "CHAR_BANK_FLEECA", 9)
                else
                    TriggerClientEvent("esx:showAdvancedNotification", player, 
                        TranslateCap("bank"), 
                        "Entreprise - " .. jobLabel, 
                        "Votre entreprise n'a pas assez d'argent pour vous payer", 
                        "CHAR_BANK_MAZE", 1)
                end
            end)
        else
            HandleRegularPayout(xPlayer, player, jobLabel, salary, jobLabel)
        end
    end)
end

-- Fonction pour gérer les paiements réguliers
function HandleRegularPayout(xPlayer, player, jobLabel, salary, jobType)
    xPlayer.addAccountMoney("bank", salary, "Salaire - " .. jobLabel)
    
    if Config.LogPaycheck then
        ESX.DiscordLogFields("Paycheck", "Salaire - " .. jobLabel, "green", {
            { name = "Player", value = xPlayer.name, inline = true },
            { name = "ID", value = xPlayer.source, inline = true },
            { name = "Amount", value = salary, inline = true },
            { name = "Job Type", value = jobType, inline = true },
        })
    end

    TriggerClientEvent("esx:showAdvancedNotification", player, 
        TranslateCap("bank"), 
        "Salaire - " .. jobLabel, 
        "Vous avez reçu votre salaire de ~g~" .. salary .. "$ ~w~pour votre travail ~b~" .. string.lower(jobLabel), 
        "CHAR_BANK_FLEECA", 9)
end
