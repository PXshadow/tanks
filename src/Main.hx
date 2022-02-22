function main() {
	new Main();
}

class Main extends hxd.App {
	override function init() {
		super.init();
		hxd.Res.initEmbed();
		Game.s2d = s2d;
		Game.engine = engine;
		Game.sevents = sevents;
		Game.init();
	}

	override function update(dt:Float) {
		super.update(dt);
		Game.update(dt);
	}
}
