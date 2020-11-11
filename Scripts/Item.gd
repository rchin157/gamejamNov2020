extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass # Replace with function body.

func attemptPush(displace: Vector2):
	var initialpos = get_position()
	var initialColl = move_and_slide(displace)
	if(get_slide_count()>0):
		var collider = get_slide_collision(0)
		set_position(initialpos)
		var name = collider.collider.get_name()
		var push = get_parent().get_node(name)
		print(push.get_class())
		push.attemptPush(displace);
		move_and_slide(displace)
	#if(initialColl != null):
		#var collisionName = (initialColl as Node).get_name()
		#var collision = get_parent().get_child(collisionName)
		#set_position(initialpos)
	#	collision.attemptPush(displace)
		#move_and_collide(displace)
