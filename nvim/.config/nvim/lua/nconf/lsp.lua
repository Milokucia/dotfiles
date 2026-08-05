-- Walk up from root_dir looking for a venv (.venv/venv/env), falling back
-- to $VIRTUAL_ENV if one is already activated, then to python3 on PATH.
local function find_python_path(root_dir)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  local dir = root_dir
  if not dir or dir == "" then
    dir = vim.fn.expand("%:p:h")
  end
  if not dir or dir == "" then
    dir = vim.fn.getcwd()
  end
  for _ = 1, 5 do
    for _, name in ipairs({ ".venv", "venv", "env" }) do
      local candidate = dir .. "/" .. name .. "/bin/python"
      if vim.fn.executable(candidate) == 1 then
        return candidate
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end

  return vim.fn.exepath("python3")
end

vim.lsp.config("pyright", {
  filetypes = { "python" },
  -- Redeclare lspconfig's defaults plus venv dirs, since a bare `uv venv`/
  -- `.venv` with no pyproject.toml otherwise leaves root_dir unresolved.
  root_markers = {
    ".git",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".venv",
    "venv",
  },
  before_init = function(_, config)
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = find_python_path(config.root_dir)
  end,
})

vim.lsp.config("clangd", {
  filetypes = { "c", "cpp" },
})

vim.lsp.config("lua_ls", {
  filetypes = { "lua" },
  settings = {
      Lua = {
          diagnostics = {
              globals = { "vim" },
          },
      },
  },
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})
