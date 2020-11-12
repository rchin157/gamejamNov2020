extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var peer = null;
var id; 
var connected = false
var port = 25565;
var is_server = false;
var openingMenu;
var listeningPlayer;
var activeplayer;
var in_world = [];
var itemSpawner
var level = null;
var random_seed = 0;
var loseCondtion = 0
var endingText = ["One of you starved to death", "One of you froze to death", "One of you got left behind"]
var colorList = [Color(1,1,1),Color(1,1,1)];
var names = ["basic","basic"]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	itemSpawner = preload("res://Entities/Item.tscn")
func set_id(name: String):
	id = name

func createServer(port: int):
	peer = NetworkedMultiplayerENet.new();
	peer.create_server(port, 1);
	get_tree().network_peer = peer;
	randomize();
	random_seed = randi()
	is_server = true;

func isConnected():
	return connected

func createClient(port: int,Ip: String):
	peer = NetworkedMultiplayerENet.new();
	peer.create_client(Ip,port);
	get_tree().network_peer = peer;

func _player_connected(gid):
	# Called on both clients and server when a peer connects. Send my info to it.
	if(is_server):
		rpc("add_to_lobby",id,0, colorList[0])
		rpc("setSeed",random_seed)
	else:
		rpc("add_to_lobby",id,1, colorList[1])
		openingMenu.set_player(id,1,colorList[1]);		

func _player_disconnected(gid):
	pass

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func cookFood(index):
	if MultiplayerManager.level.get_node(index) != null : 
		MultiplayerManager.level.get_node(index).setCooked();

remote func updatePlayerAnimation(state):
	if listeningPlayer != null:
		listeningPlayer.changeState(state)

remote func movePunPun(index, position, animation):
	if MultiplayerManager.level != null:
		var PunPun = MultiplayerManager.level.get_node(index)
		if PunPun != null:
			PunPun.animator.set_animation(animation)
			PunPun.set_position(position)

remote func add_to_lobby(id: String, num: int, color):
	connected = true
	openingMenu.set_player(id,num,color);
	pass

remote func dispose(index):
	if MultiplayerManager.level.get_node(index) !=null:
		MultiplayerManager.level.get_node(index)._dispose();

remote func waterLog(index,i,j ):
	if MultiplayerManager.level.get_node(index) !=null:
		MultiplayerManager.level.get_node(index).remoteWaterLog(index, i, j)

remote func setSeed(Seed):
	random_seed = Seed;

remote func update_player_pos(px: float, py: float):
	if listeningPlayer != null:
		listeningPlayer.update_position(px,py)
	pass

remote func update_object_position(index, px: float, py: float):
	if MultiplayerManager.level.get_node(index) != null:
		MultiplayerManager.level.get_node(index).set_position(Vector2(px,py));

remote func levelEntityAction(index):
	print("you got mail!")
	if MultiplayerManager.level.get_node(index) != null:
		MultiplayerManager.level.get_node(index).action_finish(true);
	
remote func starved():
	activeplayer.starved()
	
remote func froze():
	activeplayer.frozen()
	
remote func leftBehind():
	activeplayer.fellBehind()

remote func toggleSound(index, state):
	if(state):
		Music.enableSong(index)
	else:
		Music.stopSong(index)
	
remote func startGame():
	openingMenu.startgam()

remote func test_connection():
	print("connection works lmao")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

