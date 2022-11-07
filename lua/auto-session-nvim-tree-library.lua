local Lib = {
  logger = {},
  conf = {
    log_level = false,
  },
}
--
-- don't autorestore if there are open buffers (indicating auto save session failed)
function Lib.has_open_buffers()
  local result = false
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufloaded(bufnr) then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname ~= "" then
        if vim.fn.bufwinnr(bufnr) ~= -1 then
          if result then
            result = true
            Lib.logger.debug("There are buffer(s) present: ")
          end
          Lib.logger.debug("  " .. bufname)
        end
      end
    end
  end
  return result
end

-- return type of file tree explorer or false if not a file tree explorers
function Lib.tree_buf_type(bufnr)
  if bufnr == nil then
    bufnr = 0
  end
  if vim.fn.bufexists(bufnr) then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    if filename:match "^NvimTree_[0-9]+$" then
      if vim.bo[bufnr].filetype == "NvimTree" then
        return "nvimtree"
      elseif vim.fn.filereadable(bufname) == 0 then
        return "nvimtree"
      end
    elseif filename:match "^NERD_tree_[0-9]+$" then
      if vim.bo[bufnr].filetype == "nerdtree" then
        return "nerdtree"
      elseif vim.fn.filereadable(bufname) == 0 then
        return "nerdtree"
      end
    end
  end
  return false
end

function Lib.setup(config)
  Lib.conf = vim.tbl_deep_extend("force", Lib.conf, config or {})
end

function Lib.logger.debug(...)
  if Lib.conf.log_level == "debug" then
    vim.notify(vim.fn.join({ "debug: ", tostring(...) }, " "), vim.log.levels.DEBUG)
  end
end

function Lib.logger.info(...)
  local valid_values = { "info", "debug" }
  if vim.tbl_contains(valid_values, Lib.conf.log_level) then
    vim.notify(vim.fn.join({ "info: ", tostring(...) }, " "), vim.log.levels.INFO)
  end
end

function Lib.logger.error(...)
  vim.notify(vim.fn.join({ "error: ", tostring(...) }, " "), vim.log.levels.ERROR)
end

return Lib
