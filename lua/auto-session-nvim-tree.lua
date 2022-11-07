local Lib = require "auto-session-nvim-tree-library"
local autocmds = require "auto-session-nvim-tree-autocmds"
local hooks = require "auto-session-nvim-tree-hooks"

----------- Setup ----------
local AutoSessionNvimTree = {
  conf = {},
}

-- Pass configs to Lib
Lib.conf = {
  log_level = AutoSessionNvimTree.conf.log_level,
}

---Setup function for AutoSession
---@param AutoSession table auto session instance
function AutoSessionNvimTree.setup(AutoSession)
  Lib.setup {
    log_level = AutoSession.conf.log_level,
  }

  autocmds.setup_autocmds(AutoSession)
  hooks.add_hooks(AutoSession)
end

return AutoSessionNvimTree
