local colors = {
  pink    = '#A06994',
  yellow  = '#FDED02',
  grey    = '#808080',
  light   = '#D8DEE9',
  dark    = '#000000',
  green   = '#59CE8F',
  blue    = '#01A0E4',
  orange  = '#D08770',
  red     = '#FD0B00',
  jet_black = '#28282B',
  function_color = '#8FBCBB',
}

local theme = {
  normal = {
    a = { fg = colors.dark, bg = colors.yellow, gui = 'bold' },
    b = { fg = colors.light, bg = colors.jet_black },
    c = { fg = colors.light, bg = colors.jet_black },
  },

  insert = {
    a = { fg = colors.dark, bg = colors.green, gui = 'bold' },
    b = { fg = colors.light, bg = colors.grey },
    c = { fg = colors.light, bg = colors.dark },
  },

  visual = {
    a = { fg = colors.dark, bg = colors.pink, gui = 'bold' },
    b = { fg = colors.light, bg = colors.grey },
    c = { fg = colors.light, bg = colors.dark },
  },

  replace = {
    a = { fg = colors.dark, bg = colors.red, gui = 'bold' },
    b = { fg = colors.light, bg = colors.grey },
    c = { fg = colors.light, bg = colors.dark },
  },

  command = {
    a = { fg = colors.dark, bg = colors.blue, gui = 'bold' },
    b = { fg = colors.light, bg = colors.grey },
    c = { fg = colors.light, bg = colors.dark },
  },

  inactive = {
    a = { fg = colors.grey, bg = colors.jet_black, gui = 'italic' },
    b = { fg = colors.grey, bg = colors.jet_black },
    c = { fg = colors.grey, bg = colors.jet_black },
  },
}

return theme
