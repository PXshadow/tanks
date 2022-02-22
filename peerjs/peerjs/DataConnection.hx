package peerjs;

typedef DataConnection = {
	function send(data:Dynamic):Void;
	function close():Void;
	@:overload(function(event:String, cb:(data:Dynamic) -> Void):Void { })
	@:overload(function(event:String, cb:() -> Void):Void { })
	@:overload(function(event:String, cb:() -> Void):Void { })
	@:overload(function(event:String, cb:(err:Dynamic) -> Void):Void { })
	function on(event:String, cb:() -> Void):Void;
	function off(event:String, fn:haxe.Constraints.Function, ?once:Bool):Void;
	var dataChannel : js.html.rtc.DataChannel;
	var label : String;
	var metadata : Dynamic;
	var open : Bool;
	var peerConnection : js.html.rtc.PeerConnection;
	var peer : String;
	var reliable : Bool;
	var serialization : String;
	var type : String;
	var bufferSize : Float;
	dynamic function stringify(data:Dynamic):String;
	dynamic function parse(data:String):Dynamic;
};