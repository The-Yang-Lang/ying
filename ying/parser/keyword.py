from parsita import ParserContext, lit


class KeywordParser(ParserContext, whitespace=r"\s*"):
    kw_import = lit("import")
    kw_from = lit("from")
    kw_export = lit("export")
    kw_struct = lit("struct")
    kw_class = lit("class")
    kw_interface = lit("interface")
    kw_type = lit("type")
    kw_as = lit("as")
    kw_extends = lit("extends")
    kw_implements = lit("implements")
    kw_static = lit("static")
    kw_var = lit("var")
    kw_const = lit("const")
