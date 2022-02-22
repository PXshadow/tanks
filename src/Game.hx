import differ.Collision;
import differ.math.Vector;
import differ.shapes.Ray;
import h2d.Graphics;
import h2d.Interactive;
import h2d.Slider;
import h2d.SpriteBatch;
import h2d.Text;
import h2d.Tile;
import h3d.shader.Blur;
import hxd.BitmapData;
import hxd.Cursor.CustomCursor;
import hxd.Key;
import hxd.Math;
import hxd.res.DefaultFont;
import peerjs.DataConnection;

var s2d:h2d.Scene = null;
var engine:h3d.Engine = null;
var sevents:hxd.SceneEvents = null;
var batch:SpriteBatch = null;
var tank:Tank = null;
var tanks:Array<Tank> = [];
var cursor:Graphics = null;
var shapeDrawer:HeapsDrawer = null;
var peer:DataConnection = null;
var idText:Text = null;
var idButton:Interactive = null;
var connectButton:Interactive;
var client:Dynamic = js.Syntax.code('new Peer({
		host: "0.peerjs.com",
		port: 443,
		path: "/",
		pingInterval: 5000,
		config: {
			iceServers: [
				{
				  urls: "stun:openrelay.metered.ca:80"
				},
				{
				  urls: "turn:openrelay.metered.ca:80",
				  username: "openrelayproject",
				  credential: "openrelayproject"
				},
				{
				  urls: "turn:openrelay.metered.ca:443",
				  username: "openrelayproject",
				  credential: "openrelayproject"
				},
				{
				  urls: "turn:openrelay.metered.ca:443?transport=tcp",
				  username: "openrelayproject",
				  credential: "openrelayproject"
				}
			]
		},
	  });');

function init() {
	hxd.System.setCursor(hxd.Cursor.Hide);
	engine.backgroundColor = 0xE4CE9B;
	batch = new SpriteBatch(hxd.Res.layers.toTile(), s2d);
	batch.hasUpdate = true;
	batch.hasRotationScale = true;

	tanks = [new Tank(s2d, batch), new Tank(s2d, batch, 1), new Tank(s2d, batch, 2)];
	tanks[0].controls = Controls.standard();
	tanks[0].x = 200;
	tanks[1].x = 600;
	tanks[2].x = 1000;

	for (tank in tanks) {
		tank.y = 300;
	}

	for (tank in tanks)
		batch.add(tank.shadow);
	for (tank in tanks)
		for (e in tank.tracks)
			batch.add(e);
	for (tank in tanks)
		for (e in tank.body)
			batch.add(e);
	for (tank in tanks)
		for (e in tank.turret)
			batch.add(e);

	final g = new Graphics(s2d);
	shapeDrawer = new HeapsDrawer(g);

	cursor = new Graphics(s2d);
	cursor.beginFill(0xFF0000, 0.5);
	cursor.drawCircle(0, 0, 8);
	trace("start peer system");
	// p2p
	client.on("open", i -> {
		trace(i);
		idText.text = i;
		idButton.shape = idText.getBounds();
		connectButton.y = idButton.height + 40;
		connectButton.visible = true;
		Network.id = i;
	});
	client.on("connection", conn -> {
		final conn:DataConnection = conn;
		Network.peer = conn;
		trace("connected: " + conn.peer);
		conn.on("data", data -> {
			Network.data(data);
		});
		conn.on("error", err -> {
			Network.error(err);
		});
		conn.on("open", () -> {
			Network.open();
		});
	});
	client.on("disconnect", () -> {
		trace("disconnected");
	});
	client.on("close", () -> {
		trace("closed");
	});
	client.on("error", err -> {
		trace(err);
	});
	idButton = new Interactive(200, 40, s2d);
	idButton.onClick = _ -> {
		js.Browser.navigator.clipboard.writeText(Network.id);
	};
	idText = new Text(DefaultFont.get(), idButton);
	idText.scale(4);
	connectButton = new Interactive(40, 20, s2d);
	connectButton.onClick = _ -> {
		final connectId = js.Browser.window.prompt("connect to id");
		if (connectId != "") {
			peer = client.connect(connectId);
			Network.peer = peer;
			peer.on("connection", () -> {
				trace("peer connected!");
			});
			peer.on("data", data -> {
				Network.data(data);
			});
			peer.on("error", err -> {
				Network.error(err);
			});
		}
	};
	final connectText = new Text(DefaultFont.get(), connectButton);
	connectText.text = "connect";
	connectText.scale(4);
	connectButton.shape = connectText.getBounds();
	connectButton.visible = false;
}

function update(dt:Float) {
	cursor.x = s2d.mouseX;
	cursor.y = s2d.mouseY;
	collision(dt);
	for (tank in tanks)
		tank.update(dt);
}

function collision(dt:Float) {
	for (tank in tanks) {
		if (tank.x < 0)
			tank.x = 0;
		if (tank.y < 0)
			tank.y = 0;
		if (tank.x > s2d.width)
			tank.x = s2d.width;
		if (tank.y > s2d.height)
			tank.y = s2d.height;
		for (tank2 in tanks) {
			if (tank == tank2)
				continue;
			final info = Collision.shapeWithShape(tank.bodyCollision, tank2.bodyCollision);
			if (info != null) {
				tank.x += info.separationX;
				tank.y += info.separationY;
			}
		}
	}
}
