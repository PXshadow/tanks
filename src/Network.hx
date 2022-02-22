import haxe.Json;
import peerjs.DataConnection;

var peer:DataConnection = null;
var id:String = "";
private var l = 0.2;
function open() {}

function data(data:String) {
	final obj = Json.parse(data);
	switch obj.id {
		case "t": // tank
			final data:TankMessage = obj;
			final opponent = Game.tanks[1];
			opponent.set = data;
		case "b": // bullets
	}
}

function error(error:String) {}

function send(obj:Dynamic) {
	if (peer == null)
		return;
	peer.send(Json.stringify(obj));
	// haxe.Timer.delay(() -> peer.send(Json.stringify(obj)), 200);
}

var wait = 0;

function tank(tank:Tank) {
	// if (wait++ < 4)
	//	return;
	wait = 0;
	final data:TankMessage = {
		id: "t",
		x: tank.x,
		y: tank.y,
		vx: tank.vx,
		vy: tank.vy,
		rotation: tank.rotation,
		turretRotation: tank.turretRotation,
	};
	send(data);
}

typedef TankMessage = {
	id:String,
	x:Float,
	y:Float,
	vx:Float,
	vy:Float,
	rotation:Float,
	turretRotation:Float,
}
