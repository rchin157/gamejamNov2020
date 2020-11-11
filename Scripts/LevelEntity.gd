extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	MultiplayerManager.in_world.append(self)
	#print(MultiplayerManager.in_world.size())
	pass # Replace with function body.

func _dispose():
	MultiplayerManager.in_world.erase(self)
	queue_free();

func _exit_tree():
	_dispose();

func bounce_back(step :float):
	set_position(Vector2(get_position().x+step,get_position().y))
	if (get_position().x < -50):
		_dispose()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
