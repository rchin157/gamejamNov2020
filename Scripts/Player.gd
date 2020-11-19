extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#dropped this for debugging
const TOOLTIMEMAX = 1;
var focus = [];

var pfocus = null;
var pushfocus = [];

var tooltime = TOOLTIMEMAX;
var velocity = Vector2.ZERO;
var speed = 200;
var local = false;
enum directions {UP, DOWN, LEFT, RIGHT}
var facing = directions.DOWN;
var interact_collide;
var acting = false
var pushing = false

#UI Listener
var UI = null

#variables for hunger
var maxHunger = 120;
var hunger = maxHunger
var hungerState= 8;
const RAWFOOD = 60
const COOKFOOD = 120
var walking = false;
var animationState = 0;
var animator

#variables used for warmth
const PASSIVECOOLING = -1
var campfire = 5
const MAXWARMTH = 30
var warmth = MAXWARMTH
var dwarm = PASSIVECOOLING
var warmthState = 8

var givenName
onready var nametag = get_node("Name")

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_collide = get_node("Area2D/Interact");
	animator = get_node("AnimatedSprite")
	pass # Replace with function body.

func setName(name):
	nametag.set_text(name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(local):
		var direction = get_direction();
		calculate_dir(direction)
		velocity = direction*speed;
		if(velocity.length()>0):
			walking = true;
			Music.toggleSong(11,true)
			move_and_slide(velocity)
			if(MultiplayerManager.isConnected()):
				MultiplayerManager.rpc_unreliable("update_player_pos",MultiplayerManager.localIndex,get_position().x,get_position().y)
		else:
			walking = false;
			Music.toggleSong(11,false)
		if focus.size()>0:
			check_acting(delta)
			if(pushing and pushfocus.size() >0):
				var pvelocity
				if(facing == directions.DOWN or facing == directions.UP):
					pvelocity = Vector2(0,velocity.y)
				else:
					pvelocity = Vector2(velocity.x,0)
				for push in pushfocus:
					push.attemptPush(pvelocity,[])
		
		check_pushing()
		depleteHunger(1*delta)
		updateWarmth(dwarm*delta)
		if get_position().x < 64:
			MultiplayerManager.rpc("leftBehind")
			fellBehind()
		updateAnimation();
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

func updateAnimation():
	#print(int(facing))
	var newState = facing;
	if walking:
		newState = facing+11+int(pushing)*10
	if newState != animationState:
		animationState = newState
		changeState(newState)
		MultiplayerManager.rpc("updatePlayerAnimation",newState,MultiplayerManager.localIndex)
	pass

func changeState(state):
	if state <= 6:
		animator.stop()
	else:
		animator.play()
		match state:
			0,11:
				animator.set_animation("walkUp")
			1,12:
				animator.set_animation("walkDown")
			2,13:
				animator.set_animation("walkLeft")
			3,14:
				animator.set_animation("walkRight")
			21:
				animator.set_animation("pushUp")
			22:
				animator.set_animation("pushDown")
			23:
				animator.set_animation("pushLeft")
			24:
				animator.set_animation("pushRight")
	animator.set_frame(0)	
		

func check_acting(delta):
	var check = Input.get_action_strength("ui_accept")
		
	#var check = Input.get_action_strength("ui_accept")
	if(acting):
		if UI != null and check and acting:
			UI.createProgress(pfocus.get_position())
		tooltime = pfocus.action_tick(tooltime,delta);
		if(!check):
			tooltime = TOOLTIMEMAX;
			acting = false;
			if UI != null and not check:
				UI.removeProgress()
			pfocus.actionStopped()
	elif(check and pfocus != null):
		tooltime = pfocus.action_tick(tooltime,delta);
		acting = true;
	if(tooltime<=0):
		doAct();
	pass
	
	#YOU STUPID, DO THIS WITH OVERRIDES TOMORROW :
func doAct():
	tooltime = TOOLTIMEMAX;
	pfocus.action_finish(false);

func eatFood(cooked: bool):
	Music.playSFX(1)
	if cooked:
		depleteHunger(-COOKFOOD)
	else:
		depleteHunger(-RAWFOOD)

func depleteHunger(amount):
	hunger-=amount
	if hunger>maxHunger:
		hunger = maxHunger
	if(hunger<0):
		hunger = 0
		MultiplayerManager.rpc("starved")
		starved()
	var checkstate = int(9-(hunger/(maxHunger/9)))
	#print(checkstate)
	if(checkstate != hungerState and UI != null):
		UI.updateHunger(checkstate)
		hungerState = checkstate
		
func starved():
	MultiplayerManager.loseCondtion = 0
	get_tree().change_scene("res://Level/Lose.tscn")

func updateWarmth(amount):
	warmth+=amount
	if(warmth>MAXWARMTH):
		warmth = MAXWARMTH
	if(warmth<0):
		warmth = 0
		MultiplayerManager.rpc("froze")
		frozen()
	var checkstate = int(9-(warmth/(MAXWARMTH/9)))
	if(checkstate != warmthState and UI != null):
		UI.updateWarmth(checkstate)
		warmthState = checkstate

func frozen():
	MultiplayerManager.loseCondtion = 1
	get_tree().change_scene("res://Level/Lose.tscn")

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
	
func fellBehind():
	MultiplayerManager.loseCondtion = 2
	get_tree().change_scene("res://Level/Lose.tscn")

func set_local(set: bool):
	local = set;

func get_direction()-> Vector2:
	return Vector2(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up"))

#This runs when something is in the interactable range
func _on_Area2D_body_entered(body):
	focus.append(body)
	calculateFocus();
	calculatePush();
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if(body == pfocus):
		body.actionStopped()
		if UI != null:
			UI.removeProgress();
	focus.erase(body)
	calculateFocus();
	calculatePush();
	pass # Replace with function body.

func _on_warmthZone_area_entered(area):
	print('entered lantern')
	dwarm = campfire
	if local:
		Music.toggleSong(9, true)
	pass # Replace with function body.

func calculatePush():
	pushfocus = []
	for i in range(0,focus.size()):
		if(focus[i].get_pushable()):
			pushfocus.append(focus[i])

func calculateFocus():
	var prior = pfocus
	pfocus = null
	for i in range(0,focus.size()):
		if(focus[i].get_interactable()):
			pfocus = focus[i]
	if prior != pfocus:
		tooltime = TOOLTIMEMAX
	if pfocus == null:
		acting = false
		


func _on_warmthZone_area_exited(area):
	dwarm = PASSIVECOOLING
	if local:
		Music.toggleSong(9, false)
	pass # Replace with function body.
