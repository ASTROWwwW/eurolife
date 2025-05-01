fx_version 'cerulean'
games { 'gta5' }

author 'RedTwo_'
description 'Gym script'
version '1.0.0'

-- What to run
client_scripts {
	'config.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

dependencies {
	'es_extended',
    'foltone_hud_nemo' -- Pour les notifications
}

--[[server_scripts {
	'config.lua',
	'server.lua',
}--]]