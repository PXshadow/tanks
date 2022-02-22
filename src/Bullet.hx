import h2d.SpriteBatch.BatchElement;
import h2d.Tile;

class Bullet extends BatchElement {
	public var vx:Float = 0;
	public var vy:Float = 0;
	public var delta:Int = 0;

	public function new(tank:Tank, t:Tile) {
		super(t);
		rotation = tank.turret[0].rotation;
		scaleX = 0.8;
		x = tank.x + Math.cos(rotation) * 200;
		y = tank.y - 20 + Math.sin(rotation) * 200;
		vx = Math.cos(rotation) * 20;
		vy = Math.sin(rotation) * 20;
	}

	public function setRotation() {
		rotation = Math.atan2(vy, vx);
	}
}
