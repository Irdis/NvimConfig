local options = { too_small = true }
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

  local function is_dot(lines, r, c)
    return lines[r] ~= nil and lines[r]:sub(c, c) == '.'
  end

  -- second frame of the logo: the checkerboard of dots inside the letters shifts by one column.
  -- A run of dots and spaces is part of the checkerboard when dots and single spaces alternate
  -- and it doesn't touch "=" (so ".===' `===." stays put); a run with a lone dot also needs
  -- the checkerboard to continue diagonally from it (so "|. /|" stays put)
  local function shift_dots(lines)
    local res = {}
    for r, line in ipairs(lines) do
      local chars = {}
      for i = 1, #line do chars[i] = line:sub(i, i) end
      for s, run, e in line:gmatch('()([ %.]+)()') do
        e = e - 1
        local edges = line:sub(s - 1, s - 1) .. line:sub(e + 1, e + 1)
        local checker = #run >= 2 and run:find('%.') and not run:find('  ') and not run:find('%.%.')
          and not edges:find('=')
        if checker and not run:find('%. %.') then
          local c = s + run:find('%.') - 1
          checker = is_dot(lines, r - 1, c - 1) or is_dot(lines, r - 1, c + 1)
            or is_dot(lines, r + 1, c - 1) or is_dot(lines, r + 1, c + 1)
        end
        if checker then
          for i = s, e do chars[i] = chars[i] == '.' and ' ' or '.' end
        end
      end
      res[r] = table.concat(chars)
    end
    return res
  end

  local frames = { Headers[1], shift_dots(Headers[1]) }

  local header = {
    type = "text",
    val = frames[1],
    opts = {
      position = "center",
      hl       = "Error"
    }
  }

  -- equalizer above the logo for the doom start; lua/doom_eq.lua holds bar levels analysed from the track
  local eq_data = vim.g.doom and require('doom_eq')
  local eq_parts = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  local eq_rows = 5
  local eq_bands = 20

  -- levels is a frame from doom_eq (one char per bar), nil draws the flat baseline
  local function render_eq(levels)
    local rows = {}
    for r = 1, eq_rows do
      local cells = {}
      for b = 1, eq_bands do
        local level = levels and levels:byte(b) - 48 or 0
        local fill = math.max(level, r == eq_rows and 1 or 0) - (eq_rows - r) * #eq_parts
        cells[b] = fill <= 0 and ' ' or eq_parts[math.min(fill, #eq_parts)]
      end
      rows[r] = table.concat(cells, ' ')
    end
    return rows
  end

  local equalizer = eq_data and {
    type = "text",
    val = render_eq(),
    opts = {
      position = "center",
      hl       = "Error"
    }
  }

  local uv = vim.uv or vim.loop
  local timer
  local frame = 1
  local eq_timer

  local function stop_eq()
    if eq_timer then
      eq_timer:stop()
      eq_timer:close()
      eq_timer = nil
    end
  end

  -- picks the frame by time since the track started, so the bars can't drift from the music
  local function start_eq()
    stop_eq()
    if not equalizer then return end
    local started = uv.hrtime()
    eq_timer = uv.new_timer()
    eq_timer:start(0, math.floor(1000 / eq_data.fps), vim.schedule_wrap(function()
      if not eq_timer then return end
      local levels = eq_data.frames[math.floor((uv.hrtime() - started) / 1e9 * eq_data.fps) + 1]
      if not levels then stop_eq() end
      equalizer.val = render_eq(levels)
      pcall(function() require('alpha').redraw() end)
    end))
  end

  local function stop_timer()
    if timer then
      timer:stop()
      timer:close()
      timer = nil
    end
  end

  local function start_timer(delay)
    stop_timer()
    timer = uv.new_timer()
    timer:start(delay or 200, 200, vim.schedule_wrap(function()
      if not timer then return end
      frame = frame % #frames + 1
      header.val = frames[frame]
      pcall(function() require('alpha').redraw() end)
    end))
  end

  -- the tracks play one after another; the logo starts moving with the last one
  local is_windows = vim.fn.has('win32') == 1
  local sep = is_windows and '\\' or '/'
  local music_dir = vim.fn.expand('~') .. sep .. 'Music' .. sep
  local tracks = {
    music_dir .. '02. Rip & Tear.mp3',
  }

  -- both player scripts print the track number as each track starts playing
  local windows_script = [[
Add-Type -AssemblyName presentationCore
$i = 0
foreach ($track in $env:NVIM_TRACKS -split '\|') {
  $i++
  $p = New-Object System.Windows.Media.MediaPlayer
  $p.Open([uri]$track)
  $wait = 0
  while (-not $p.NaturalDuration.HasTimeSpan -and $wait -lt 250) { Start-Sleep -Milliseconds 20; $wait++ }
  if (-not $p.NaturalDuration.HasTimeSpan) { continue }
  $p.Play()
  [Console]::Out.WriteLine($i)
  [Console]::Out.Flush()
  Start-Sleep -Milliseconds $p.NaturalDuration.TimeSpan.TotalMilliseconds
  $p.Close()
}
]]

  -- the player runs in the background so that jobstop's SIGTERM can be passed on to it
  local unix_script = [[
trap 'kill $pid 2>/dev/null; exit' TERM HUP INT
i=0
for track in "$@"; do
  i=$((i + 1))
  echo $i
  $NVIM_PLAYER "$track" </dev/null >/dev/null 2>&1 &
  pid=$!
  wait $pid
done
]]

  local unix_players = {
    'mpv --no-video --really-quiet',
    'ffplay -nodisp -autoexit -loglevel quiet',
    'mpg123 -q',
    'cvlc --play-and-exit -q',
  }

  local function player_job()
    if is_windows then
      return { 'powershell.exe', '-NoProfile', '-NonInteractive', '-Command', windows_script },
        { NVIM_TRACKS = table.concat(tracks, '|') }
    end
    for _, player in ipairs(unix_players) do
      if vim.fn.executable(player:match('^%S+')) == 1 then
        return vim.list_extend({ 'sh', '-c', unix_script, 'sh' }, tracks), { NVIM_PLAYER = player }
      end
    end
  end

  local music_job

  local function stop_music()
    if music_job then
      vim.fn.jobstop(music_job)
      music_job = nil
    end
  end

  local function start_music()
    stop_music()
    local cmd, env = player_job()
    for _, track in ipairs(tracks) do
      if vim.fn.filereadable(track) == 0 then
        cmd = nil
      end
    end
    if not cmd then
      start_timer()
      return
    end
    music_job = vim.fn.jobstart(cmd, {
      env = env,
      on_stdout = function(_, data)
        for _, line in ipairs(data) do
          -- the equalizer follows the last track, the logo waits 9 seconds into it before it starts moving
          if vim.trim(line) == tostring(#tracks) then
            start_eq()
            start_timer(9000)
          end
        end
      end,
      on_exit = function() music_job = nil end,
    })
    if music_job <= 0 then
      music_job = nil
      start_timer()
    end
  end

  -- music and animation only with `nvim --cmd "let g:doom = 1"`, otherwise the logo is static
  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
      if vim.g.doom then
        start_music()
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaClosed",
    callback = function()
      stop_timer()
      stop_eq()
      stop_music()
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = stop_music,
  })

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
    opts = {
      position = "center",
      hl       = "Normal",
    }
  }

  local ol = { -- occupied lines
    icon            = #header.val + (equalizer and #equalizer.val + 1 or 0),
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

    if equalizer then
      table.insert(options.layout, 2, equalizer)
      table.insert(options.layout, 3, { type = "padding", val = 1 })
    end

  end
end

return options
