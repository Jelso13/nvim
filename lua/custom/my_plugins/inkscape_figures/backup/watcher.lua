
local Path = require('plenary.path')
local uv   = vim.loop
local roots = require('custom.my_plugins.inkscape_figures.roots')
local util  = require('custom.my_plugins.inkscape_figures.util')

local M = {}

-- Debounce to avoid double-firing
local last_emit = {}

local function on_change(err, fn)
  if err then
    vim.schedule(function() error(err) end)
    return
  end

  -- only care about .svg closes
  if fn:match('%.svg$') then
    -- debounce by filepath
    if last_emit[fn] and (uv.now() - last_emit[fn] < 100) then
      return
    end
    last_emit[fn] = uv.now()

    util.recompile(fn)
  end
end

-- Start watchers for each root, and re-start if roots file changes
function M.start()
  local watchers = {}

  local function spawn()
    -- clear old
    for _, w in pairs(watchers) do w:close() end
    watchers = {}

    -- watch roots file for changes
    Path:new(roots.roots_file):watch(on_change)

    -- watch each root directory
    for _, dir in ipairs(roots.get_roots()) do
      Path:new(dir):watch(on_change)
    end
  end

  -- initial spawn
  spawn()

  -- also re-spawn every time roots is updated
  roots.on_update(spawn)
end

return M
