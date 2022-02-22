package peerjs;

typedef PeerConnectOption = {
	@:optional
	var label : String;
	@:optional
	var metadata : Dynamic;
	@:optional
	var serialization : String;
	@:optional
	var reliable : Bool;
};