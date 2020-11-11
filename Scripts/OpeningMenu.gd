extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ip_input;
var name_input;
var connectScreen;
var lobbyScreen;
var playerList = [null,null];

# Called when the node enters the scene tree for the first time.
func _ready():
	ip_input = get_node("ConnectScreen/Ip_Input");
	name_input = get_node("ConnectScreen/Name_Input");
	connectScreen = get_node("ConnectScreen")
	lobbyScreen = get_node("LobbyScreen");
	playerList = [get_node("LobbyScreen/Player1"),get_node("LobbyScreen/Player2")];
	MultiplayerManager.openingMenu = self;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gotoLobby(server: bool):
	MultiplayerManager.set_id(name_input.get_text());
	connectScreen.hide();
	lobbyScreen.show();
	
	#Server Specific Settings
	if (server):
		get_node("LobbyScreen/Start_Button").show();
		set_player(MultiplayerManager.id, 0)

func _on_Host_Button_pressed():
	MultiplayerManager.createServer()
	gotoLobby(true);
	
func set_player(id: String, num: int):
	var select = playerList[num];
	select.show();
	select.get_node("PlayerName").set_text(id);
	pass
	

func _on_Connect_Button_pressed():
	MultiplayerManager.createClient(ip_input.get_text())
	#Run a check to ensure that the server is valid first
	gotoLobby(false);
	


func _on_Start_Button_pressed():
	#BEGIN THE GAME
	pass # Replace with function body.
