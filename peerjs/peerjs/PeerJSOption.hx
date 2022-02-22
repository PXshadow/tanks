package peerjs;

typedef PeerJSOption = {
	@:optional
	var key : String;
	@:optional
	var host : String;
	@:optional
	var port : Float;
	@:optional
	var path : String;
	@:optional
	var secure : Bool;
	@:optional
	var config : js.html.RTCConfiguration;
	@:optional
	var debug : Float;
};