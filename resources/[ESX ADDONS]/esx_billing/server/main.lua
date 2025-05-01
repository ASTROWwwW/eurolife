
RegisterNetEvent('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)

	if amount > 0 and xTarget then
		if string.match(sharedAccountName, "society_") then
			local jobName = string.gsub(sharedAccountName, 'society_', '')

			if sharedAccountName == 'society_police' then
				TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
				if account then
					MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount},
					function(rowsChanged)
						xTarget.showAdvancedNotification('Police', 'Amende',
						('Vous avez ~r~recu~w~ une amende de ~r~%s$~w~'):format(ESX.Math.GroupDigits(amount)), 'char_bank_maze')
					end)
				else
					print(("[^2ERROR^7] Player ^5%s^7 Attempted to Send bill from invalid society - ^5%s^7"):format(xPlayer.source, sharedAccountName))
				end
			end)
			else
				xTarget.triggerEvent('esx_billing:choiceBill', source, sharedAccountName, label, amount, xPlayer.job.label)
			end
		else
			MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'player', xPlayer.identifier, label, amount},
			function(rowsChanged)
				xTarget.showNotification(TranslateCap('received_invoice'))
			end)
		end
	end
end)

RegisterNetEvent('esx_billing:confirmBill')
AddEventHandler('esx_billing:confirmBill', function(sender, sharedAccountName, label, amount, action)
    local xPlayer = ESX.GetPlayerFromId(sender)
    local xTarget = ESX.GetPlayerFromId(source)

    if action == 'accept' then
        -- Lorsque le joueur accepte la facture (mais ne paye pas encore)
        TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
            if account then
                MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', 
                {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount},
                function(rowsChanged)
                    xTarget.showAdvancedNotification(xPlayer.job.label, 'Facture',
                    ('Vous avez ~r~recu~w~ une facture de ~r~%s$'):format(ESX.Math.GroupDigits(amount)), 'CHAR_BANK_FLEECA', 9)
                    xPlayer.showNotification('La personne a ~o~accepté~w~ la facture')
                end)
            else
                print(("[^2ERROR^7] Player ^5%s^7 Attempted to Send bill from invalid society - ^5%s^7"):format(xPlayer.source, sharedAccountName))
            end
        end)
    elseif action == 'pay' then
        -- Lorsque le joueur paye directement
        TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
            if account then
                if xTarget.getMoney() >= amount then
                    xTarget.removeMoney(amount, "Bill Paid")
                    account.addMoney(amount)

                    -- Mettre à jour mecano_fines si c'est une amende mecano
                    if string.find(label, 'Amende Mécano: ') or string.find(label, 'Amende mecano: ') then
                        local reason = string.gsub(label, 'Amende [Mm]écano: ', '')
                        MySQL.update(
                            'UPDATE mecano_fines SET paid = 1 WHERE identifier = ? AND reason = ? AND amount = ? AND paid = 0 LIMIT 1',
                            {xTarget.identifier, reason, amount},
                            function(rowsChanged)
                                if rowsChanged > 0 then
                                    TriggerClientEvent('mecano:refreshBossMenu', -1)
                                end
                            end)
                    end

                    xTarget.showAdvancedNotification(xPlayer.job.label, 'Facture',
                    ('Vous avez ~b~payé~w~ une facture de ~r~%s$'):format(ESX.Math.GroupDigits(amount)), 'CHAR_BANK_FLEECA', 9)
                    xPlayer.showNotification('La personne a ~g~payé~w~ la facture')
                elseif xTarget.getAccount('bank').money >= amount then
                    xTarget.removeAccountMoney('bank', amount, "Bill Paid")
                    account.addMoney(amount)

                    -- Mettre à jour mecano_fines si c'est une amende mecano
                    if string.find(label, 'Amende Mécano: ') or string.find(label, 'Amende mecano: ') then
                        local reason = string.gsub(label, 'Amende [Mm]écano: ', '')
                        MySQL.update(
                            'UPDATE mecano_fines SET paid = 1 WHERE identifier = ? AND reason = ? AND amount = ? AND paid = 0 LIMIT 1',
                            {xTarget.identifier, reason, amount},
                            function(rowsChanged)
                                if rowsChanged > 0 then
                                    TriggerClientEvent('mecano:refreshBossMenu', -1)
                                end
                            end)
                    end

                    xTarget.showAdvancedNotification(xPlayer.job.label, 'Facture',
                    ('Vous avez ~b~payé~w~ une facture de ~r~%s$'):format(ESX.Math.GroupDigits(amount)), 'CHAR_BANK_FLEECA', 9)
                    xPlayer.showNotification('La personne a ~g~payé~w~ la facture')
                else
                    -- Si pas assez d'argent, créer quand même la facture
                    TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
                        if account then
                            MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', 
                            {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount},
                            function(rowsChanged)
                                xTarget.showAdvancedNotification(xPlayer.job.label, 'Facture',
                                ('Vous avez ~r~recu~w~ une facture de ~r~%s$'):format(ESX.Math.GroupDigits(amount)), 'CHAR_BANK_FLEECA', 9)
                                xPlayer.showNotification('La personne a ~o~accepté~w~ la facture')
                            end)
                        end
                    end)
                end
            end
        end)
    else
        -- Refus de la facture
        xTarget.showNotification(('Vous avez ~r~refusé~w~ une facture de ~r~%s$'):format(ESX.Math.GroupDigits(amount)))
        xPlayer.showNotification('La personne a ~r~refusé~w~ la facture')
    end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier},
	function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.query('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier},
		function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.single('SELECT sender, target_type, target, amount, label, identifier FROM billing WHERE id = ?', {billId},
    function(result)
        if not result then return cb() end
        
        local amount = result.amount
        local xTarget = ESX.GetPlayerFromIdentifier(result.sender)

        -- Vérifier si c'est une amende mecano
        local isMecanoFine = string.find(result.label, 'Amende Mécano: ') or string.find(result.label, 'Amende mecano: ')
        local reason = isMecanoFine and string.gsub(result.label, 'Amende [Mm]écano: ', '') or nil

        if result.target_type == 'player' then
            if xTarget then
                if xPlayer.getMoney() >= amount then
                    xPlayer.removeMoney(amount, "Bill Paid")
                    xTarget.addMoney(amount, "Paid bill")
                    MySQL.update('DELETE FROM billing WHERE id = ?', {billId})
                    
                    -- Mettre à jour mecano_fines si c'est une amende mecano
                    if isMecanoFine then
                        MySQL.update(
                            'UPDATE mecano_fines SET paid = 1 WHERE identifier = ? AND reason = ? AND amount = ? AND paid = 0 LIMIT 1',
                            {xPlayer.identifier, reason, amount},
                            function(rowsChanged)
                                if rowsChanged > 0 then
                                    TriggerClientEvent('mecano:refreshBossMenu', -1)
                                end
                            end)
                    end
                    
                    xPlayer.showNotification(TranslateCap('paid_invoice', ESX.Math.GroupDigits(amount)))
                    xTarget.showNotification(TranslateCap('received_payment', ESX.Math.GroupDigits(amount)))
                    cb()
                elseif xPlayer.getAccount('bank').money >= amount then
                    xPlayer.removeAccountMoney('bank', amount, "Bill Paid")
                    xTarget.addAccountMoney('bank', amount, "Paid bill")
                    MySQL.update('DELETE FROM billing WHERE id = ?', {billId})
                    
                    if isMecanoFine then
                        MySQL.update(
                            'UPDATE mecano_fines SET paid = 1 WHERE identifier = ? AND reason = ? AND amount = ? AND paid = 0 LIMIT 1',
                            {xPlayer.identifier, reason, amount},
                            function(rowsChanged)
                                if rowsChanged > 0 then
                                    TriggerClientEvent('mecano:refreshBossMenu', -1)
                                end
                            end)
                    end
                    
                    xPlayer.showNotification(TranslateCap('paid_invoice', ESX.Math.GroupDigits(amount)))
                    xTarget.showNotification(TranslateCap('received_payment', ESX.Math.GroupDigits(amount)))
                    cb()
                else
                    xTarget.showNotification(TranslateCap('target_no_money'))
                    xPlayer.showNotification(TranslateCap('no_money'))
                    cb()
                end
            else
                xPlayer.showNotification(TranslateCap('player_not_online'))
                cb()
            end
        else
            TriggerEvent('esx_addonaccount:getSharedAccount', result.target, function(account)
                if xPlayer.getMoney() >= amount then
                    xPlayer.removeMoney(amount, "Bill Paid")
                    account.addMoney(amount)
                    MySQL.update('DELETE FROM billing WHERE id = ?', {billId})
                    
                    if isMecanoFine then
                        MySQL.update(
                            'UPDATE mecano_fines SET paid = 1 WHERE identifier = ? AND reason = ? AND amount = ? AND paid = 0 LIMIT 1',
                            {xPlayer.identifier, reason, amount},
                            function(rowsChanged)
                                if rowsChanged > 0 then
                                    TriggerClientEvent('mecano:refreshBossMenu', -1)
                                end
                            end)
                    end
                    
                    xPlayer.showNotification(TranslateCap('paid_invoice', ESX.Math.GroupDigits(amount)))
                    if xTarget then
                        xTarget.showNotification(TranslateCap('received_payment', ESX.Math.GroupDigits(amount)))
                    end
                    cb()
                elseif xPlayer.getAccount('bank').money >= amount then
                    xPlayer.removeAccountMoney('bank', amount, "Bill Paid")
                    account.addMoney(amount)
                    MySQL.update('DELETE FROM billing WHERE id = ?', {billId})
                    
                    if isMecanoFine then
                        MySQL.update(
                            'UPDATE mecano_fines SET paid = 1 WHERE identifier = ? AND reason = ? AND amount = ? AND paid = 0 LIMIT 1',
                            {xPlayer.identifier, reason, amount},
                            function(rowsChanged)
                                if rowsChanged > 0 then
                                    TriggerClientEvent('mecano:refreshBossMenu', -1)
                                end
                            end)
                    end
                    
                    xPlayer.showNotification(TranslateCap('paid_invoice', ESX.Math.GroupDigits(amount)))
                    if xTarget then
                        xTarget.showNotification(TranslateCap('received_payment', ESX.Math.GroupDigits(amount)))
                    end
                    cb()
                else
                    if xTarget then
                        xTarget.showNotification(TranslateCap('target_no_money'))
                    end
                    xPlayer.showNotification(TranslateCap('no_money'))
                    cb()
                end
            end)
        end
    end)
end)

function UpdateAmendeStatus(billId)
    MySQL.Async.fetchAll('SELECT * FROM amendes WHERE bill_id = ?', {billId}, function(result)
        if result[1] then
            -- Si une amende est liée à cette facture, mettre à jour son statut
            MySQL.Async.execute('UPDATE amendes SET status = ? WHERE bill_id = ?', {'payee', billId})
            
            -- Notification optionnelle pour l'agent qui a émis l'amende
            local officerIdentifier = result[1].officer_identifier
            if officerIdentifier then
                local xOfficer = ESX.GetPlayerFromIdentifier(officerIdentifier)
                if xOfficer then
                    xOfficer.showNotification('Une amende que vous avez émise a été payée')
                end
            end
        end
    end)
end

ESX.RegisterServerCallback('esx_billing:abortBill', function (source, cb, billId)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.single('SELECT target FROM billing WHERE id = ?', {billId}, 
    function (result)
        if result then
            if xPlayer.getJob().name == result.target then
                MySQL.update.await('DELETE FROM billing WHERE id = ?', {billId})
                cb()
            else
                --Cheat?
            end
        end
    end)
end)