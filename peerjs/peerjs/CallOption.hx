package peerjs;

typedef CallOption = {
	@:optional
	var metadata : Dynamic;
	@:optional
	var sdpTransform : haxe.Constraints.Function;
};