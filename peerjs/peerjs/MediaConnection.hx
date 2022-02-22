package peerjs;

typedef MediaConnection = {
	function answer(?stream:js.html.MediaStream, ?options:AnswerOption):Void;
	function close():Void;
	@:overload(function(event:String, cb:(stream:js.html.MediaStream) -> Void):Void { })
	@:overload(function(event:String, cb:() -> Void):Void { })
	@:overload(function(event:String, cb:(err:Dynamic) -> Void):Void { })
	function on(event:String, cb:() -> Void):Void;
	function off(event:String, fn:haxe.Constraints.Function, ?once:Bool):Void;
	var open : Bool;
	var metadata : Dynamic;
	var peerConnection : js.html.rtc.PeerConnection;
	var peer : String;
	var type : String;
};