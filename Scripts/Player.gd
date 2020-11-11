extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var focus = null;
var tooltime = 50;
var velocity = Vector2.ZERO;
var speed = 800;
var local = true;
enum directions {UP, DOWN, LEFT, RIGHT}
var facing = directions.DOWN;
var interact_collide;
var acting = false
var pushing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_collide = get_node("Area2D/Interact");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(local):
		var direction = get_direction();
		calculate_dir(direction)
		velocity = direction*speed;
		if(velocity.length()>0):
			move_and_slide(velocity)
			MultiplayerManager.rpc("update_player_pos",get_position().x,get_position().y)
		check_acting()
		#TogglePushing
		check_pushing()
	pass

func check_pushing():
	if Input.get_action_strength("ui_focus_next"):
		if !pushing: 
			pushing = true;
			set_collision_layer_bit(5,true)
	elif pushing:
		pushing = false
		set_collision_layer_bit(5,false)
	pass

func check_acting():
	var check = Input.get_action_strength("ui_accept")
	if(acting):
		tooltime-=1;
		if(!check):
			tooltime = 50;
			acting = false;
	elif(check):
		tooltime-=1;
		acting = true;
	if(tooltime<=0):
		doAct();
	pass
	
	#YOU STUPID, DO THIS WITH OVERRIDES TOMORROW :
func doAct():
	tooltime = 50;
	match focus.type:
		focus.types.TREE:
			var bundle = load("res://Entities/Item.tscn").instance();
			bundle.set_position(focus.get_position())
			get_parent().add_child(bundle);
			focus._dispose();
			focus = null

func calculate_dir(dir: Vector2):
	var prior = facing;
	if(dir.length() == 1):
		if(dir.x>0):
			facing = directions.RIGHT;
		elif(dir.x<0):
			facing = directions.LEFT;
		elif(dir.y>0):
			facing = directions.DOWN;
		elif(dir.y<0):
			facing = directions.UP;
		if(!prior==facing):
			updateInteract(facing);
	pass

func updateInteract(dir):
	match dir:
		directions.DOWN:
			interact_collide.set_position(Vector2(0,44));
			interact_collide.set_rotation(0);
		directions.UP:
			interact_collide.set_position(Vector2(0,-44));
			interact_collide.set_rotation(0);
		directions.LEFT:
			interact_collide.set_position(Vector2(-44,0));
			interact_collide.set_rotation(PI/2);
		directions.RIGHT:
			interact_collide.set_position(Vector2(44,0));
			interact_collide.set_rotation(PI/2);	

func update_position(px: float, py: float):
	set_position(Vector2(px,py));
	pass;

func set_local(set: bool):
	local = set;

func get_direction()-> Vector2:
	return Vector2(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up"))

#This runs when something is in the interactable range
func _on_Area2D_body_entered(body):
	tooltime =50;
	focus = body;
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if(body == focus):
		focus = null
	pass # Replace with function body.
