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

func action_finish():
	print('generic task complete notification')
	var drop = MultiplayerManager.itemSpawner.instance();
	drop.set_position(get_position())
	get_parent().add_child(drop)
	Music.toggleSong(2,false)
	_dispose()
	return

func actionStopped():
	Music.toggleSong(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
