local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cpp", {
  s("main", {
    t({ "#include <iostream>", "", "" }),
    t({ "int main() {", "    " }),
    i(0),
    t({ "", "    return 0;", "}" }),
  }),
})
