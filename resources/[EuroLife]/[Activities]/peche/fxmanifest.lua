fx_version 'cerulean'
game 'gta5'

author 'Ton Nom'
description 'Système de pêche pour ESX'
version '1.0.0'

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    'config.lua'
}

dependencies {
    'es_extended'
}

shared_script '@es_extended/imports.lua'