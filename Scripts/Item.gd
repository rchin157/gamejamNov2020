extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var food = false
var cooked = false;
var cooking = false;
var foodtime = 5;
var eatCD = 2;
var animator

func _ready():
	animator = get_node("AnimatedSprite")
	pass # Replace with function body.

func remoteWaterLog(index, i, j):
	var level = get_parent()
	level.tiles[i][j] = 4
	level.tileImgs[i][j] = 67
	level.tilemap.set_cell(i, j, 67)
	MultiplayerManager.in_world[index]._dispose()
	pass

func setCooked():
	cooked = true;
	animator.set_frame(1)
	

func toggleFood():
	animator = get_node("AnimatedSprite")
	animator.stop();
	animator.set_animation("meat")
	animator.set_frame(0)
	food = true

func waterLog(displace, collider):
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
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("waterLog",MultiplayerManager.in_world.find(self),posx,posy)
	
	_dispose()

func _process(delta):
	if food:
		eatCD-=delta
		if(eatCD<0):
			eatCD = 0
	if cooking:
		foodtime-=delta
		if(foodtime<=0):
			remoteCooked()

func action_tick(tooltime,delta):
	if eatCD <= 0:
		MultiplayerManager.activeplayer.eatFood(cooked)
		remote_dispose()
	return(tooltime)

func remoteCooked():
	setCooked();
	var index = MultiplayerManager.in_world.find(self)
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("cookFood",index)

func get_pushable():
	return true
	
func get_interactable():
	return food

func attemptPush(displace: Vector2, blacklist):
	blacklist.append(self)
	var initialpos = get_position()
	var initialColl = move_and_slide(displace)
	if(get_slide_count()>0):
		var collider = get_slide_collision(0)
		if collider.collider.get_collision_layer_bit(1) and !food:
			waterLog(displace, collider)
			return
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



func _on_Cooking_area_entered(area):
	if food:
		cooking = true
	pass # Replace with function body.


func _on_Cooking_area_exited(area):
	if food:
		cooking = false
	pass # Replace with function body.
