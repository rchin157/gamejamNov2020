extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var food = false
var waterlogger = true;
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
	Music.playSFX(0)
	MultiplayerManager.level.get_node(index)._dispose()
	pass

func setCooked():
	MultiplayerManager.foods_cooked+=1
	Music.playSFX(3)
	cooked = true;
	animator.set_frame(1)
	Music.toggleSong(4, false)

func toggleFood():
	animator = get_node("AnimatedSprite")
	animator.stop();
	animator.set_animation("meat")
	animator.set_frame(0)
	food = true
	waterlogger = false;

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
	Music.playSFX(0)
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("waterLog",get_name(),posx,posy)
	
	_dispose()

func _process(delta):
	if food:
		eatCD-=delta
		if(eatCD<0):
			eatCD = 0
	if cooking and foodtime != -1:
		foodtime-=delta
		if(foodtime<=0):
			foodtime = -1
			remoteCooked()

func action_tick(tooltime,delta):
	if eatCD <= 0:
		MultiplayerManager.activeplayer.eatFood(cooked)
		remote_dispose()
	return(tooltime)

func remoteCooked():
	setCooked();
	var index = get_name()
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
		if collider.collider.get_collision_layer_bit(1):
			if waterlogger:
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
		Music.toggleSong(4, true)
	pass # Replace with function body.


func _on_Cooking_area_exited(area):
	if food:
		cooking = false
		Music.toggleSong(4, false)
	pass # Replace with function body.
