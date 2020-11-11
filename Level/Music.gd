extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var musicArray


# Called when the node enters the scene tree for the first time.
func _ready():
	musicArray = [
		get_node("WHACK"),
		get_node("Burning Heart"),
		get_node("ChopA"),
		get_node("ChopB"),
		get_node("Cook"),
		get_node("Game Over"),
		get_node("HuntA"),
		get_node("HuntB"),
		get_node("Lantern Lit"),
		get_node("Lantern Proximity"),
		get_node("Title"),
		get_node("WalkA"),
		get_node("WalkB")
	]
	pass # Replace with function body.

func toggleSong(index: int, state: bool):
	if(musicArray[index].is_playing()):
		if !state:
			stopSong(index)
	elif state:
		enableSong(index)

func enableSong(index: int):
	musicArray[index].play(musicArray[0].get_playback_position())
	
func stopSong(index: int):
	musicArray[index].stop();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
