extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass # Replace with function body.

func attemptPush(displace: Vector2, blacklist):
	blacklist.append(self)
	var initialpos = get_position()
	var initialColl = move_and_slide(displace)
	if(get_slide_count()>0):
		var collider = get_slide_collision(0)
		if collider.collider.get_collision_layer_bit(1):
			var name = collider.collider.get_name()
			var push = get_parent().get_node(name)
			var level = get_parent()
			var posy
			var posx
			if displace.x > 0:
				posx = int(floor((collider.position.x) / 64))
			else:
				posx = int(ceil((collider.position.x) / 64)) - 1
			if displace.y >= 0:
				posy = int(floor((collider.position.y) / 64))
			elif displace.y < 0:
				posy = int(floor((collider.position.y) / 64)) - 1
			
			push.set_cell(posx, posy, 67)
			level.tiles[posx][posy] = 4
			level.tileImgs[posx][posy] = 67
			_dispose()
		else:
			set_position(initialpos)
			var name = collider.collider.get_name()
			var push = get_parent().get_node(name)
			#print(push.get_class())
			if(blacklist.find(push) == -1):
				push.attemptPush(displace,blacklist);
			move_and_slide(displace)
			if(initialpos != get_position()):
				sendPositionDelta()
	#if(initialColl != null):
		#var collisionName = (initialColl as Node).get_name()
		#var collision = get_parent().get_child(collisionName)
		#set_position(initialpos)
	#	collision.attemptPush(displace)
		#move_and_collide(displace)
