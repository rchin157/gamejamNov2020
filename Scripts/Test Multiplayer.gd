extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(MultiplayerManager.is_server):
		MultiplayerManager.listeningPlayer = get_node("Player2");
	else:
		MultiplayerManager.listeningPlayer = get_node("Player");
	MultiplayerManager.listeningPlayer.local= false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
