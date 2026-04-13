local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("c", {
  s("main", {
    t({ "#include <stdio.h>", "", "" }),
    t({ "int main()", "{", "    " }),
    i(0), -- Cursor para aqui após o trigger
    t({ "", "", "    return 0;", "}" }),
  }),
})
