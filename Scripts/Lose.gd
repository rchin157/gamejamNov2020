extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var txt = get_node("RichTextLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	txt.text = MultiplayerManager.endingText[MultiplayerManager.loseCondtion]
	Music.stopAll()
	Music.toggleSong(5, true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Music.toggleSong(5, false)
	get_tree().change_scene("res://Level/Main Menu.tscn")
	pass # Replace with function body.
