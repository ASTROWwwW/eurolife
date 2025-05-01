local isDead = false

function ShowBillsMenu()
	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
		if #bills > 0 then
			local elements = {
				{unselectable = true, icon = "fas fa-scroll", title = TranslateCap('invoices')}
			}

			for k,v in ipairs(bills) do
				elements[#elements+1] = {
					icon = "fas fa-scroll",
					title = ('%s - <span style="color:red;">%s</span>'):format(v.label, TranslateCap('invoices_item', ESX.Math.GroupDigits(v.amount))),
					billId = v.id
				}
			end

			ESX.OpenContext("right", elements, function(menu,element)
				ESX.TriggerServerCallback('esx_billing:payBill', function()
					ShowBillsMenu()
				end, element.billId)
			end)
		else
			ESX.ShowNotification(TranslateCap('no_invoices'))
		end
	end)
end

-- RegisterCommand('showbills', function()
-- 	if not isDead then
-- 		ShowBillsMenu()
-- 	end
-- end, false)

-- RegisterKeyMapping('showbills', TranslateCap('keymap_showbills'), 'keyboard', 'F7')

AddEventHandler('esx:onPlayerDeath', function() isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)

RegisterNetEvent('esx_billing:choiceBill')
AddEventHandler('esx_billing:choiceBill', function(sender, sharedAccountName, label, amount, labelSociety)
	local time = GetGameTimer()
	ESX.ShowAdvancedNotification(labelSociety, 'Facture',
	('Vous avez ~r~recu~w~ une facture de ~r~%s$~w~\nAppuyer sur ~g~A~w~ pour payer\nAppuyer sur ~o~H~w~ pour accepter\nApppuyer sur ~r~N~w~ pour refuser'):format(ESX.Math.GroupDigits(amount)), 'char_bank_maze', 25000)

	Citizen.CreateThread(function()
		while GetGameTimer() - time < 25000 do
			if IsControlJustPressed(1, 52) then 
				TriggerServerEvent('esx_billing:confirmBill', sender, sharedAccountName, label, amount, 'pay')
				return
			elseif IsControlJustPressed(1, 74) then
				TriggerServerEvent('esx_billing:confirmBill', sender, sharedAccountName, label, amount, 'accept')
				return
			elseif IsControlJustPressed(1, 306) then
				TriggerServerEvent('esx_billing:confirmBill', sender, sharedAccountName, label, amount, '')
				return
			end
			
			Wait(0)
		end

		TriggerServerEvent('esx_billing:confirmBill', sender, sharedAccountName, label, amount, '')
	end)
end)