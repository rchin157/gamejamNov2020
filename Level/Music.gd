extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var musicArray
var syncMusic = [2,6,11]

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
	var synchro = syncMusic.find(index) != -1
	if(musicArray[index].is_playing()):
		if !state:
			stopSong(index)
			if(synchro):
				remoteToggle(index+1,false)
	elif state:
		enableSong(index)
		if(synchro and MultiplayerManager.isConnected()):
				remoteToggle(index+1,true)

func remoteToggle(index: int, state: bool):
	MultiplayerManager.rpc("toggleSound",index, state)

func enableSong(index: int):
	musicArray[index].play(musicArray[0].get_playback_position())
	
func stopSong(index: int):
	musicArray[index].stop();
	
func stopAll():
	for i in range(1, musicArray.size()):
		toggleSong(i, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
