-- FX Information
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

-- Manifest
ui_page 'html/index.html'

client_scripts {
	'client/main.lua',
	'client/targets.lua',
	'client/pulses/*.lua'
}

server_scripts {
	'server/*.lua'
}

shared_scripts {
	'shared/*.lua'
}

files {
	'html/**',
	'web/**',
}