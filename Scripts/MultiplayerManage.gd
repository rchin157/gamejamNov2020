extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var peer;
var port = 25565;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func createServer():
	peer = NetworkedMultiplayerENet.new();
	peer.create_server(port, 1);
	get_tree().network_peer = peer;
	
func createClient(Ip: String):
	peer = NetworkedMultiplayerENet.new();
	peer.create_client(Ip,port);
	get_tree().network_peer = peer;

remote func test_connection():
	print("connection works lmao")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
