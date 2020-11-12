extends KinematicBody2D

enum types {PLAYER,TREE,PUNPUN,ITEM,DEFAULT}
var type = types.DEFAULT;
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
	
func action_tick(tooltime,delta):
	return tooltime-delta

func action_finish(rem: bool):
	print('generic task complete notification')
	return

func attemptPush(displace: Vector2, blacklist):
	pass

func actionStopped():
	pass
#Disposes locally and remotely
func remote_dispose():
	var index = MultiplayerManager.in_world.find(self)
	MultiplayerManager.rpc("dispose",index)
	_dispose()

func action_finish_remote():
	var index = MultiplayerManager.in_world.find(self)
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("levelEntityAction",index)

func sendPositionDelta():
	var index = MultiplayerManager.in_world.find(self)
	var pos = get_position();
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("update_object_position",index,pos.x,pos.y)

func _exit_tree():
	_dispose();

func get_pushable():
	return false
	

func get_interactable():
	return false

func bounce_back(step :float):
	set_position(Vector2(get_position().x+step,get_position().y))
	#move_and_slide(Vector2(step,0))
	if (get_position().x < -50):
		_dispose()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
