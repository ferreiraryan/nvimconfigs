-- Terminal integrado flutuante
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    open_mapping = [[<C-/>]],
    direction = 'float',
    float_opts = {
      border = 'curved',
    },
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
  },
}