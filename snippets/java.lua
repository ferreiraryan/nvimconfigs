local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("java", {
  -- Boilerplate de uma nova classe
  s("class", {
    t("public class "),
    i(1, "NomeDaClasse"),
    t({ " {", "", "    " }),
    i(0), -- Posição final do cursor
    t({ "", "}" }),
  }),

  -- Método main (psvm)
  s("main", {
    t({ "public static void main(String[] args) {", "    " }),
    i(0),
    t({ "", "}" }),
  }),

  -- System.out.println (sout)
  s("sout", {
    t("System.out.println("),
    i(1),
    t(");"),
  }),
})
