extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#Multiplayer stuff
var peer = null;
var peerID
var id;
var playerCount = 4 
var connected = false
var port = 25565;
var is_server = false;
var players = []
var colorList = [];
var names = []
var serverID
var localIndex

var openingMenu;
var activeplayer;
var in_world = [];
var itemSpawner
var level = null;
var random_seed = 0;
var loseCondtion = 0
var endingText = ["One of you starved to death", "One of you froze to death", "One of you got left behind"]


#BIG PP Variables
var truegame = false;
var wins
var distance_travelled
var longest_d
var foods_cooked
var deaths
var missP
var Pded
var treeChop

#Spaghett
var cellsPassed = 24


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	itemSpawner = preload("res://Entities/Item.tscn")
	read_PP_file()
	
func set_id(name: String):
	id = name

func removeInstance(instance):
	var index = in_world.find(instance)
	print("removing world instance at index: "+String(index))
	in_world[index] = null

func addInstance(instance):
	for i in range(0,in_world.size()):
		if in_world[i] == null:
			#This is for debugging remove when done
			in_world[i] = instance
			instance.listIndex = i
			return
	in_world.append(instance)
	if instance.getType() == "item":
		print("item added")
		instance.printIndex()
	#This is for debugging Feel free to remove

func getWorldIndex(instance):
	return in_world.find(instance)

func createServer(port: int):
	peer = NetworkedMultiplayerENet.new();
	peer.create_server(port, playerCount);
	peerID = []
	get_tree().network_peer = peer;
	randomize();
	random_seed = randi()
	is_server = true;
	localIndex = 0;
	
	#setting the first player to be lobby host
	colorList.append(openingMenu.color)
	names.append(openingMenu.name_input.get_text())

func isConnected():
	return connected

func createClient(port: int,Ip: String):
	peer = NetworkedMultiplayerENet.new();
	peer.create_client(Ip,port);
	get_tree().network_peer = peer;

func _player_connected(gid):
	# Called on both clients and server when a peer connects. Send my info to it.
	if(is_server):
		serverConnected(gid)

func serverConnected(gid):
	#peerID.append(gid)
	connected = true
	rpc_id(gid,"setSeed",random_seed)

func clientConnected():
	connected = true
	print("sending registration")
	rpc("registerPlayer",openingMenu.name_input.get_text(),0, openingMenu.color)

func _player_disconnected(gid):
	pass

func _connected_ok():
	clientConnected()
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

#run to give the client a number in the arrays
remote func setLocalIndex(index):
	localIndex = index

remote func cookFood(index):
	if in_world[index] != null : 
		in_world[index].setCooked();

remote func updatePlayerAnimation(state, index):
			players[index].changeState(state)

remote func movePunPun(index, position, animation):
	if level != null:
		var PunPun = in_world[index]
		if PunPun != null:
			PunPun.animator.set_animation(animation)
			PunPun.set_position(position)

func game_ended(win: bool):
	if(win):
		wins+=1
	else:
		deaths+=1
	distance_travelled+=cellsPassed
	if(cellsPassed > longest_d):
		longest_d = cellsPassed
	write_PP()
	

func write_PP():
	var PP = File.new()
	PP.open("user://savegame.save",File.WRITE)
	PP.store_32(wins)
	PP.store_32(distance_travelled)
	PP.store_32(longest_d)
	PP.store_32(foods_cooked)
	PP.store_32(deaths)
	PP.store_32(missP)
	PP.store_32(Pded)
	PP.store_32(treeChop)
	PP.close()

func read_PP_file():
	var PP = File.new()
	if PP.file_exists("user://savegame.save"):
		PP.open("user://savegame.save",File.READ)
		wins = PP.get_32()
		distance_travelled = PP.get_32()
		longest_d = PP.get_32()
		foods_cooked = PP.get_32()
		deaths = PP.get_32()
		missP = PP.get_32()
		Pded = PP.get_32()
		treeChop = PP.get_32()
		PP.close()
	else:
		wins = 0
		distance_travelled = 0
		longest_d = 0
		foods_cooked = 0
		deaths = 0
		missP = 0
		Pded = 0
		treeChop = 0
	pass

remote func registerPlayer(id: String, num: int, color):
	if is_server:
		print("adding a player")
		var sender = get_tree().get_rpc_sender_id()
	#rpc_id(sender,"add_to_lobby",names[0],0,colorList[0])
	#for i in range(0,peerID.size()):
	#	rpc_id(sender,"add_to_lobby",names[i+1],i+1,colorList[i+1])
		print(names.size())
		for i in range(0,names.size()):
			print(names[i])
			rpc_id(sender,"add_to_lobby",names[i],i,colorList[i])
		peerID.append(sender)
		rpc("add_to_lobby",id,peerID.size()-1,color)
		rpc_id(sender,"setLocalIndex",peerID.size())
	add_to_lobby(id,0,color)
	

#Set player is currently rigid, needs to create player instances according to need
remote func add_to_lobby(id: String, num: int, color):
	connected = true
	colorList.append(color)
	names.append(id)
	var index = names.size()-1
	openingMenu.set_player(id,index,color);
	pass

remote func dispose(index):
	if level.get_node(index) !=null:
		level.get_node(index)._dispose();

remote func waterLog(index,i,j ):
	if in_world[index] !=null:
		in_world[index].remoteWaterLog(index, i, j)

remote func setSeed(Seed):
	print("setting seed")
	serverID = get_tree().get_rpc_sender_id()
	random_seed = Seed;

remote func update_player_pos(i,px: float, py: float):
	players[i].update_position(px,py)
	pass

remote func update_object_position(index, px: float, py: float):
	if level.get_node(index) != null:
		level.get_node(index).set_position(Vector2(px,py));

remote func levelEntityAction(index):
	if in_world[index] != null:
		in_world[index].action_finish(true);
	
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

