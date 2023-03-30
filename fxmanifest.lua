fx_version 'cerulean'
game 'gta5'
description 'ESX Security Plus - Become a security guard of LS!'
author 'Abel Gaming'
version '1.2 DEVELOPMENT'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}

ui_page 'nui/index.html'
files { 
'nui/index.html', 
'nui/index.css', 
'nui/index.js'
}

escrow_ignore {
	'config.lua'
}

lua54 'yes'
