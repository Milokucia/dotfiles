-- nvim-lspconfig's plugin/lspconfig.lua only defines :LspInfo/:LspStart/
-- :LspRestart/:LspStop if `exists(':lsp')` is false. mason-lspconfig now ships
-- its own :LspInstall/:LspUninstall commands, which Vim's command-name prefix
-- matching treats as a match for "lsp", so the guard trips and none of those
-- commands ever get defined. Define our own so they're always available.

local function client_names(opts)
  return vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients(opts))
end

local function complete_client(arg)
  return vim.tbl_filter(function(name)
    return name:sub(1, #arg) == arg
  end, client_names())
end

vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", {
  desc = "Alias to :checkhealth vim.lsp",
})

vim.api.nvim_create_user_command("LspStart", function(info)
  local servers = info.fargs
  if #servers == 0 then
    local ft = vim.bo.filetype
    for name in pairs(vim.lsp.config._configs or {}) do
      local filetypes = vim.lsp.config[name].filetypes
      if filetypes and vim.tbl_contains(filetypes, ft) then
        table.insert(servers, name)
      end
    end
  end
  vim.lsp.enable(servers)
end, {
  desc = "Enable and launch a language server",
  nargs = "?",
})

vim.api.nvim_create_user_command("LspStop", function(info)
  local names = #info.fargs > 0 and info.fargs or client_names({ bufnr = 0 })
  for _, name in ipairs(names) do
    vim.lsp.enable(name, false)
    vim.iter(vim.lsp.get_clients({ name = name })):each(function(c)
      c:stop(true)
    end)
  end
end, {
  desc = "Disable and stop the given client(s)",
  nargs = "?",
  complete = complete_client,
})

vim.api.nvim_create_user_command("LspRestart", function(info)
  local names = #info.fargs > 0 and info.fargs or client_names()
  for _, name in ipairs(names) do
    vim.lsp.enable(name, false)
    vim.iter(vim.lsp.get_clients({ name = name })):each(function(c)
      c:stop(true)
    end)
  end
  vim.defer_fn(function()
    for _, name in ipairs(names) do
      vim.lsp.enable(name)
    end
  end, 500)
end, {
  desc = "Restart the given client(s)",
  nargs = "?",
  complete = complete_client,
})
