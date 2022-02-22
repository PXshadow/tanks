import hxd.Key;

typedef Controls = {
	forward:Array<Int>,
	back:Array<Int>,
	left:Array<Int>,
	right:Array<Int>,
	fire:Array<Int>,
}

function standard():Controls
	return {
		forward: [Key.W, Key.UP],
		back: [Key.S, Key.DOWN],
		left: [Key.A, Key.LEFT],
		right: [Key.D, Key.RIGHT],
		fire: [Key.MOUSE_LEFT, Key.MOUSE_RIGHT],
	};
