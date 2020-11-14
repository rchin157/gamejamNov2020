extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var biggestPP = get_node("BigPP")
	biggestPP.set_text(
		"TOTAL WINS: "+str(MultiplayerManager.wins)+
		"\n\nTOTAL DISTANCE TRAVELLED: "+str(MultiplayerManager.distance_travelled)+
		"\n\nSO TASTIES: "+str(MultiplayerManager.foods_cooked)+
		"\n\nOONGLES FILTERED: "+str(MultiplayerManager.deaths)+
		"\n\nPUNPUNS SPARED: "+str(MultiplayerManager.missP)+
		"\n\nOYASUMI PUNPUNS: "+str(MultiplayerManager.Pded)+
		"\n\nTREES PLANTED: "+str(-MultiplayerManager.treeChop)+
		"\n\nFURTHEST KINO: "+str(MultiplayerManager.longest_d)
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_return_pressed():
	get_tree().change_scene("res://Level/Main Menu.tscn")
	pass # Replace with function body.
