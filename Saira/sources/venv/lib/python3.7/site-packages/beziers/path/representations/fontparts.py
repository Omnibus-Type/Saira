from beziers.line import Line
from beziers.cubicbezier import CubicBezier
from beziers.path import BezierPath
from beziers.path.representations.Nodelist import NodelistRepresentation, Node

class FontParts:
  @classmethod
  def fromFontpartsGlyph(klass, glyph):
    """Returns an *array of BezierPaths* from a FontParts glyph object."""
    paths = []
    for c in glyph.contours:
      path = BezierPath()
      path.closed = False
      nodeList = []
      for p in c.points:
        nodeList.append(Node(p.x,p.y,p.type))
      path.activeRepresentation = NodelistRepresentation(path, nodeList)
      if nodeList[0].point == nodeList[-1].point:
        path.closed = True
      paths.append(path)
    return paths

  @classmethod
  def drawToFontpartsGlyph(klass,glyph,path):
    pen = glyph.getPen()
    segs = path.asSegments()
    pen.moveTo((segs[0][0].x,segs[0][0].y))
    for seg in segs:
      if isinstance(seg, Line):
        pen.lineTo((seg[1].x,seg[1].y))
      elif isinstance(seg, CubicBezier):
        pen.curveTo(
          (seg[1].x,seg[1].y),
          (seg[2].x,seg[2].y),
          (seg[3].x,seg[3].y))
    if path.closed:
      pen.closePath()