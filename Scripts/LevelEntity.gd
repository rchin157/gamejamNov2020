extends KinematicBody2D

enum types {PLAYER,TREE,PUNPUN,ITEM,DEFAULT}
var type = types.DEFAULT;
var listIndex = -1;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Debugging stuffz
	MultiplayerManager.addInstance(self)
	#print(MultiplayerManager.in_world.size())
	pass # Replace with function body.

func _dispose():
	MultiplayerManager.removeInstance(self)
	queue_free();

func printIndex():
	print("index in world is: "+String(MultiplayerManager.in_world.find(self)))


func getType():
	return "default"

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
	var index = MultiplayerManager.getWorldIndex(self)
	MultiplayerManager.rpc("dispose",index)
	_dispose()

func action_finish_remote():
	print("running remote action finish")
	var index = MultiplayerManager.getWorldIndex(self)
	print("index is "+get_name())
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("levelEntityAction",index)

func sendPositionDelta():
	var index = MultiplayerManager.getWorldIndex(self)
	var pos = get_position();
	if(MultiplayerManager.isConnected()):
		MultiplayerManager.rpc("update_object_position",index,pos.x,pos.y)


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
