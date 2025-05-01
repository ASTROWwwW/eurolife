fx_version 'adamant'
game 'gta5'
author 'Watson'

-----------------------------------------------------------
--                        Script                       --
-----------------------------------------------------------

lua54 'yes'

escrow_ignore {
	'config.lua',
  'wLocation.sql',
  'sv_callpolice.lua',
  'sv_logs.lua',
  'cl_uncryptefunction',
  'data/builder.json',
  'readme.txt',
  'fxmanifest.lua';
}

shared_script "config.lua"


client_scripts {
  "src/RMenu.lua",
  "src/menu/RageUI.lua",
  "src/menu/Menu.lua",
  "src/menu/MenuController.lua",
  "src/components/*.lua",
  "src/menu/elements/*.lua",
  "src/menu/items/*.lua",
  "src/menu/panels/*.lua",
  "src/menu/windows/*.lua",
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/EntityZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua',
}

client_scripts {
  'cl_*lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  --'@mysql-async/lib/MySQL.lua',
  'sv_*.lua',
  'jsonEditor.lua',
}


dependency '/assetpacks'