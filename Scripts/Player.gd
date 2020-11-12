extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const TOOLTIMEMAX = 200;
var focus = [];
var pfocus = null;
var tooltime = TOOLTIMEMAX;
var velocity = Vector2.ZERO;
var speed = 800;
var local = true;
enum directions {UP, DOWN, LEFT, RIGHT}
var facing = directions.DOWN;
var interact_collide;
var acting = false
var pushing = false

#UI Listener
var UI = null

#variables for hunger
var maxHunger = 2000;
var hunger = maxHunger
var hungerState= 8;

#variables used for warmth
const PASSIVECOOLING = -1
var campfire = 5
const MAXWARMTH = 2000
var warmth = MAXWARMTH
var dwarm = PASSIVECOOLING
var warmthState = 8

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
			Music.toggleSong(11,true)
			move_and_slide(velocity)
			MultiplayerManager.rpc_unreliable("update_player_pos",get_position().x,get_position().y)
		else:
			Music.toggleSong(11,false)
		if focus.size()>0:
			check_acting()
			if(pushing):
				var pvelocity
				if(facing == directions.DOWN or facing == directions.UP):
					pvelocity = Vector2(0,velocity.y)
				else:
					pvelocity = Vector2(velocity.x,0)
				pfocus.attemptPush(pvelocity,[])
		#TogglePushing
		check_pushing()
		depleteHunger(1)
		updateWarmth(dwarm)
	pass

func check_pushing():
	if Input.get_action_strength("ui_focus_next"):
		if !pushing: 
			pushing = true;
			set_collision_mask_bit(3,true)
	elif pushing:
		pushing = false;
		set_collision_mask_bit(3,false)
		
	pass

func check_acting():
	var check = Input.get_action_strength("ui_accept")
	if !pfocus == focus[0]:
		tooltime = TOOLTIMEMAX
		pfocus = focus[0]
		if UI != null and check:
			UI.createProgress(pfocus.get_position())
	#var check = Input.get_action_strength("ui_accept")
	if(acting):
		tooltime = pfocus.action_tick(tooltime);
		if(!check):
			tooltime = TOOLTIMEMAX;
			acting = false;
			if UI != null and not check:
				UI.removeProgress()
			pfocus.actionStopped()
	elif(check):
		tooltime = pfocus.action_tick(tooltime);
		acting = true;
	if(tooltime<=0):
		doAct();
	pass
	
	#YOU STUPID, DO THIS WITH OVERRIDES TOMORROW :
func doAct():
	tooltime = TOOLTIMEMAX;
	pfocus.action_finish();

func depleteHunger(amount):
	hunger-=amount
	if hunger>maxHunger:
		hunger = maxHunger
	if(hunger<0):
		hunger = 0
	var checkstate = 9-(hunger/(maxHunger/9))
	if(checkstate != hungerState and UI != null):
		UI.updateHunger(checkstate)
		hungerState = checkstate

func updateWarmth(amount):
	warmth+=amount
	if(warmth>MAXWARMTH):
		warmth = MAXWARMTH
	if(warmth<0):
		warmth = 0
	var checkstate = 9-(warmth/(MAXWARMTH/9))
	if(checkstate != warmthState and UI != null):
		UI.updateWarmth(checkstate)
		warmthState = checkstate



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
			pushing = false
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
	focus.append(body)
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if(body == pfocus):
		body.actionStopped()
		if UI != null:
			UI.removeProgress();
	focus.erase(body)
	pass # Replace with function body.

func _on_warmthZone_area_entered(area):
	print('entered lantern')
	dwarm = campfire
	pass # Replace with function body.


func _on_warmthZone_area_exited(area):
	dwarm = PASSIVECOOLING
	pass # Replace with function body.
