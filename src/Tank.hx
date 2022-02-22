import Network.TankMessage;
import differ.math.Vector;
import differ.shapes.Polygon;
import h2d.Scene;
import h2d.SpriteBatch.BatchElement;
import h2d.SpriteBatch;
import hxd.Key;
import hxd.Math;

class Tank {
	var batch:SpriteBatch = null;
	var s2d:Scene = null;
	var trailIndex:Int = 0;
	var trails:Array<BatchElement> = [];
	var bullets:Array<Bullet> = [];

	public var set:TankMessage = null;

	public var vx:Float = 0;
	public var vy:Float = 0;

	public var turret:Array<BatchElement> = [];
	public var body:Array<BatchElement> = [];
	public var tracks:Array<BatchElement> = [];
	public var shadow:BatchElement = null;

	public var recordX = new Ring<Float>(100);
	public var recordY = new Ring<Float>(100);

	public var bodyCollision = Polygon.rectangle(90, 60, 180, 120);
	public var master:Bool = false;

	// public var turretCollision = new Polygon(30,20,[new Vector(-30,-20),new Vector()])
	public var controls:Controls = null;

	@:isVar public var turretRotation(get, set):Float = 0;

	function get_turretRotation():Float
		return turretRotation;

	function set_turretRotation(value:Float):Float {
		turretRotation = value;
		for (e in turret)
			e.rotation = turretRotation;
		return turretRotation;
	}

	@:isVar public var rotation(get, set):Float = 0;

	function get_rotation():Float {
		return rotation;
	}

	function set_rotation(value:Float):Float {
		rotation = value;
		for (e in body.concat(tracks))
			e.rotation = rotation;
		shadow.rotation = rotation;
		bodyCollision.rotation = Math.radToDeg(rotation);
		return rotation;
	}

	@:isVar public var x(get, set):Float = 0;

	function get_x():Float {
		return x;
	}

	function set_x(value:Float):Float {
		final diff = value - x;
		for (e in getElements())
			e.x += diff;
		shadow.x += diff;
		bodyCollision.x += diff;
		return x = value;
	}

	@:isVar public var y(get, set):Float = 0;

	function get_y():Float {
		return y;
	}

	function set_y(value:Float):Float {
		final diff = value - y;
		for (e in getElements())
			e.y += diff;
		shadow.y += diff;
		bodyCollision.y += diff;
		return y = value;
	}

	public function new(s2d:Scene, batch:SpriteBatch, type:Int = 0) {
		master = type == 0;
		this.s2d = s2d;
		this.batch = batch;
		final tileWidth = 300;
		final tileHeight = 120;
		shadow = new BatchElement(batch.tile.sub(601, 121, tileWidth, tileHeight, -90, -60));
		shadow.alpha = 0.2;
		shadow.r = shadow.g = shadow.b = 0;
		shadow.x += -8;
		shadow.y += 16;

		var offset = 0;
		var offsetX = 0;
		for (i in 0...3) {
			final count = switch i {
				case 0: // tracks
					20;
				case 1: // body
					20;
				case 2: // turret
					6;
				default:
					throw "unknown index";
			}
			for (layer in 0...count) {
				final element = new BatchElement(batch.tile.sub(type * tileWidth + type, i * tileHeight + i, tileWidth, tileHeight, -90, -60));
				element.x = offsetX;
				element.y = offset + (i == 2 ? 13 : 0);
				offset--;
				switch i {
					case 0: // tracks
						tracks.push(element);
					case 1: // body
						body.push(element);
					case 2: // turret
						turret.push(element);
				}
			}
		}
	}

	final speed = 250;
	var turning = false;
	var moving = false;

	public function update(dt:Float) {
		// record positions
		recordX.push(x);
		recordY.push(y);

		if (controls != null) {
			vx = 0;
			vy = 0;
			moving = false;
			turning = false;
			for (key in controls.forward)
				if (Key.isDown(key)) {
					vx = Math.cos(rotation) * speed * dt;
					vy = Math.sin(rotation) * speed * dt;
					moving = true;
					break;
				}
			for (key in controls.back)
				if (Key.isDown(key)) {
					vx = -Math.cos(rotation) * speed * 0.70 * dt;
					vy = -Math.sin(rotation) * speed * 0.70 * dt;
					moving = true;
					break;
				}

			for (key in controls.left)
				if (Key.isDown(key)) {
					rotation += -1 * dt * (moving ? 1.2 : 1);
					turning = true;
					break;
				}
			for (key in controls.right)
				if (Key.isDown(key)) {
					rotation += 1 * dt * (moving ? 1.2 : 1);
					turning = true;
					break;
				}
			/*for (key in controls.fire) {
				if (Key.isPressed(key)) {
					final bullet = new Bullet(this, batch.tile.sub(120, 0, 60, 40).center());
					bullets.push(bullet);
					batch.add(bullet);
				}
			}*/
			turretRotation = Math.angleMove(turretRotation, Math.atan2(s2d.mouseY - y, s2d.mouseX - x), dt * 1.2 * (moving ? 1 : 1.5));
		}
		if (vx != 0 || vy != 0)
			addTrail();
		if (trails.length > 500) {
			for (trail in trails.slice(0, trails.length - 500)) {
				trail.alpha += -0.001;
				if (trail.alpha <= 0.01)
					trail.remove();
			}
		}

		if (set != null) {
			final k = 0.4;
			x = Math.lerpTime(x, set.x, k, dt);
			y = Math.lerpTime(y, set.y, k, dt);
			vx = set.vx * 2;
			vy = set.vy * 2;
			rotation = Math.angleLerp(rotation, set.rotation, k);
			turretRotation = Math.angleLerp(turretRotation, set.turretRotation, k);
			trace(set);
		}

		x += vx;
		y += vy;

		if (master)
			Network.tank(this);

		for (bullet in bullets) {
			bullet.x += bullet.vx;
			bullet.y += bullet.vy;
			if (bullet.x <= 0) {
				bullet.vx *= -1;
				bullet.setRotation();
			}
			if (bullet.x >= s2d.width) {
				bullet.vx *= -1;
				bullet.setRotation();
			}
			if (bullet.y <= 0) {
				bullet.vy *= -1;
				bullet.setRotation();
			}
			if (bullet.y >= s2d.height) {
				bullet.vy *= -1;
				bullet.setRotation();
			}
			if (bullet.delta++ > 60 * 2) {
				bullet.remove();
				bullets.remove(bullet);
			}
		}
	}

	function addTrail() {
		if (trailIndex++ < 15)
			return;
		trailIndex = 0;
		final trailTop = new BatchElement(batch.tile.sub(0, 0, 180, 40).center());
		final trailBottom = new BatchElement(batch.tile.sub(0, 0, 180, 40).center());
		trailTop.scaleX = trailBottom.scaleX = 0.1;
		trailTop.x = x + Math.sin(rotation) * 40;
		trailTop.y = y + Math.cos(rotation) * -40;
		trailBottom.x = x + Math.sin(rotation) * -40;
		trailBottom.y = y + Math.cos(rotation) * 40;
		trailTop.alpha = trailBottom.alpha = 0.2;
		trailTop.rotation = trailBottom.rotation = rotation;
		batch.add(trailTop, true);
		batch.add(trailBottom, true);
		trails.push(trailTop);
		trails.push(trailBottom);
	}

	public function getElements():Array<BatchElement>
		return tracks.concat(body).concat(turret);
}
