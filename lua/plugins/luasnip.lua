return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",   -- Recomendado para estabilidade
  -- build = "make install_jsregexp", -- Opcional: para suporte a regex do VSCode
  config = function()
    local ls = require("luasnip")

    -- Configurações básicas
    ls.config.set_config({
      history = true,                                  -- Mantém o último snippet para poder voltar com shift-tab
      updateevents = "TextChanged,TextChangedI",       -- Atualiza enquanto digita
      enable_autosnippets = true,
    })

    -- CARREGAMENTO DOS SNIPPETS
    -- Isso aponta para a pasta onde você vai criar os arquivos por linguagem
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" }
    })

    -- Keymaps básicos para expansão e pulo
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })
  end,
}
