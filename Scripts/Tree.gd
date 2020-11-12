extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animator = get_node("AnimatedSprite")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	type = types.TREE;
	rng.randomize()
	animator.frame = getTreeFrame()
	
func getTreeFrame():
	var val = rng.randi() % 14001
	if val <= 2000:
		return 0
	elif val <= 4000:
		return 1
	elif val <= 6000:
		return 2
	elif val <= 8000:
		return 3
	elif val <= 10000:
		return 4
	elif val <= 12000:
		return 5
	elif val <= 13000:
		return 6
	elif val <= 14000:
		return 7

func _dispose():
	Music.playSFX(5)
	._dispose()

func action_tick(tooltime,delta):
	Music.toggleSong(2,true)
	return .action_tick(tooltime,delta)

func action_finish(rem: bool):
	var drop = MultiplayerManager.itemSpawner.instance();
	var pos = get_position()
	pos.y += 32
	drop.set_position(pos)
	get_parent().add_child(drop)
	Music.toggleSong(2,false)
	if(MultiplayerManager.isConnected() and !rem):
		action_finish_remote();
	_dispose()
	return

func get_interactable():
	return true

func actionStopped():
	Music.toggleSong(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KINO_area_entered(area):
	if animator.get_frame() == 8:
		get_tree().change_scene("res://Level/Win.tscn");
		pass # Replace with function body.
