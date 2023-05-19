local Lib = require "auto-session-nvim-tree-library"

local M = {}

local function refresh_tree()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local tree_type = Lib.tree_buf_type(bufnr)
    if vim.api.nvim_buf_is_loaded(bufnr) then
      -- refresh file trees
      -- we only open the tree if it was open before
      if (tree_type == "nvimtree") then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        -- want no focus to avoid "'modifiable' is off" errors
        require('nvim-tree.api').tree.toggle(false, true)
      elseif (tree_type == "nerdtree") then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        vim.cmd 'NERDTreeOpen'
      end
    end
  end
end

---Add nvim tree hooks
---@param AutoSession table auto session instance
M.add_hooks = function(AutoSession)
  local conf = AutoSession.conf
  if conf.post_restore_cmds then
    table.insert(conf.post_restore_cmds, refresh_tree)
  else
    conf.post_restore_cmds = { refresh_tree }
  end
end

return M
