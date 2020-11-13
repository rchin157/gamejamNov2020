extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var txt = get_node("RichTextLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	txt.text = MultiplayerManager.endingText[MultiplayerManager.loseCondtion]
	Music.stopAll()
	Music.playSFX(6)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Music.stopSFX(6)
	get_tree().change_scene("res://Level/Main Menu.tscn")
	pass # Replace with function body.
