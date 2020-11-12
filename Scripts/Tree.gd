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
	animator.frame = rng.randi_range(0, 9)

func action_tick(tooltime):
	Music.toggleSong(2,true)
	return .action_tick(tooltime)

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

func actionStopped():
	Music.toggleSong(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
