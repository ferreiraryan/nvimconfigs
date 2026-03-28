return {
  'CRAG666/code_runner.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'RunCode', 'RunFile', 'RunProject', 'RunClose' },
  keys = {
    { '<F5>', ':RunCode<CR>', desc = 'Run Code' },
  },
  config = function()
    require('code_runner').setup {
      focus = true,
      startinsert = true,
      term = {
        position = 'botright',
        size = 12,
      },
      filetype = {
        java = {
          -- Procura o gradlew subindo os diretórios e executa o run
          'f=$(find . -name gradlew -executable -print -quit); [ -n "$f" ] && $f run || (javac $fileName && java $fileNameWithoutExt)'
        },
        python = 'python3 -u',
        -- Ajuste para C++ com Raylib (flags de linkagem para Arch)
        cpp = {
          'cd $dir &&',
          'g++ $fileName -o $fileNameWithoutExt -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 &&',
          './$fileNameWithoutExt',
        },
        c = {
          'cd $dir &&',
          'gcc $fileName -o $fileNameWithoutExt -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 &&',
          './$fileNameWithoutExt',
        },
      },
    }
  end,
}
