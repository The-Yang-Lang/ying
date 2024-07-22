from parsita import lit, ParserContext


class KeywordParser(ParserContext, whitespace=r"\s*"):
    kw_import = lit("import")
    kw_from = lit("from")
    kw_export = lit("export")
    kw_struct = lit("struct")
    kw_class = lit("class")
    kw_type = lit("type")
    kw_as = lit("as")
    kw_extends = lit("extends")
    kw_implements = lit("implements")
