fx_version 'cerulean'

game 'gta5'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- change en to your language
    'config.lua',
}

dependencies { 'qb-target', 'qb-lock', 'boostinghack' }


client_scripts{
    'client/*.lua',
}

server_scripts{
    'server/*.lua',
}
