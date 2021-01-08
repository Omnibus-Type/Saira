from fontParts.base.anchor import BaseAnchor
from babelfont import addUnderscoreProperty


@addUnderscoreProperty("name")
@addUnderscoreProperty("glyph")
@addUnderscoreProperty("color")
@addUnderscoreProperty("x")
@addUnderscoreProperty("y")
class Anchor(BaseAnchor):
    pass
