Config                  = {}

Config.MaxNameLength = 20 -- Max Name Length.
Config.LimitHeight = {120, 220} -- minimum and maximum
Config.LimitYear = {1900, 2010} -- minimum and maximum

Config.EnableBlur = true

Config.Multichars = false
Config.UseCustomSkinCreator = true -- If you want this you must set Config.Multichars = false 

-- @UseLatinAlphabetChecker: If you are using other alphabet than Latin, like Arabic, Japanese, Cyrillic etc. set false
Config.UseLatinAlphabetChecker = true

Config.UseNationalityOption = true

Config.DateFormat = 'dd/mm/yyyy'

Config.Notification = function(title, message, type)
	if type == "success" then
		--exports["foltone_hud_nemo"]:Notification(title, message, 4000, "#58c431", "fa-solid fa-fingerprint")
		TriggerEvent('esx:showNotification', message)
	elseif type == "error" then
		--exports["foltone_hud_nemo"]:Notification(title, message, 4000, "#c43131", "fa-solid fa-fingerprint")
		TriggerEvent('esx:showNotification', message)
	elseif type == "info" then
		--exports["foltone_hud_nemo"]:Notification(title, message, 4000, "#4287f5", "fa-solid fa-fingerprint")
		TriggerEvent('esx:showNotification', message)
	end
end

Config.Hud = {
    Enable = function()
        --exports['foltone_hud_nemo']:Display(true)
    end,
    Disable = function()
        --exports['foltone_hud_nemo']:Display(false)
    end
}

Config.Translate = {
	['cmd.opened_register'] = 'Successfully opened register menu for player %s',
	['cmd.help_id'] = 'id',
	['cmd.help_register'] = 'Open a register menu for a player',

	['register_notify'] = 'Register',
  	['register_success'] = 'Inscription réussie !',
  	['already_registered'] = 'Vous avez déjà enregistré un personnage.',
  	['invalid_firstname'] = 'Format non valide du <b>Prénom</b>.',
  	['invalid_lastname'] = 'Format non valide du <b>Nom de famille</b>.',
  	['invalid_sex'] = 'Format de <b>Sexe</b> non valide.',
  	['invalid_dob'] = 'Format <b>DOB</b> non valide.',
  	['invalid_height'] = 'Format de <b>Taille</b> non valide.',
}