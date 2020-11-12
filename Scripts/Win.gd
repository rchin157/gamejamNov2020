extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Music.stopAll()
	Music.toggleSong(1, true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Music.toggleSong(1, false)
	get_tree().change_scene("res://Level/Main Menu.tscn")
	pass # Replace with function body.
