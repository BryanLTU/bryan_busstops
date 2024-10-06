fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ShiestyRP'
description 'Bus Stop Teleport Script'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib',
    'ox_target'
}
