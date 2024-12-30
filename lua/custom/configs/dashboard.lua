-- ~/.config/nvim/lua/custom/dashboard.lua

local db = require('dashboard')

-- Set a custom header
db.custom_header = {
  'Welcome to My Neovim Setup!',
  'Enjoy your coding session!',
}

-- Set custom center menu
db.custom_center = {
  { icon = '  ',
    desc = 'Recently opened files                   ',
    action = 'Telescope oldfiles',
    shortcut = 'SPC f r' },
  { icon = '  ',
    desc = 'Find File                               ',
    action = 'Telescope find_files',
    shortcut = 'SPC f f' },
  { icon = '  ',
    desc = 'File Browser                            ',
    action = 'Telescope file_browser',
    shortcut = 'SPC f b' },
  { icon = '  ',
    desc = 'Find word                               ',
    action = 'Telescope live_grep',
    shortcut = 'SPC f w' },
}