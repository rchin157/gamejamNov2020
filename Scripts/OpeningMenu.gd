extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ip_input;
var connectScreen;

# Called when the node enters the scene tree for the first time.
func _ready():
	ip_input = get_node("ConnectScreen/Ip_Input");
	connectScreen = get_node("ConnectScreen")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gotoLobby():
	connectScreen.hide();

func _on_Host_Button_pressed():
	MultiplayerManager.createServer()
	gotoLobby();
	


func _on_Connect_Button_pressed():
	MultiplayerManager.createClient(ip_input.get_text())
	#Run a check to ensure that the server is valid first
	gotoLobby();
	MultiplayerManager.rpc("test_connection")
	
