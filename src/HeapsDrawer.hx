import differ.shapes.Shape;
import h2d.Graphics;

class HeapsDrawer extends differ.ShapeDrawer {
	var g:Graphics = null;

	public function new(g:Graphics) {
		this.g = g;
		super();
		g.lineStyle(10);
	}

	override function drawLine(p0x:Float, p0y:Float, p1x:Float, p1y:Float, ?startPoint:Bool = true) {
		// super.drawLine(p0x, p0y, p1x, p1y, startPoint);
		// g.clear();
		// g.moveTo(p0x, p0y);
		// g.lineTo(p1x, p1y);
	}
}
