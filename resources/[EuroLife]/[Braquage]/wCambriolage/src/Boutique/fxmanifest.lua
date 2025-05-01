fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Watson'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/images/*.png'
}

shared_script 'config.lua'

client_script 'client.lua'

server_script { 
    'server.lua',
    'serveur_Logs.lua',
    '@oxmysql/lib/MySQL.lua',
}

escrow_ignore {
    'serveur_Logs.lua',
    'config.lua',
    'html/index.html',
    'html/styles.css',
    'html/images/*.png'
}
