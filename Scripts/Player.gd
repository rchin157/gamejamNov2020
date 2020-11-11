extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO;
var speed = 8000;
var local = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(local):
		velocity = get_direction()*speed*delta;
		if(velocity.length()>0):
			move_and_slide(velocity)
			MultiplayerManager.rpc("update_player_pos",get_position().x,get_position().y)
	pass

func update_position(px: float, py: float):
	set_position(Vector2(px,py));
	pass;

func set_local(set: bool):
	local = set;

func get_direction()-> Vector2:
	return Vector2(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up"))
