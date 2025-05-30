local options
if (vim.api.nvim_exec('echo argc()', true) == "0")
then
  Headers = {
   {
     [[=================     ===============     ===============   ========  ========]],
     [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
     [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
     [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
     [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
     [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
     [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
     [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
     [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
     [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
     [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
     [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
     [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
     [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
     [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
     [[||.=='    _-'                                                     `' |  /==.||]],
     [[=='    _-'                        N E O V I M                         \/   `==]],
     [[\   _-'                                                                `-_   /]],
     [[ `''                                                                      ``' ]],
   },
  }

  local header = {
    type = "text",
    val = Headers[1],
    opts = {
      position = "center",
      hl       = "Error"
    }
  }

  local footer = {
    type = "text",
    val = {
        "In the first age, in the first battle, when the shadows first lengthened, one stood.",
        "He chose the path of perpetual torment.",
        "In his ravenous hatred he found no peace, and with boiling blood he scoured the Umbral Plains,",
        "seeking vengeance against the dark lords who had wronged him.",
        "And those that tasted the bite of his sword named him...",
        "The Doom Slayer."
    },
    hl  = "Normal",
    opts = {
      position = "center",
      hl       = "Whitespace",
    }
  }

  local ol = { -- occupied lines
    icon            = #header.val,
    message         = #footer.val,
    length_buttons  = 0,
    neovim_lines    = 2,
    padding_between = 3,
  }

  local left_terminal_value = vim.api.nvim_get_option('lines') - (ol.length_buttons + ol.message + ol.padding_between + ol.icon + ol.neovim_lines)

  if (left_terminal_value >= 0) then

    local top_padding         = math.floor(left_terminal_value / 2)
    local bottom_padding      = left_terminal_value - top_padding

    options = {
      layout = {
        { type = "padding", val = top_padding },
        header,
        { type = "padding", val = ol.padding_between },
        footer,
        { type = "padding", val = bottom_padding },
      },
      opts = {
        margin = 5
      },
    }

  end
end

return options
