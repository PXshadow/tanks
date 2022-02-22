@:jsRequire("peerjs") extern class Peerjs {
	/**
		A peer can connect to other peers and listen for connections.
	**/
	@:overload(function(options:peerjs.PeerJSOption):Peerjs {})
	function new(?id:String, ?options:peerjs.PeerJSOption);

	var prototype:js.html.RTCIceServer;

	/**
		Connects to the remote peer specified by id and returns a data connection.
	**/
	function connect(id:String, ?options:peerjs.PeerConnectOption):peerjs.DataConnection;

	/**
		Calls the remote peer specified by id and returns a media connection.
	**/
	function call(id:String, stream:js.html.MediaStream, ?options:peerjs.CallOption):peerjs.MediaConnection;

	/**
		Set listeners for peer events.

		Emitted when a connection to the PeerServer is established.

		Emitted when a new data connection is established from a remote peer.

		Emitted when a remote peer attempts to call you.

		Emitted when the peer is destroyed and can no longer accept or create any new connections.

		Emitted when the peer is disconnected from the signalling server

		Errors on the peer are almost always fatal and will destroy the peer.
	**/
	@:overload(function(event:String, cb:(id:String) -> Void):Void {})
	@:overload(function(event:String, cb:(dataConnection:peerjs.DataConnection) -> Void):Void {})
	@:overload(function(event:String, cb:(mediaConnection:peerjs.MediaConnection) -> Void):Void {})
	@:overload(function(event:String, cb:() -> Void):Void {})
	@:overload(function(event:String, cb:() -> Void):Void {})
	@:overload(function(event:String, cb:(err:Dynamic) -> Void):Void {})
	function on(event:String, cb:() -> Void):Void;

	/**
		Remove event listeners.(EventEmitter3)
	**/
	function off(event:String, fn:haxe.Constraints.Function, ?once:Bool):Void;

	/**
		Close the connection to the server, leaving all existing data and media connections intact.
	**/
	function disconnect():Void;

	/**
		Attempt to reconnect to the server with the peer's old ID
	**/
	function reconnect():Void;

	/**
		Close the connection to the server and terminate all existing connections.
	**/
	function destroy():Void;

	/**
		Retrieve a data/media connection for this peer.
	**/
	function getConnection(peerId:String, connectionId:String):Null<ts.AnyOf2<peerjs.DataConnection, peerjs.MediaConnection>>;

	/**
		Get a list of available peer IDs
	**/
	function listAllPeers(callback:(peerIds:Array<String>) -> Void):Void;

	/**
		The brokering ID of this peer
	**/
	var id:String;

	/**
		A hash of all connections associated with this peer, keyed by the remote peer's ID.
	**/
	var connections:Dynamic;

	/**
		false if there is an active connection to the PeerServer.
	**/
	var disconnected:Bool;

	/**
		true if this peer and all of its connections can no longer be used.
	**/
	var destroyed:Bool;

	@:native("prototype")
	static var prototype_:Peerjs;
}
