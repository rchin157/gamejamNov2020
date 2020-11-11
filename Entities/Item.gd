extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
