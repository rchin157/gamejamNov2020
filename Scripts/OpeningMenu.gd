extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ip_input;
var name_input;
var connectScreen;
var lobbyScreen;
var playerList = [];
var port_input
var color 
# Called when the node enters the scene tree for the first time.
func _ready():
	MultiplayerManager.truegame = true
	ip_input = get_node("ConnectScreen/Ip_Input");
	name_input = get_node("ConnectScreen/Name_Input");
	connectScreen = get_node("ConnectScreen")
	lobbyScreen = get_node("LobbyScreen");
	#playerList = [get_node("LobbyScreen/Player1"),get_node("LobbyScreen/Player2")];
	port_input = get_node("ConnectScreen/Port_Input")
	MultiplayerManager.openingMenu = self;
	
	for i in range(1,5):
		playerList.append(get_node("LobbyScreen/Player"+String(i)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gotoLobby(server: bool):
	print("went to lobby")
	MultiplayerManager.set_id(name_input.get_text());
	connectScreen.hide();
	lobbyScreen.show();
	
	#Server Specific Settings
	if (server):
		get_node("LobbyScreen/Start_Button").show();
		set_player(MultiplayerManager.id, 0, color)

func _on_Host_Button_pressed():
	color = get_node("ConnectScreen/Color").color
	MultiplayerManager.createServer(int(port_input.get_text()))
	gotoLobby(true);
	
func set_player(id: String, num: int, color: Color):
	var select = playerList[num];
	select.show();
	select.get_node("PlayerName").set_text(id);
	select.get_node("PlayerSprite/AnimatedSprite").set_modulate(color)
	pass
	

func _on_Connect_Button_pressed():
	color = get_node("ConnectScreen/Color").get_picker().color
	MultiplayerManager.createClient(int(port_input.get_text()),ip_input.get_text())
	#Run a check to ensure that the server is valid first
	gotoLobby(false);
	


func _on_Start_Button_pressed():
	#BEGIN THE GAME
	#enter_debugtown();
	startgam()
	MultiplayerManager.rpc("startGame");
	pass # Replace with function body.

func enter_debugtown():
	get_tree().change_scene("res://Level/Test Multiplayer.tscn");
	pass

func startgam():
	get_tree().change_scene("res://Level/Level.tscn")
